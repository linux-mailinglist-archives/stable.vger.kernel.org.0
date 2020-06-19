Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD57620189B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 19:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387893AbgFSQu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:50:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387902AbgFSOiq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:38:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7345420DD4;
        Fri, 19 Jun 2020 14:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592577526;
        bh=exxodDtRqqIJtISOg9Z587h8XyV029GVrPWQ8BRcD6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f/xfbCWhkbEqQ5Umf9HqNYQIZsRYCGBeLd2itsy8JLM6acoPprE6Pe0WwBaah0qLc
         XvaKC8QOM1g/bl9koLZ7FWpqn9M01ROwe4eNaidejRpPHE1yyY56CcHhbT91RA0PQ6
         nyuqOALZRQoF+s/FEeH3bk0kNBPe+T5Mee3doPuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.4 085/101] media: go7007: fix a miss of snd_card_free
Date:   Fri, 19 Jun 2020 16:33:14 +0200
Message-Id: <20200619141618.421043515@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141614.001544111@linuxfoundation.org>
References: <20200619141614.001544111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>

commit 9453264ef58638ce8976121ac44c07a3ef375983 upstream.

go7007_snd_init() misses a snd_card_free() in an error path.
Add the missed call to fix it.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
[Salvatore Bonaccorso: Adjust context for backport to versions which do
not contain c0decac19da3 ("media: use strscpy() instead of strlcpy()")
and ba78170ef153 ("media: go7007: Fix misuse of strscpy")]
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/go7007/snd-go7007.c |   35 ++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -243,22 +243,18 @@ int go7007_snd_init(struct go7007 *go)
 	gosnd->capturing = 0;
 	ret = snd_card_new(go->dev, index[dev], id[dev], THIS_MODULE, 0,
 			   &gosnd->card);
-	if (ret < 0) {
-		kfree(gosnd);
-		return ret;
-	}
+	if (ret < 0)
+		goto free_snd;
+
 	ret = snd_device_new(gosnd->card, SNDRV_DEV_LOWLEVEL, go,
 			&go7007_snd_device_ops);
-	if (ret < 0) {
-		kfree(gosnd);
-		return ret;
-	}
+	if (ret < 0)
+		goto free_card;
+
 	ret = snd_pcm_new(gosnd->card, "go7007", 0, 0, 1, &gosnd->pcm);
-	if (ret < 0) {
-		snd_card_free(gosnd->card);
-		kfree(gosnd);
-		return ret;
-	}
+	if (ret < 0)
+		goto free_card;
+
 	strlcpy(gosnd->card->driver, "go7007", sizeof(gosnd->card->driver));
 	strlcpy(gosnd->card->shortname, go->name, sizeof(gosnd->card->driver));
 	strlcpy(gosnd->card->longname, gosnd->card->shortname,
@@ -269,11 +265,8 @@ int go7007_snd_init(struct go7007 *go)
 			&go7007_snd_capture_ops);
 
 	ret = snd_card_register(gosnd->card);
-	if (ret < 0) {
-		snd_card_free(gosnd->card);
-		kfree(gosnd);
-		return ret;
-	}
+	if (ret < 0)
+		goto free_card;
 
 	gosnd->substream = NULL;
 	go->snd_context = gosnd;
@@ -281,6 +274,12 @@ int go7007_snd_init(struct go7007 *go)
 	++dev;
 
 	return 0;
+
+free_card:
+	snd_card_free(gosnd->card);
+free_snd:
+	kfree(gosnd);
+	return ret;
 }
 EXPORT_SYMBOL(go7007_snd_init);
 


