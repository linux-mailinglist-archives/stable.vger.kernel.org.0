Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3FD288D6C
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfHJUqA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:46:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55264 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726885AbfHJUoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDb-00053i-W9; Sat, 10 Aug 2019 21:44:04 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDL-0003d9-3E; Sat, 10 Aug 2019 21:43:47 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "Guenter Roeck" <groeck@chromium.org>,
        "Zubin Mithra" <zsm@chromium.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.465476075@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 071/157] ALSA: seq: Fix OOB-reads from strlcpy
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Zubin Mithra <zsm@chromium.org>

commit 212ac181c158c09038c474ba68068be49caecebb upstream.

When ioctl calls are made with non-null-terminated userspace strings,
strlcpy causes an OOB-read from within strlen. Fix by changing to use
strscpy instead.

Signed-off-by: Zubin Mithra <zsm@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/seq/seq_clientmgr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -1249,7 +1249,7 @@ static int snd_seq_ioctl_set_client_info
 
 	/* fill the info fields */
 	if (client_info.name[0])
-		strlcpy(client->name, client_info.name, sizeof(client->name));
+		strscpy(client->name, client_info.name, sizeof(client->name));
 
 	client->filter = client_info.filter;
 	client->event_lost = client_info.event_lost;
@@ -1564,7 +1564,7 @@ static int snd_seq_ioctl_create_queue(st
 	/* set queue name */
 	if (! info.name[0])
 		snprintf(info.name, sizeof(info.name), "Queue-%d", q->queue);
-	strlcpy(q->name, info.name, sizeof(q->name));
+	strscpy(q->name, info.name, sizeof(q->name));
 	queuefree(q);
 
 	if (copy_to_user(arg, &info, sizeof(info)))
@@ -1642,7 +1642,7 @@ static int snd_seq_ioctl_set_queue_info(
 		queuefree(q);
 		return -EPERM;
 	}
-	strlcpy(q->name, info.name, sizeof(q->name));
+	strscpy(q->name, info.name, sizeof(q->name));
 	queuefree(q);
 
 	return 0;

