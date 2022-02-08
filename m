Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D864ADEEF
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 18:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383714AbiBHRIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 12:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383626AbiBHRIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 12:08:31 -0500
Received: from nef.ens.fr (nef2.ens.fr [129.199.96.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27344C061576
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 09:08:30 -0800 (PST)
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1644337919; bh=rqZhpVrbVrs2npaoKtNtrRr0I2HSo5TWQ93nQB9Ac98=;
        h=From:To:Cc:Subject:Date:From;
        b=lEQegoWRIRBzb0lPEMbsPy+oBwBXdHMCKvP4CuiSsjKAaMc3q+abTCLEwleq30hUE
         mxkjL8xXOdHoivCRLTjJYGrCsgX6IUQEI3/rl+fnPSTuTgb8bZE81Psf6DQ3Oa7mgR
         uZZFqVIFbHRjQUUr9FnjHU9Cg3uhS8xktqcad8Zw=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 218GVw1M007768
          ; Tue, 8 Feb 2022 17:31:58 +0100
Received: from  optiplex-7.sg.lan using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 218GVs8u094603 ; Tue, 8 Feb 2022 17:31:58 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
To:     gregkh@linuxfoundation.org
Cc:     guillaume.bertholon@ens.fr, stable@vger.kernel.org
Subject: [PATCH 4.9] ALSA: line6: Fix misplaced backport of "Fix wrong altsetting for LINE6_PODHD500_1"
Date:   Tue,  8 Feb 2022 17:31:15 +0100
Message-Id: <1644337875-22219-1-git-send-email-guillaume.bertholon@ens.fr>
X-Mailer: git-send-email 2.7.4
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Tue, 08 Feb 2022 17:31:59 +0100 (CET)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The upstream commit 70256b42caaf ("ALSA: line6: Fix wrong altsetting for
LINE6_PODHD500_1") changed the .altsetting field of the LINE6_PODHD500_1
entry in podhd_properties_table from 1 to 0.

However, its backported version in stable (commit ec565611f930 ("ALSA:
line6: Fix wrong altsetting for LINE6_PODHD500_1")) change the
.altsetting field of the LINE6_PODHD500_0 entry instead.

This patch resets the altsetting of LINE6_PODHD500_0 to 1, and sets the
altsetting of LINE6_PODHD500_1 to 0, as wanted by the original fix.

Fixes: ec565611f930 ("ALSA: line6: Fix wrong altsetting for LINE6_PODHD500_1")
Signed-off-by: Guillaume Bertholon <guillaume.bertholon@ens.fr>
---
 sound/usb/line6/podhd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/usb/line6/podhd.c b/sound/usb/line6/podhd.c
index 7133c36..b3abc4c 100644
--- a/sound/usb/line6/podhd.c
+++ b/sound/usb/line6/podhd.c
@@ -385,7 +385,7 @@ static const struct line6_properties podhd_properties_table[] = {
 		.name = "POD HD500",
 		.capabilities	= LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
-		.altsetting = 0,
+		.altsetting = 1,
 		.ep_ctrl_r = 0x81,
 		.ep_ctrl_w = 0x01,
 		.ep_audio_r = 0x86,
@@ -396,7 +396,7 @@ static const struct line6_properties podhd_properties_table[] = {
 		.name = "POD HD500",
 		.capabilities	= LINE6_CAP_PCM
 				| LINE6_CAP_HWMON,
-		.altsetting = 1,
+		.altsetting = 0,
 		.ep_ctrl_r = 0x81,
 		.ep_ctrl_w = 0x01,
 		.ep_audio_r = 0x86,
--
2.7.4

