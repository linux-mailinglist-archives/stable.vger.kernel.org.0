Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0FB63578D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbiKWJnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238109AbiKWJmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:42:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E91113737
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:40:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1096B81EF0
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300CBC433D6;
        Wed, 23 Nov 2022 09:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196412;
        bh=Xr2JnALXiCEHV6yOKw+uqHFWEolwa49PFgHJkuLuG2o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vCE+zpJEu81lcqilIGnBfjJq4P6E+GQC6G+2Dsq3nI6eai4YLJ40rB/a75OidaeKT
         3jZ6D5aj1Dq3Y9XWOiCGSSZjKPVx9OqfuS2Yk0CW/6cOMJduFqEUlr8JBkkDMl1nW8
         R7ihm5Qnkulwwboq75mdrI9uN2iWGR62dyPipr8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linkt <xazrael@hotmail.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 023/314] ASoC: amd: yc: Adding Lenovo ThinkBook 14 Gen 4+ ARA and Lenovo ThinkBook 16 Gen 4+ ARA to the Quirks List
Date:   Wed, 23 Nov 2022 09:47:48 +0100
Message-Id: <20221123084626.545317575@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: linkt <xazrael@hotmail.com>

[ Upstream commit a450b5c8739248069e11f72129fca61a56125577 ]

Lenovo ThinkBook 14 Gen 4+ ARA and ThinkBook 16 Gen 4+ ARA
need to be added to the list of quirks for the microphone to work properly.

Signed-off-by: linkt <xazrael@hotmail.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/MEYPR01MB8397A3C27DE6206FA3EF834DB6239@MEYPR01MB8397.ausprd01.prod.outlook.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 2cb50d5cf1a9..09a8aceff22f 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -45,6 +45,20 @@ static struct snd_soc_card acp6x_card = {
 };
 
 static const struct dmi_system_id yc_acp_quirk_table[] = {
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D0"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "21D1"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.35.1



