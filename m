Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E45DF6E6230
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbjDRMaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbjDRMak (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034BF5596
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66139631DB
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78A64C433EF;
        Tue, 18 Apr 2023 12:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820987;
        bh=FJIbj5cdIM4VZXmLier+1/DGjlR61yP4ieGFHCup6dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1S5XSD4lsWCVAhKruqxSbB7+ahyyueg5xwFjYcDoloyU9Id7QbUY4BFrW12Q/TVHj
         edXm3A5MOJdnNehFzE9PCnT0+89kdFm2k36MQXb56y+eBmmBiJhdaXw/leYeaPYvZp
         d2oTsN+uplluOC25GvK4JqwJzXMjAC6vXHEUBjao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 49/92] ALSA: hda/sigmatel: fix S/PDIF out on Intel D*45* motherboards
Date:   Tue, 18 Apr 2023 14:21:24 +0200
Message-Id: <20230418120306.564525111@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

commit f342ac00da1064eb4f94b1f4bcacbdfea955797a upstream.

The BIOS botches this one completely - it says the 2nd S/PDIF output is
used, while in fact it's the 1st one. This is tested on DP45SG, but I'm
assuming it's valid for the other boards in the series as well.

Also add some comments regarding the pins.
FWIW, the codec is apparently still sold by Tempo Semiconductor, Inc.,
where one can download the documentation.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230405201220.2197826-2-oswald.buddenhagen@gmx.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_sigmatel.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -1701,6 +1701,7 @@ static const struct snd_pci_quirk stac92
 };
 
 static const struct hda_pintbl ref92hd73xx_pin_configs[] = {
+	// Port A-H
 	{ 0x0a, 0x02214030 },
 	{ 0x0b, 0x02a19040 },
 	{ 0x0c, 0x01a19020 },
@@ -1709,9 +1710,12 @@ static const struct hda_pintbl ref92hd73
 	{ 0x0f, 0x01014010 },
 	{ 0x10, 0x01014020 },
 	{ 0x11, 0x01014030 },
+	// CD in
 	{ 0x12, 0x02319040 },
+	// Digial Mic ins
 	{ 0x13, 0x90a000f0 },
 	{ 0x14, 0x90a000f0 },
+	// Digital outs
 	{ 0x22, 0x01452050 },
 	{ 0x23, 0x01452050 },
 	{}
@@ -1752,6 +1756,7 @@ static const struct hda_pintbl alienware
 };
 
 static const struct hda_pintbl intel_dg45id_pin_configs[] = {
+	// Analog outputs
 	{ 0x0a, 0x02214230 },
 	{ 0x0b, 0x02A19240 },
 	{ 0x0c, 0x01013214 },
@@ -1759,6 +1764,9 @@ static const struct hda_pintbl intel_dg4
 	{ 0x0e, 0x01A19250 },
 	{ 0x0f, 0x01011212 },
 	{ 0x10, 0x01016211 },
+	// Digital output
+	{ 0x22, 0x01451380 },
+	{ 0x23, 0x40f000f0 },
 	{}
 };
 


