Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EDBD111DE5
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730454AbfLCW6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:58:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:54226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbfLCW6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:58:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0298420674;
        Tue,  3 Dec 2019 22:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413884;
        bh=pz78iwdXUENbZcbYUMALJIFQGQOKoTGxA9AdC7L3WZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5YgEhrs2Kpz8NO52MNXovF+B7aiHGjNAew6fV3mDeJ2AtspGk5urCiZZz8kaXJCy
         tCNoXS09Qmjz16aXS6bGYeN12WTk1+OHOa8HgxR/6tgRv10Ye/mzY2S6VXC1sfm8Pt
         OSPxrADFoBARV7Mae8FPt7FGxv4GKM4gr6N4Gn2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Wang <hui.wang@canonical.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 259/321] ASoC: rt5645: Headphone Jack sense inverts on the LattePanda board
Date:   Tue,  3 Dec 2019 23:35:25 +0100
Message-Id: <20191203223440.607002578@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 406dcbc55a0a20fd155be889a4a0c4b812f7c18e ]

The LattePanda board has a sound card chtrt5645, when there is nothing
plugged in the headphone jack, the system thinks the headphone is
plugged in, while we plug a headphone in the jack, the system thinks
the headphone is unplugged.

If adding quirk=0x21 in the module parameter, the headphone jack can
work well. So let us fix it via platform_data.

https://bugs.launchpad.net/bugs/182459
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5645.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/soc/codecs/rt5645.c b/sound/soc/codecs/rt5645.c
index 1dc70f452c1b9..f842db498c741 100644
--- a/sound/soc/codecs/rt5645.c
+++ b/sound/soc/codecs/rt5645.c
@@ -3662,6 +3662,11 @@ static const struct rt5645_platform_data jd_mode3_platform_data = {
 	.jd_mode = 3,
 };
 
+static const struct rt5645_platform_data lattepanda_board_platform_data = {
+	.jd_mode = 2,
+	.inv_jd1_1 = true
+};
+
 static const struct dmi_system_id dmi_platform_data[] = {
 	{
 		.ident = "Chrome Buddy",
@@ -3759,6 +3764,15 @@ static const struct dmi_system_id dmi_platform_data[] = {
 		},
 		.driver_data = (void *)&intel_braswell_platform_data,
 	},
+	{
+		.ident = "LattePanda board",
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+		  DMI_EXACT_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+		  DMI_EXACT_MATCH(DMI_BOARD_VERSION, "Default string"),
+		},
+		.driver_data = (void *)&lattepanda_board_platform_data,
+	},
 	{ }
 };
 
-- 
2.20.1



