Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7704D29B35F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766419AbgJ0Osn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:48:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766415AbgJ0Osl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:48:41 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A99C721556;
        Tue, 27 Oct 2020 14:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810120;
        bh=mpM/eNc1qPCXevA0Cv9TCas8brCKRl1fN7wjoo6bpVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFSklWpZkT1pibl+GfBoP2cIIpDGmPpNrCStk7cgTtXt5yK54mfcw0dh1taE6AeRB
         veiEDyj93f3kXQyh1pvLhb2DVlzWKCB5Dseo/OeFRQCN/U/n9q7J9WH6WGjsiQ/AiX
         2JVn8MI9Trt37ZTAkIG9Z7gVCAVGJcAy+v1O+Pbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.8 027/633] ALSA: bebob: potential info leak in hwdep_read()
Date:   Tue, 27 Oct 2020 14:46:10 +0100
Message-Id: <20201027135523.979158943@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit b41c15f4e1c1f1657da15c482fa837c1b7384452 upstream.

The "count" variable needs to be capped on every path so that we don't
copy too much information to the user.

Fixes: 618eabeae711 ("ALSA: bebob: Add hwdep interface")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20201007074928.GA2529578@mwanda
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/firewire/bebob/bebob_hwdep.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/sound/firewire/bebob/bebob_hwdep.c
+++ b/sound/firewire/bebob/bebob_hwdep.c
@@ -36,12 +36,11 @@ hwdep_read(struct snd_hwdep *hwdep, char
 	}
 
 	memset(&event, 0, sizeof(event));
+	count = min_t(long, count, sizeof(event.lock_status));
 	if (bebob->dev_lock_changed) {
 		event.lock_status.type = SNDRV_FIREWIRE_EVENT_LOCK_STATUS;
 		event.lock_status.status = (bebob->dev_lock_count > 0);
 		bebob->dev_lock_changed = false;
-
-		count = min_t(long, count, sizeof(event.lock_status));
 	}
 
 	spin_unlock_irq(&bebob->lock);


