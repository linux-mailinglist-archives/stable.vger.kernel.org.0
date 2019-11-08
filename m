Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC6BF4B1C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732408AbfKHLiT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:38:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:51208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732399AbfKHLiS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1AB921D7E;
        Fri,  8 Nov 2019 11:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213097;
        bh=ib4vu3ssWv+BcS446FDJwbNCxuG0zk6e/VuXGHHpq9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zBmtLWZcj7EYW30LsBBLdSvSr2H4QGVJkxlNrfnaTPrA0tcpEoS2fLZSN6blMZLYs
         BzstICeFDiySzRB1LxibNYmYRJpC9t3XKNJ+/s/DgnEyT7Xav9mZ2ynZm+lTZZghiL
         NopCN9QWDYtPnxNTooCJEtX4c/yUXoWGv7LWaG3k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 022/205] ALSA: seq: Do error checks at creating system ports
Date:   Fri,  8 Nov 2019 06:34:49 -0500
Message-Id: <20191108113752.12502-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b8e131542b47b81236ecf6768c923128e1f5db6e ]

snd_seq_system_client_init() doesn't check the errors returned from
its port creations.  Let's do it properly and handle the error paths.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_system.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/sound/core/seq/seq_system.c b/sound/core/seq/seq_system.c
index 8ce1d0b40dce1..ce1f1e4727ab1 100644
--- a/sound/core/seq/seq_system.c
+++ b/sound/core/seq/seq_system.c
@@ -123,6 +123,7 @@ int __init snd_seq_system_client_init(void)
 {
 	struct snd_seq_port_callback pcallbacks;
 	struct snd_seq_port_info *port;
+	int err;
 
 	port = kzalloc(sizeof(*port), GFP_KERNEL);
 	if (!port)
@@ -144,7 +145,10 @@ int __init snd_seq_system_client_init(void)
 	port->flags = SNDRV_SEQ_PORT_FLG_GIVEN_PORT;
 	port->addr.client = sysclient;
 	port->addr.port = SNDRV_SEQ_PORT_SYSTEM_TIMER;
-	snd_seq_kernel_client_ctl(sysclient, SNDRV_SEQ_IOCTL_CREATE_PORT, port);
+	err = snd_seq_kernel_client_ctl(sysclient, SNDRV_SEQ_IOCTL_CREATE_PORT,
+					port);
+	if (err < 0)
+		goto error_port;
 
 	/* register announcement port */
 	strcpy(port->name, "Announce");
@@ -154,16 +158,24 @@ int __init snd_seq_system_client_init(void)
 	port->flags = SNDRV_SEQ_PORT_FLG_GIVEN_PORT;
 	port->addr.client = sysclient;
 	port->addr.port = SNDRV_SEQ_PORT_SYSTEM_ANNOUNCE;
-	snd_seq_kernel_client_ctl(sysclient, SNDRV_SEQ_IOCTL_CREATE_PORT, port);
+	err = snd_seq_kernel_client_ctl(sysclient, SNDRV_SEQ_IOCTL_CREATE_PORT,
+					port);
+	if (err < 0)
+		goto error_port;
 	announce_port = port->addr.port;
 
 	kfree(port);
 	return 0;
+
+ error_port:
+	snd_seq_system_client_done();
+	kfree(port);
+	return err;
 }
 
 
 /* unregister our internal client */
-void __exit snd_seq_system_client_done(void)
+void snd_seq_system_client_done(void)
 {
 	int oldsysclient = sysclient;
 
-- 
2.20.1

