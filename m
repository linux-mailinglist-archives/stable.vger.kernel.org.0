Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35610119A60
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbfLJVHq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:07:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbfLJVHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:07:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC18D20836;
        Tue, 10 Dec 2019 21:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012065;
        bh=wsJErOlEJj8NVasY0qcfuXIC3T5Btp8ye5MSynVvqc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=No3E1rpf3YFBg8rjo5bGavSvBkPckLqVqppfyqS/Pv0m1lobWdCkyZ7uRsTGAlyCD
         Z+IBXN2d5ztVyDczxrzc/QDLTgvsEvGoRm4q2KRf+tTF3ID4f+EXAh4ud9qbWeaZAh
         hvkOZBPlvYJAgIhNUjs3MMeaaLG2tZTfOboIXnxo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Loic Poulain <loic.poulain@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 047/350] media: venus: core: Fix msm8996 frequency table
Date:   Tue, 10 Dec 2019 16:02:32 -0500
Message-Id: <20191210210735.9077-8-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit c690435ed07901737e5c007a65ec59f53b33eb71 ]

In downstream driver, there are two frequency tables defined,
one for the encoder and one for the decoder:

/* Encoders /
<972000 490000000 0x55555555>, / 4k UHD @ 30 /
<489600 320000000 0x55555555>, / 1080p @ 60 /
<244800 150000000 0x55555555>, / 1080p @ 30 /
<108000 75000000 0x55555555>, / 720p @ 30 */

/* Decoders /
<1944000 490000000 0xffffffff>, / 4k UHD @ 60 /
< 972000 320000000 0xffffffff>, / 4k UHD @ 30 /
< 489600 150000000 0xffffffff>, / 1080p @ 60 /
< 244800 75000000 0xffffffff>; / 1080p @ 30 */

It shows that encoder always needs a higher clock than decoder.

In current venus driver, the unified frequency table is aligned
with the downstream decoder table which causes performance issues
in encoding scenarios. Fix that by aligning frequency table on
worst case (encoding).

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index e6eff512a8a14..84e982f259a06 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -427,10 +427,11 @@ static const struct venus_resources msm8916_res = {
 };
 
 static const struct freq_tbl msm8996_freq_table[] = {
-	{ 1944000, 490000000 },	/* 4k UHD @ 60 */
-	{  972000, 320000000 },	/* 4k UHD @ 30 */
-	{  489600, 150000000 },	/* 1080p @ 60 */
-	{  244800,  75000000 },	/* 1080p @ 30 */
+	{ 1944000, 520000000 },	/* 4k UHD @ 60 (decode only) */
+	{  972000, 520000000 },	/* 4k UHD @ 30 */
+	{  489600, 346666667 },	/* 1080p @ 60 */
+	{  244800, 150000000 },	/* 1080p @ 30 */
+	{  108000,  75000000 },	/* 720p @ 30 */
 };
 
 static const struct reg_val msm8996_reg_preset[] = {
-- 
2.20.1

