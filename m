Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EBC20136A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392248AbgFSQBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392245AbgFSPN1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:13:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4ABD320776;
        Fri, 19 Jun 2020 15:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579606;
        bh=WvSxL5EX9clpOEr6XG24evakEOUYheiRfsF3RR6UIx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5480VYwJy9+FJh0Q/6x50kew+F2GWYT1QaAO0QmbhvO1+eOTEJTln3g306PZFdTD
         Zz4DG+yjOMaX+2FwaoYprhm/83MLV5SGgOUiv/yOmOuhRuK6DNOs65fdrQfb6w1yu0
         ciwBsfzMCdYhTcJWnoTJt0n7IZAqJ9Pd9LJs+Wpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 5.4 199/261] media: go7007: fix a miss of snd_card_free
Date:   Fri, 19 Jun 2020 16:33:30 +0200
Message-Id: <20200619141659.433719874@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
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
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/go7007/snd-go7007.c |   35 ++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -236,22 +236,18 @@ int go7007_snd_init(struct go7007 *go)
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
 	strscpy(gosnd->card->driver, "go7007", sizeof(gosnd->card->driver));
 	strscpy(gosnd->card->shortname, go->name, sizeof(gosnd->card->shortname));
 	strscpy(gosnd->card->longname, gosnd->card->shortname,
@@ -262,11 +258,8 @@ int go7007_snd_init(struct go7007 *go)
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
@@ -274,6 +267,12 @@ int go7007_snd_init(struct go7007 *go)
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
 


