Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C45B62198
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732873AbfGHPRm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:17:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732856AbfGHPRj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:17:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14CFD216F4;
        Mon,  8 Jul 2019 15:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599058;
        bh=PlbhsP/1l0Cu+F69o8LIBKwjU4G9z5OkTVqCpdeIhS4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AbmCWCihay2rGBfqI3iC0wxZ0rr8lF1q2qrcQZZ1JFywC73rh1rHuY2qlzoxqiicL
         JnxhIpru+aP3MZy428pvY6ouv/HWXmqen/EBqpxb2sSiMKcaessL8GnWHCaKL8M4C+
         6JrhL42/MUtsUZ4HseW25AipfJdoHUOvp2zW2gw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.4 64/73] ALSA: seq: fix incorrect order of dest_client/dest_ports arguments
Date:   Mon,  8 Jul 2019 17:13:14 +0200
Message-Id: <20190708150524.660457073@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
References: <20190708150513.136580595@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

commit c3ea60c231446663afd6ea1054da6b7f830855ca upstream.

There are two occurrances of a call to snd_seq_oss_fill_addr where
the dest_client and dest_port arguments are in the wrong order. Fix
this by swapping them around.

Addresses-Coverity: ("Arguments in wrong order")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/seq/oss/seq_oss_ioctl.c |    2 +-
 sound/core/seq/oss/seq_oss_rw.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/sound/core/seq/oss/seq_oss_ioctl.c
+++ b/sound/core/seq/oss/seq_oss_ioctl.c
@@ -62,7 +62,7 @@ static int snd_seq_oss_oob_user(struct s
 	if (copy_from_user(ev, arg, 8))
 		return -EFAULT;
 	memset(&tmpev, 0, sizeof(tmpev));
-	snd_seq_oss_fill_addr(dp, &tmpev, dp->addr.port, dp->addr.client);
+	snd_seq_oss_fill_addr(dp, &tmpev, dp->addr.client, dp->addr.port);
 	tmpev.time.tick = 0;
 	if (! snd_seq_oss_process_event(dp, (union evrec *)ev, &tmpev)) {
 		snd_seq_oss_dispatch(dp, &tmpev, 0, 0);
--- a/sound/core/seq/oss/seq_oss_rw.c
+++ b/sound/core/seq/oss/seq_oss_rw.c
@@ -174,7 +174,7 @@ insert_queue(struct seq_oss_devinfo *dp,
 	memset(&event, 0, sizeof(event));
 	/* set dummy -- to be sure */
 	event.type = SNDRV_SEQ_EVENT_NOTEOFF;
-	snd_seq_oss_fill_addr(dp, &event, dp->addr.port, dp->addr.client);
+	snd_seq_oss_fill_addr(dp, &event, dp->addr.client, dp->addr.port);
 
 	if (snd_seq_oss_process_event(dp, rec, &event))
 		return 0; /* invalid event - no need to insert queue */


