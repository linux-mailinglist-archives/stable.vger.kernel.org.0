Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE3112F4BD
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387451AbfE3ElI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:41:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729024AbfE3DM1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:27 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 129FA23CCB;
        Thu, 30 May 2019 03:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185946;
        bh=R+1SEPBkQ9tLiLcev28eLtWcpov6GKMZtJNoicwTjOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Y4mU5bvmXpYV9OOhF/flQhwNUojUgPvZ7FC3I7tg6VPdPK0iOIbnFW7AOv6rDkn1
         NrtxCEsB+vjoLDFDRuVmTWjaY8PexGBQcmA5TNX7/c6lvf0+jyva/496lz4LdAAHWF
         LBrbe9elui9EOcdgdTNfF+WJN3BsSuFTTaMpEV+Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 355/405] media: vicodec: avoid clang frame size warning
Date:   Wed, 29 May 2019 20:05:53 -0700
Message-Id: <20190530030558.602845501@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e855165f3dae6f71da859a5f00b85d5368641d61 ]

Clang-9 makes some different inlining decisions compared to gcc, which
leads to a warning about a possible stack overflow problem when building
with CONFIG_KASAN, including when setting asan-stack=0, which avoids
most other frame overflow warnings:

drivers/media/platform/vicodec/codec-fwht.c:673:12: error: stack frame size of 2224 bytes in function 'encode_plane'

Manually adding noinline_for_stack annotations in those functions
called by encode_plane() or decode_plane() that require a significant
amount of kernel stack makes this impossible to happen with any
compiler.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vicodec/codec-fwht.c | 29 +++++++++++++--------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/vicodec/codec-fwht.c b/drivers/media/platform/vicodec/codec-fwht.c
index d1d6085da9f1d..cf469a1191aa7 100644
--- a/drivers/media/platform/vicodec/codec-fwht.c
+++ b/drivers/media/platform/vicodec/codec-fwht.c
@@ -46,8 +46,12 @@ static const uint8_t zigzag[64] = {
 	63,
 };
 
-
-static int rlc(const s16 *in, __be16 *output, int blocktype)
+/*
+ * noinline_for_stack to work around
+ * https://bugs.llvm.org/show_bug.cgi?id=38809
+ */
+static int noinline_for_stack
+rlc(const s16 *in, __be16 *output, int blocktype)
 {
 	s16 block[8 * 8];
 	s16 *wp = block;
@@ -106,8 +110,8 @@ static int rlc(const s16 *in, __be16 *output, int blocktype)
  * This function will worst-case increase rlc_in by 65*2 bytes:
  * one s16 value for the header and 8 * 8 coefficients of type s16.
  */
-static u16 derlc(const __be16 **rlc_in, s16 *dwht_out,
-		 const __be16 *end_of_input)
+static noinline_for_stack u16
+derlc(const __be16 **rlc_in, s16 *dwht_out, const __be16 *end_of_input)
 {
 	/* header */
 	const __be16 *input = *rlc_in;
@@ -240,8 +244,9 @@ static void dequantize_inter(s16 *coeff)
 			*coeff <<= *quant;
 }
 
-static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
-		 unsigned int input_step, bool intra)
+static void noinline_for_stack fwht(const u8 *block, s16 *output_block,
+				    unsigned int stride,
+				    unsigned int input_step, bool intra)
 {
 	/* we'll need more than 8 bits for the transformed coefficients */
 	s32 workspace1[8], workspace2[8];
@@ -373,7 +378,8 @@ static void fwht(const u8 *block, s16 *output_block, unsigned int stride,
  * Furthermore values can be negative... This is just a version that
  * works with 16 signed data
  */
-static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
+static void noinline_for_stack
+fwht16(const s16 *block, s16 *output_block, int stride, int intra)
 {
 	/* we'll need more than 8 bits for the transformed coefficients */
 	s32 workspace1[8], workspace2[8];
@@ -456,7 +462,8 @@ static void fwht16(const s16 *block, s16 *output_block, int stride, int intra)
 	}
 }
 
-static void ifwht(const s16 *block, s16 *output_block, int intra)
+static noinline_for_stack void
+ifwht(const s16 *block, s16 *output_block, int intra)
 {
 	/*
 	 * we'll need more than 8 bits for the transformed coefficients
@@ -604,9 +611,9 @@ static int var_inter(const s16 *old, const s16 *new)
 	return ret;
 }
 
-static int decide_blocktype(const u8 *cur, const u8 *reference,
-			    s16 *deltablock, unsigned int stride,
-			    unsigned int input_step)
+static noinline_for_stack int
+decide_blocktype(const u8 *cur, const u8 *reference, s16 *deltablock,
+		 unsigned int stride, unsigned int input_step)
 {
 	s16 tmp[64];
 	s16 old[64];
-- 
2.20.1



