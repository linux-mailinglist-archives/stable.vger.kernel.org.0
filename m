Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC43012CA42
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfL2RW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:22:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726658AbfL2RW0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:22:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EF58207FD;
        Sun, 29 Dec 2019 17:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640145;
        bh=0Gybm7l43eGqhyVETCvyuH6F8el7S/oOIAMXjqiNJeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iV2HjVGP3706P2remmRbykcY1JKKEkU4BC9AWCluDziwGMTckCRWbzP2NeHJEPdk/
         Y4kZLCAUXo6Pbm3xASM84NX0Yl1AHcQCr7EQg5BpURcgF/O+fAhK/T43/lPQWn1cGM
         R95QkPvP7uL/0jp63GWq18v1jsRjUmOSCdBlB/Q4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@linaro.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 036/161] media: venus: core: Fix msm8996 frequency table
Date:   Sun, 29 Dec 2019 18:18:04 +0100
Message-Id: <20191229162410.186246630@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 769e9e68562d..9360b36b82cd 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -345,10 +345,11 @@ static const struct venus_resources msm8916_res = {
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



