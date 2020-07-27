Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D90022F263
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgG0Ojn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:39:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:60030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729115AbgG0OJm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:09:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11344208E4;
        Mon, 27 Jul 2020 14:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858981;
        bh=N9rfu8Rm9dG6SIRtmK83SO4PfCqaxsXzeswlY0y/zTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVo3Cg9TSMM4CLDBpX+K8nVMyX6khlyRfwFK9nMfoukQH75zBmAWX8Dhul4/XhERF
         cPhKsh7hWcqgtiLZcwq1p4GMrceIWUtKFAaTf7WbyT2KIB04cH1eJI2zvD8MqDG+iL
         n5q003jbq4wGnsH7BU/G5JlVGxAO2cBTJYN9NbHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e42d0746c3c3699b6061@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.19 20/86] ALSA: info: Drop WARN_ON() from buffer NULL sanity check
Date:   Mon, 27 Jul 2020 16:03:54 +0200
Message-Id: <20200727134915.378000732@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

commit 60379ba08532eca861e933b389526a4dc89e0c42 upstream.

snd_info_get_line() has a sanity check of NULL buffer -- both buffer
itself being NULL and buffer->buffer being NULL.  Basically both
checks are valid and necessary, but the problem is that it's with
snd_BUG_ON() macro that triggers WARN_ON().  The latter condition
(NULL buffer->buffer) can be met arbitrarily by user since the buffer
is allocated at the first write, so it means that user can trigger
WARN_ON() at will.

This patch addresses it by simply moving buffer->buffer NULL check out
of snd_BUG_ON() so that spurious WARNING is no longer triggered.

Reported-by: syzbot+e42d0746c3c3699b6061@syzkaller.appspotmail.com
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200717084023.5928-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/info.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -634,7 +634,9 @@ int snd_info_get_line(struct snd_info_bu
 {
 	int c = -1;
 
-	if (snd_BUG_ON(!buffer || !buffer->buffer))
+	if (snd_BUG_ON(!buffer))
+		return 1;
+	if (!buffer->buffer)
 		return 1;
 	if (len <= 0 || buffer->stop || buffer->error)
 		return 1;


