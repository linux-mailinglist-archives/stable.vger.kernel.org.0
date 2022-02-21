Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4CC4BE75A
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351804AbiBUJw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:52:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351843AbiBUJwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:52:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DCF3615D;
        Mon, 21 Feb 2022 01:23:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F421A60F3C;
        Mon, 21 Feb 2022 09:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1760C340E9;
        Mon, 21 Feb 2022 09:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435380;
        bh=g/HgtpBBObGeQPvjdrbi8IklQvypj/Rpp30Wgl/uAwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n73kA2ZsNn431Dpo9pEafyQLgSQgoE6d/Y/ndmsdhK8GEs5LVJEnLL1ySoc3olJDp
         +2SLsOjv2m7D5JAhzBssnpK84bxkCSBChbXtLyUxUWrh+aRJynqCdXuvFR3s9Rb+n7
         PuVrsT11JKcXUZklTPutY0ZCqQTuFK62+lIe3bIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, dmummenschanz@web.de,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.16 142/227] ALSA: hda: Fix missing codec probe on Shenker Dock 15
Date:   Mon, 21 Feb 2022 09:49:21 +0100
Message-Id: <20220221084939.559773882@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit dd8e5b161d7fb9cefa1f1d6e35a39b9e1563c8d3 upstream.

By some unknown reason, BIOS on Shenker Dock 15 doesn't set up the
codec mask properly for the onboard audio.  Let's set the forced codec
mask to enable the codec discovery.

Reported-by: dmummenschanz@web.de
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/trinity-f018660b-95c9-442b-a2a8-c92a56eb07ed-1644345967148@3c-app-webde-bap22
Link: https://lore.kernel.org/r/20220214100020.8870-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1611,6 +1611,7 @@ static const struct snd_pci_quirk probe_
 	/* forced codec slots */
 	SND_PCI_QUIRK(0x1043, 0x1262, "ASUS W5Fm", 0x103),
 	SND_PCI_QUIRK(0x1046, 0x1262, "ASUS W5F", 0x103),
+	SND_PCI_QUIRK(0x1558, 0x0351, "Schenker Dock 15", 0x105),
 	/* WinFast VP200 H (Teradici) user reported broken communication */
 	SND_PCI_QUIRK(0x3a21, 0x040d, "WinFast VP200 H", 0x101),
 	{}


