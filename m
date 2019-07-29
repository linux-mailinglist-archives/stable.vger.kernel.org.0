Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 651E2796B7
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404111AbfG2Tyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:54:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404109AbfG2Tyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:54:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE19C217D4;
        Mon, 29 Jul 2019 19:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430086;
        bh=g9+3tq7GHZg1jHvz0me+UF46Jac2M0bJEWaDcS19MQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zcUvpz0hVGloEuQhyzdadXBADtPaJhaHbo+9a54pw8WXUw/jytERWhHGdVkWrVqbT
         5lwEAiUHscSWypDg8JB8Z7cyS/w1Y7lLc1xdxcpgTRajGq2/ECrg9LDeOG1sJjugHw
         o8/+2MXhp9k3KcjYOJcC/SvsCZTwI4oxtS4Y0vj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ding Xiang <dingxiang@cmss.chinamobile.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.2 191/215] ALSA: ac97: Fix double free of ac97_codec_device
Date:   Mon, 29 Jul 2019 21:23:07 +0200
Message-Id: <20190729190813.075531827@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ding Xiang <dingxiang@cmss.chinamobile.com>

commit 607975b30db41aad6edc846ed567191aa6b7d893 upstream.

put_device will call ac97_codec_release to free
ac97_codec_device and other resources, so remove the kfree
and other redundant code.

Fixes: 74426fbff66e ("ALSA: ac97: add an ac97 bus")
Signed-off-by: Ding Xiang <dingxiang@cmss.chinamobile.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/ac97/bus.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- a/sound/ac97/bus.c
+++ b/sound/ac97/bus.c
@@ -122,17 +122,12 @@ static int ac97_codec_add(struct ac97_co
 						      vendor_id);
 
 	ret = device_add(&codec->dev);
-	if (ret)
-		goto err_free_codec;
+	if (ret) {
+		put_device(&codec->dev);
+		return ret;
+	}
 
 	return 0;
-err_free_codec:
-	of_node_put(codec->dev.of_node);
-	put_device(&codec->dev);
-	kfree(codec);
-	ac97_ctrl->codecs[idx] = NULL;
-
-	return ret;
 }
 
 unsigned int snd_ac97_bus_scan_one(struct ac97_controller *adrv,


