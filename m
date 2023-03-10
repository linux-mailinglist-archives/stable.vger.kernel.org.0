Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96816B499E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbjCJPO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:14:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjCJPOI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:14:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7C965DCB2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:05:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D91E8B822BF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F97C433D2;
        Fri, 10 Mar 2023 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460652;
        bh=c3yN5AO8+TlYyEqfkiwD6JSt1wrYlJu+bnbzdXwX40I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dR6lKs1w6SJZvPNcBOZoU7g333zBoXxVJoE5enVIvk9yJLPaaNy2DqsQLqIWsLXlv
         x0t6XAmJRbfjCR1PbfI/kmu7dk0+kNN0TJ59qp6iY0qfccl7IyWd1hghXKeZkZgDo/
         FIOIg016tA0zYPC149/ztzVgS1gYPDYIWBWergJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dmitry Fomin <fomindmitriyfoma@mail.ru>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 379/529] ALSA: ice1712: Do not left ice->gpio_mutex locked in aureon_add_controls()
Date:   Fri, 10 Mar 2023 14:38:42 +0100
Message-Id: <20230310133822.568240474@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Dmitry Fomin <fomindmitriyfoma@mail.ru>

commit 951606a14a8901e3551fe4d8d3cedd73fe954ce1 upstream.

If snd_ctl_add() fails in aureon_add_controls(), it immediately returns
and leaves ice->gpio_mutex locked. ice->gpio_mutex locks in
snd_ice1712_save_gpio_status and unlocks in
snd_ice1712_restore_gpio_status(ice).

It seems that the mutex is required only for aureon_cs8415_get(),
so snd_ice1712_restore_gpio_status(ice) can be placed
just after that. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dmitry Fomin <fomindmitriyfoma@mail.ru>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230225184322.6286-1-fomindmitriyfoma@mail.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ice1712/aureon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/pci/ice1712/aureon.c
+++ b/sound/pci/ice1712/aureon.c
@@ -1892,6 +1892,7 @@ static int aureon_add_controls(struct sn
 		unsigned char id;
 		snd_ice1712_save_gpio_status(ice);
 		id = aureon_cs8415_get(ice, CS8415_ID);
+		snd_ice1712_restore_gpio_status(ice);
 		if (id != 0x41)
 			dev_info(ice->card->dev,
 				 "No CS8415 chip. Skipping CS8415 controls.\n");
@@ -1909,7 +1910,6 @@ static int aureon_add_controls(struct sn
 					kctl->id.device = ice->pcm->device;
 			}
 		}
-		snd_ice1712_restore_gpio_status(ice);
 	}
 
 	return 0;


