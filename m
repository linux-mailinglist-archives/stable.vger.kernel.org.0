Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A4FD451395
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348462AbhKOTxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:53:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343655AbhKOTVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9330B63267;
        Mon, 15 Nov 2021 18:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001837;
        bh=Ac8AQVsQnwRVrk4Q+kV1XM5IF+5ee2OYX8g8G5sNrAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BiN1SyjaB9dhDbqbTcKUaEpZSLmJFhMsRhMApAcYi1kGoa5AY36Syld1oOYgWTrkp
         AUC4prLAZI0Z8skZ+Ev+oi/RHB/ThJMUyqiOcDE1lJ7dvkJ847OI5CmunP+NVhsJIT
         TO9pEAe2BI3oNW1TSY+SjPxeVUDH4ccbL0oS0OcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 338/917] crypto: sm4 - Do not change section of ck and sbox
Date:   Mon, 15 Nov 2021 17:57:13 +0100
Message-Id: <20211115165440.212228401@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 4a7e1e5fc294687a8941fa3eeb4a7e8539ca5e2f ]

When building with clang and GNU as, there is a warning about ignored
changed section attributes:

/tmp/sm4-c916c8.s: Assembler messages:
/tmp/sm4-c916c8.s:677: Warning: ignoring changed section attributes for
.data..cacheline_aligned

"static const" places the data in .rodata but __cacheline_aligned has
the section attribute to place it in .data..cacheline_aligned, in
addition to the aligned attribute.

To keep the alignment but avoid attempting to change sections, use the
____cacheline_aligned attribute, which is just the aligned attribute.

Fixes: 2b31277af577 ("crypto: sm4 - create SM4 library based on sm4 generic code")
Link: https://github.com/ClangBuiltLinux/linux/issues/1441
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/crypto/sm4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/sm4.c b/lib/crypto/sm4.c
index 633b59fed9db8..284e62576d0c6 100644
--- a/lib/crypto/sm4.c
+++ b/lib/crypto/sm4.c
@@ -15,7 +15,7 @@ static const u32 fk[4] = {
 	0xa3b1bac6, 0x56aa3350, 0x677d9197, 0xb27022dc
 };
 
-static const u32 __cacheline_aligned ck[32] = {
+static const u32 ____cacheline_aligned ck[32] = {
 	0x00070e15, 0x1c232a31, 0x383f464d, 0x545b6269,
 	0x70777e85, 0x8c939aa1, 0xa8afb6bd, 0xc4cbd2d9,
 	0xe0e7eef5, 0xfc030a11, 0x181f262d, 0x343b4249,
@@ -26,7 +26,7 @@ static const u32 __cacheline_aligned ck[32] = {
 	0x10171e25, 0x2c333a41, 0x484f565d, 0x646b7279
 };
 
-static const u8 __cacheline_aligned sbox[256] = {
+static const u8 ____cacheline_aligned sbox[256] = {
 	0xd6, 0x90, 0xe9, 0xfe, 0xcc, 0xe1, 0x3d, 0xb7,
 	0x16, 0xb6, 0x14, 0xc2, 0x28, 0xfb, 0x2c, 0x05,
 	0x2b, 0x67, 0x9a, 0x76, 0x2a, 0xbe, 0x04, 0xc3,
-- 
2.33.0



