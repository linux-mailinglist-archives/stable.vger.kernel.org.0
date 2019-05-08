Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFE217B62
	for <lists+stable@lfdr.de>; Wed,  8 May 2019 16:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbfEHOOc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 10:14:32 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:33169 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726703AbfEHOOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 May 2019 10:14:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B8EA9444;
        Wed,  8 May 2019 10:14:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 08 May 2019 10:14:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uIr5yT
        QCvSIB56H10tVB9NRzCA/IqkPKHxDk0+nW8W4=; b=eGTiy+aKge/3GR/navxD/u
        lJmzxgTvOticPB13FQaB59/GwV/cnsE2emu28NkSO1FEp7iGstccFADQPg/8OeYH
        4uG4tF4Kd1MaI/LVMFJtXE4+m/+1L8rOBO8s2/M36M6wZ3XnXM5woAGyXPMTS/kx
        eyHhoQYk89WM+d/x15rSPdkHQN7ylwRkX3NLBU4F5GgIGqlvdhifB8PetDzZUGfD
        5zQJVsUao0PSdJniMdo7Kgvdq9AfDI8gwbPmppwagVDpy7HsQbEgT2n7EYn3iuW/
        +nN+K5FSbC8YpyFTbrmmqT9aVXM+xMYUnU0PuAVgeZlWFc5wa5HwWj6zuWEPU/Ag
        ==
X-ME-Sender: <xms:ROTSXFFFgNQX0xzgWiEhfdKfWf3U951_Sc_YJY_neVJFCyq6srro3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrkeefgdejfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ROTSXI3R-vzmd6IzRNgs_UnB7Fkdnbhu2VkTFg5dfRqMGM63SZMzwg>
    <xmx:ROTSXComKiHn97alAzMAR9MbANc6KbzGUxogGliPv5I6iReVWsr-EA>
    <xmx:ROTSXFOPb3oex6tWQ8Ef0jndrtk93yiiGTJ7FTPF5VBdaFQKF69J_Q>
    <xmx:RuTSXGc48ouxrmXaXg8Z0ms_nAK_WqNPyouqZOrEO1_aXB7fD9hGbQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D82080061;
        Wed,  8 May 2019 10:14:27 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: most: sound: pass correct device when creating a" failed to apply to 4.19-stable tree
To:     christian.gromm@microchip.com, erosca@de.adit-jv.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 08 May 2019 16:13:40 +0200
Message-ID: <155732482015120@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 98592c1faca82a9024a64e4ecead68b19f81c299 Mon Sep 17 00:00:00 2001
From: Christian Gromm <christian.gromm@microchip.com>
Date: Tue, 30 Apr 2019 14:07:48 +0200
Subject: [PATCH] staging: most: sound: pass correct device when creating a
 sound card

This patch fixes the usage of the wrong struct device when calling
function snd_card_new.

Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Signed-off-by: Christian Gromm <christian.gromm@microchip.com>
Fixes: 69c90cf1b2fa ("staging: most: sound: call snd_card_new with struct device")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/most/sound/sound.c b/drivers/staging/most/sound/sound.c
index 7c998673a6f8..342f390d68b3 100644
--- a/drivers/staging/most/sound/sound.c
+++ b/drivers/staging/most/sound/sound.c
@@ -613,7 +613,7 @@ static int audio_probe_channel(struct most_interface *iface, int channel_id,
 	INIT_LIST_HEAD(&adpt->dev_list);
 	iface->priv = adpt;
 	list_add_tail(&adpt->list, &adpt_list);
-	ret = snd_card_new(&iface->dev, -1, "INIC", THIS_MODULE,
+	ret = snd_card_new(iface->driver_dev, -1, "INIC", THIS_MODULE,
 			   sizeof(*channel), &adpt->card);
 	if (ret < 0)
 		goto err_free_adpt;

