Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3AA4937F
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbfFQV2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729031AbfFQV2t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:28:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34097204FD;
        Mon, 17 Jun 2019 21:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806928;
        bh=01JgqLU+q/jditVF0XnE6iIetBdTeaxf7YEBoD9AiAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMxFLr+Gh/T3nvyFie3z1ngr0niiAbj8mK2n2/SfyOTDG+Zb1t3T3KpbfHFZRXjjE
         BvsE9jmyh7UUykoBmztOwBJhdSPS0GSGASJA+Vuj8OzuqF2XH5gT5U0FL7Ro9W/2pT
         Bta/TGe9RDMwXNPRXSFnbruSCOin4i8uuoFOrytg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e4c8abb920efa77bace9@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 23/53] ALSA: seq: Protect in-kernel ioctl calls with mutex
Date:   Mon, 17 Jun 2019 23:10:06 +0200
Message-Id: <20190617210749.935047820@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
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
index 3bcd7a2f0394..692631bd4a35 100644
--- a/sound/core/seq/seq_clientmgr.c
+++ b/sound/core/seq/seq_clientmgr.c
@@ -2348,14 +2348,19 @@ int snd_seq_kernel_client_ctl(int clientid, unsigned int cmd, void *arg)
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



