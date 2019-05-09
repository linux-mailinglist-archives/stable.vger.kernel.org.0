Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C8F191C0
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 21:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfEISvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:51:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:44742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728529AbfEISvH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:51:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DD4C20578;
        Thu,  9 May 2019 18:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427867;
        bh=gB4rxXtmZhaQAk8GNiRvnotbYsWheyhY6t08SUjxvUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U0HzF2CuPFFMZGpINi7xre6BSpLx3DanGYJlYoi/usEgpfoVZ9bCoGx5kyiMuPy8b
         WiJ0kBq7Rpkolq/WSJeXoFWUWR/bfeX69fAAJKp/TgCQr3jeC3GMu5bTgR6XtQLjyU
         sZS6AaKVU6alAox/vjLW6ir5yth10dRz/3YxrTZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eugeniu Rosca <erosca@de.adit-jv.com>,
        Christian Gromm <christian.gromm@microchip.com>
Subject: [PATCH 5.0 07/95] staging: most: sound: pass correct device when creating a sound card
Date:   Thu,  9 May 2019 20:41:24 +0200
Message-Id: <20190509181309.829009338@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Gromm <christian.gromm@microchip.com>

commit 98592c1faca82a9024a64e4ecead68b19f81c299 upstream.

This patch fixes the usage of the wrong struct device when calling
function snd_card_new.

Reported-by: Eugeniu Rosca <erosca@de.adit-jv.com>
Signed-off-by: Christian Gromm <christian.gromm@microchip.com>
Fixes: 69c90cf1b2fa ("staging: most: sound: call snd_card_new with struct device")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/most/sound/sound.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/most/sound/sound.c
+++ b/drivers/staging/most/sound/sound.c
@@ -622,7 +622,7 @@ static int audio_probe_channel(struct mo
 	INIT_LIST_HEAD(&adpt->dev_list);
 	iface->priv = adpt;
 	list_add_tail(&adpt->list, &adpt_list);
-	ret = snd_card_new(&iface->dev, -1, "INIC", THIS_MODULE,
+	ret = snd_card_new(iface->driver_dev, -1, "INIC", THIS_MODULE,
 			   sizeof(*channel), &adpt->card);
 	if (ret < 0)
 		goto err_free_adpt;


