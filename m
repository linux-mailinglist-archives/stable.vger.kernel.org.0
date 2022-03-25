Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09264E773B
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352532AbiCYP1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377465AbiCYPYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D63DEA3;
        Fri, 25 Mar 2022 08:18:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AE226B827DC;
        Fri, 25 Mar 2022 15:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07766C340EE;
        Fri, 25 Mar 2022 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221481;
        bh=dlt1A1biLcVDgMxTU/Y7y85mBaY6WRz6rpXrh1D3VB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0hhstwjCKrg7Lzh69/uqFyJqudTRbJD0eu8W+Cm6XAvzZ0K4WdS9zQeWxRlo2eyJj
         4sl6xsJ0M0+gXxJ6xe4L8MB4MGxr/nOaKnx8gpUM6L/SGFP/O4DykFfFr6MMvcR42s
         3aasYRC+ArXYbvA18EzpzW0TX+B2mICFDVqZR2oA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Teh <jonathan.teh@outlook.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 19/37] ALSA: cmipci: Restore aux vol on suspend/resume
Date:   Fri, 25 Mar 2022 16:14:29 +0100
Message-Id: <20220325150420.595406186@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.046488912@linuxfoundation.org>
References: <20220325150420.046488912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Teh <jonathan.teh@outlook.com>

commit c14231cc04337c2c2a937db084af342ce704dbde upstream.

Save and restore CM_REG_AUX_VOL instead of register 0x24 twice on
suspend/resume.

Tested on CMI8738LX.

Fixes: cb60e5f5b2b1 ("[ALSA] cmipci - Add PM support")
Signed-off-by: Jonathan Teh <jonathan.teh@outlook.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/DBAPR04MB7366CB3EA9C8521C35C56E8B920E9@DBAPR04MB7366.eurprd04.prod.outlook.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/cmipci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -298,7 +298,6 @@ MODULE_PARM_DESC(joystick_port, "Joystic
 #define CM_MICGAINZ		0x01	/* mic boost */
 #define CM_MICGAINZ_SHIFT	0
 
-#define CM_REG_MIXER3		0x24
 #define CM_REG_AUX_VOL		0x26
 #define CM_VAUXL_MASK		0xf0
 #define CM_VAUXR_MASK		0x0f
@@ -3265,7 +3264,7 @@ static int snd_cmipci_probe(struct pci_d
  */
 static const unsigned char saved_regs[] = {
 	CM_REG_FUNCTRL1, CM_REG_CHFORMAT, CM_REG_LEGACY_CTRL, CM_REG_MISC_CTRL,
-	CM_REG_MIXER0, CM_REG_MIXER1, CM_REG_MIXER2, CM_REG_MIXER3, CM_REG_PLL,
+	CM_REG_MIXER0, CM_REG_MIXER1, CM_REG_MIXER2, CM_REG_AUX_VOL, CM_REG_PLL,
 	CM_REG_CH0_FRAME1, CM_REG_CH0_FRAME2,
 	CM_REG_CH1_FRAME1, CM_REG_CH1_FRAME2, CM_REG_EXT_MISC,
 	CM_REG_INT_STATUS, CM_REG_INT_HLDCLR, CM_REG_FUNCTRL0,


