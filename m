Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1EF1353B4
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfFDXZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:36670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbfFDXZK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:25:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70F2820862;
        Tue,  4 Jun 2019 23:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690710;
        bh=BH2DFu3+7KehxzHLPAsAJYDzpvVppzmYsL8rKbaOXfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I5Y7KKJZfmTcevZAUO8OsOG5ga4CeDyMHiD6iXuy0pqbH5XrLA/fR0hE9FmlwAncl
         v3yXynCggD10p4yrkco96MhNBEbQ4qrnG9kousV5C4RIeNMm384IkFxPQDAwLTcpJy
         IPa9WRTRJRGF5x5MqANcx3RcknzsfbKg87dqidDw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        syzbot+47ded6c0f23016cde310@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 04/17] Revert "ALSA: seq: Protect in-kernel ioctl calls with mutex"
Date:   Tue,  4 Jun 2019 19:24:45 -0400
Message-Id: <20190604232459.7745-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190604232459.7745-1-sashal@kernel.org>
References: <20190604232459.7745-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit f0654ba94e33699b295ce4f3dc73094db6209035 ]

This reverts commit feb689025fbb6f0aa6297d3ddf97de945ea4ad32.

The fix attempt was incorrect, leading to the mutex deadlock through
the close of OSS sequencer client.  The proper fix needs more
consideration, so let's revert it now.

Fixes: feb689025fbb ("ALSA: seq: Protect in-kernel ioctl calls with mutex")
Reported-by: syzbot+47ded6c0f23016cde310@syzkaller.appspotmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index 881c965555c5..bc6d371031fc 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -2348,19 +2348,14 @@ int snd_seq_kernel_client_ctl(int clientid, unsigned int cmd, void *arg)
 {
 	const struct ioctl_handler *handler;
 	struct snd_seq_client *client;
-	int err;
 
 	client = clientptr(clientid);
 	if (client == NULL)
 		return -ENXIO;
 
 	for (handler = ioctl_handlers; handler->cmd > 0; ++handler) {
-		if (handler->cmd == cmd) {
-			mutex_lock(&client->ioctl_mutex);
-			err = handler->func(client, arg);
-			mutex_unlock(&client->ioctl_mutex);
-			return err;
-		}
+		if (handler->cmd == cmd)
+			return handler->func(client, arg);
 	}
 
 	pr_debug("ALSA: seq unknown ioctl() 0x%x (type='%c', number=0x%02x)\n",
-- 
2.20.1

