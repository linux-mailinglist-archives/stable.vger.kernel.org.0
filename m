Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D75F4A9F
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733138AbfKHLjM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:39:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:52116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733122AbfKHLjK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:39:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 975EF222C2;
        Fri,  8 Nov 2019 11:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213150;
        bh=z42NMZtRegQyAv3PPGmyHQ/taWk4UXkfZVgfVcUHReg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kd9yJOdOfSy+ANIfAmpfTV/vNHkFRbxToUGg8vL0ldej2shjAl2N57T4+l3wNp06g
         BfF/wN4NTEf5DKAAivkU+VV0s6R2jSpyhZ9eTWWQdduYxEGzu69MPZwy1IiVtlvXfS
         pU8onYvDpoeMcseFaA0nFsfm9G9uFEA4a0bYSxc4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans Verkuil <hverkuil@xs4all.nl>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 059/205] media: vicodec: fix out-of-range values when decoding
Date:   Fri,  8 Nov 2019 06:35:26 -0500
Message-Id: <20191108113752.12502-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans Verkuil <hverkuil@xs4all.nl>

[ Upstream commit be5a1509af8dd8a78fea24a35fe4a82d4cd0ae70 ]

While decoding you need to make sure you do not get values < 0
or > 255. Note that since this code will also be used in userspace
utilities the clamp macro isn't used since that is kernel-only.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vicodec/vicodec-codec.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-codec.c b/drivers/media/platform/vicodec/vicodec-codec.c
index 2d047646f6147..d854b2344f12b 100644
--- a/drivers/media/platform/vicodec/vicodec-codec.c
+++ b/drivers/media/platform/vicodec/vicodec-codec.c
@@ -588,8 +588,14 @@ static void fill_decoder_block(u8 *dst, const s16 *input, int stride)
 	int i, j;
 
 	for (i = 0; i < 8; i++) {
-		for (j = 0; j < 8; j++)
-			*dst++ = *input++;
+		for (j = 0; j < 8; j++, input++, dst++) {
+			if (*input < 0)
+				*dst = 0;
+			else if (*input > 255)
+				*dst = 255;
+			else
+				*dst = *input;
+		}
 		dst += stride - 8;
 	}
 }
-- 
2.20.1

