Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078A36AEA70
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbjCGRdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjCGRda (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:33:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 618F29C9A2
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:29:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D974D611A1
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B72C433D2;
        Tue,  7 Mar 2023 17:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210146;
        bh=QfYdUlt/Ld29B1iV2/oLizqH7hxUCn+kXz4e7A6sfX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCi3X0yqmiwbaPIasDASOkNyAQtj3QeDaMZzDQmQ8Vwf6h6OZJ938F57jIGbzaA4n
         VD2n9HXuOYBKu2yqWxC8yqJCfyXBwnYJMfgL8203cW3R0tEFQd68Zgu7oklx31Fvnd
         Wp+U5tuhOZ1zC9nLUgXecrIzjhZrtwmxjisE9MfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Orlando Chamberlain <orlandoch.dev@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0447/1001] ALSA: hda/hdmi: Register with vga_switcheroo on Dual GPU Macbooks
Date:   Tue,  7 Mar 2023 17:53:39 +0100
Message-Id: <20230307170040.753617555@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Orlando Chamberlain <orlandoch.dev@gmail.com>

[ Upstream commit 5beb5627a2481aade9aa630b7ebb7f99442321b6 ]

Commit 586bc4aab878 ("ALSA: hda/hdmi - fix vgaswitcheroo detection for
AMD") caused only AMD gpu's with PX to have their audio component register
with vga_switcheroo. This meant that Apple Macbooks with apple-gmux as the
gpu switcher no longer had the audio client registering, so when the gpu is
powered off by vga_switcheroo snd_hda_intel is unaware that it should have
suspended the device:

amdgpu: switched off
snd_hda_intel 0000:03:00.1:
    Unable to change power state from D3hot to D0, device inaccessible
snd_hda_intel 0000:03:00.1: CORB reset timeout#2, CORBRP = 65535

To resolve this, we use apple_gmux_detect() and register a
vga_switcheroo audio client when apple-gmux is detected.

Fixes: 586bc4aab878 ("ALSA: hda/hdmi - fix vgaswitcheroo detection for AMD")
Link: https://lore.kernel.org/all/20230210044826.9834-9-orlandoch.dev@gmail.com/
Signed-off-by: Orlando Chamberlain <orlandoch.dev@gmail.com>
Link: https://lore.kernel.org/r/20230216103450.12925-1-orlandoch.dev@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 2dbc082076f69..81c4a45254ff2 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -50,6 +50,7 @@
 #include <sound/intel-dsp-config.h>
 #include <linux/vgaarb.h>
 #include <linux/vga_switcheroo.h>
+#include <linux/apple-gmux.h>
 #include <linux/firmware.h>
 #include <sound/hda_codec.h>
 #include "hda_controller.h"
@@ -1466,7 +1467,7 @@ static struct pci_dev *get_bound_vga(struct pci_dev *pci)
 				 * vgaswitcheroo.
 				 */
 				if (((p->class >> 16) == PCI_BASE_CLASS_DISPLAY) &&
-				    atpx_present())
+				    (atpx_present() || apple_gmux_detect(NULL, NULL)))
 					return p;
 				pci_dev_put(p);
 			}
-- 
2.39.2



