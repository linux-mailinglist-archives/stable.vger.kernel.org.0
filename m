Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 727E94D87B
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfFTSFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:05:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728005AbfFTSFV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:05:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30350204FD;
        Thu, 20 Jun 2019 18:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053920;
        bh=UUtY7uaP00LJZzWSApNObWwt5epQ/e5gEjLUXTwcBwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0malLA22iPJjxgNOPG9dcchiKU8SLOMzWSddi68ufAbYvSHcylNTNlGSILsCLwlTk
         kt0ZtQpHXolk1daTmunRx4NER/vyj/aXdmSacnwxN8TgMRYjSJndn9V3gI2hjxgzgQ
         Sg/vYPza9ro0IVyq6AoNfGPVXOtGzIpZN/wIeEsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+47ded6c0f23016cde310@syzkaller.appspotmail.com,
        Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 072/117] Revert "ALSA: seq: Protect in-kernel ioctl calls with mutex"
Date:   Thu, 20 Jun 2019 19:56:46 +0200
Message-Id: <20190620174356.933060710@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



