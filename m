Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 436DE493AF
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbfFQV0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730279AbfFQV0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:26:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FBAA20673;
        Mon, 17 Jun 2019 21:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806810;
        bh=gwdxi5AAuoYgp387IoGFEKVh/fyMbDmAvT1oM3iYpVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=px31JVjqlYRBkNLL3Fv5O+gpg65f5TVg7pKTYQyY1b6sKaeSYAbgjafgPZz9WbF24
         w5JqZ9xkZsBQLrPcxiP5ZxQ4oCLAu3foVUXTYIfzRiVZNFTP7UJm23Om4SRsCPQCvk
         3CyRLvNtz06y+6ug835Zqtpk06YixvQIMpdyPApM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e4c8abb920efa77bace9@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/75] ALSA: seq: Protect in-kernel ioctl calls with mutex
Date:   Mon, 17 Jun 2019 23:09:39 +0200
Message-Id: <20190617210753.921547314@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit feb689025fbb6f0aa6297d3ddf97de945ea4ad32 ]

ALSA OSS sequencer calls the ioctl function indirectly via
snd_seq_kernel_client_ctl().  While we already applied the protection
against races between the normal ioctls and writes via the client's
ioctl_mutex, this code path was left untouched.  And this seems to be
the cause of still remaining some rare UAF as spontaneously triggered
by syzkaller.

For the sake of robustness, wrap the ioctl_mutex also for the call via
snd_seq_kernel_client_ctl(), too.

Reported-by: syzbot+e4c8abb920efa77bace9@syzkaller.appspotmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_clientmgr.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/core/seq/seq_clientmgr.c b/sound/core/seq/seq_clientmgr.c
index b55cb96d1fed..40ae8f67efde 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -2343,14 +2343,19 @@ int snd_seq_kernel_client_ctl(int clientid, unsigned int cmd, void *arg)
 {
 	const struct ioctl_handler *handler;
 	struct snd_seq_client *client;
+	int err;
 
 	client = clientptr(clientid);
 	if (client == NULL)
 		return -ENXIO;
 
 	for (handler = ioctl_handlers; handler->cmd > 0; ++handler) {
-		if (handler->cmd == cmd)
-			return handler->func(client, arg);
+		if (handler->cmd == cmd) {
+			mutex_lock(&client->ioctl_mutex);
+			err = handler->func(client, arg);
+			mutex_unlock(&client->ioctl_mutex);
+			return err;
+		}
 	}
 
 	pr_debug("ALSA: seq unknown ioctl() 0x%x (type='%c', number=0x%02x)\n",
-- 
2.20.1



