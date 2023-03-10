Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC326B4456
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbjCJOXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbjCJOWi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:22:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F31523A78
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:21:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99F4A617CF
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937A9C433EF;
        Fri, 10 Mar 2023 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458118;
        bh=n1jKkHfRjRG8GVzq653B5zAVJuxcG56uPlJAZuaqCLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QsTPd+uO5TeWo7szbVpidbsjVioBrjrXXKt7uMfHFrlruHov9k8ELEZqkRTWrP15y
         2SAjwdgp6VWhqLxfMCJoAfIQujFNqnFmacYt2sr5AEO6LryFdaohlSk5qG6sJ5FbWi
         vlLBdvfMdGWKyCOu7B21YEazUysxIKQyzQa5FE68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dmitry Fomin <fomindmitriyfoma@mail.ru>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 170/252] ALSA: ice1712: Do not left ice->gpio_mutex locked in aureon_add_controls()
Date:   Fri, 10 Mar 2023 14:39:00 +0100
Message-Id: <20230310133723.999567411@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
@@ -1906,6 +1906,7 @@ static int aureon_add_controls(struct sn
 		unsigned char id;
 		snd_ice1712_save_gpio_status(ice);
 		id = aureon_cs8415_get(ice, CS8415_ID);
+		snd_ice1712_restore_gpio_status(ice);
 		if (id != 0x41)
 			dev_info(ice->card->dev,
 				 "No CS8415 chip. Skipping CS8415 controls.\n");
@@ -1923,7 +1924,6 @@ static int aureon_add_controls(struct sn
 					kctl->id.device = ice->pcm->device;
 			}
 		}
-		snd_ice1712_restore_gpio_status(ice);
 	}
 
 	return 0;


