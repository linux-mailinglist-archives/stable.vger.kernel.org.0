Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6073EEFC7
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387946AbfKDVy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 16:54:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:49258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387942AbfKDVy2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 16:54:28 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63BE0217F4;
        Mon,  4 Nov 2019 21:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572904468;
        bh=2IVWjNwRLLdOVwnOg0i7pBTAZwv/3UMSQUs8kXBuoWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fXr02znag58EkQpjkvew7KlXcDfGe09tCRj3AyqLcH/4w7POdW5Puhqrovg/3+37p
         KZTwZEHgWDlSZkrXfsAaDKnFmTcQmHcvaJ3gL+4Kv5h0J/cjdsVsoIwOkuNi89b46m
         WRjh13Y+YD7/INjcoz5MZocjaI2RjOljc3DjflVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+24c12fa8d218ed26011a@syzkaller.appspotmail.com,
        "Richard W.M. Jones" <rjones@redhat.com>,
        Mike Christie <mchristi@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 57/95] nbd: verify socket is supported during setup
Date:   Mon,  4 Nov 2019 22:44:55 +0100
Message-Id: <20191104212106.300239492@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212038.056365853@linuxfoundation.org>
References: <20191104212038.056365853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

[ Upstream commit cf1b2326b734896734c6e167e41766f9cee7686a ]

nbd requires socket families to support the shutdown method so the nbd
recv workqueue can be woken up from its sock_recvmsg call. If the socket
does not support the callout we will leave recv works running or get hangs
later when the device or module is removed.

This adds a check during socket connection/reconnection to make sure the
socket being passed in supports the needed callout.

Reported-by: syzbot+24c12fa8d218ed26011a@syzkaller.appspotmail.com
Fixes: e9e006f5fcf2 ("nbd: fix max number of supported devs")
Tested-by: Richard W.M. Jones <rjones@redhat.com>
Signed-off-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 3e45004407963..f3d0bc9a99058 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -912,6 +912,25 @@ static blk_status_t nbd_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return ret;
 }
 
+static struct socket *nbd_get_socket(struct nbd_device *nbd, unsigned long fd,
+				     int *err)
+{
+	struct socket *sock;
+
+	*err = 0;
+	sock = sockfd_lookup(fd, err);
+	if (!sock)
+		return NULL;
+
+	if (sock->ops->shutdown == sock_no_shutdown) {
+		dev_err(disk_to_dev(nbd->disk), "Unsupported socket: shutdown callout must be supported.\n");
+		*err = -EINVAL;
+		return NULL;
+	}
+
+	return sock;
+}
+
 static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
 			  bool netlink)
 {
@@ -921,7 +940,7 @@ static int nbd_add_socket(struct nbd_device *nbd, unsigned long arg,
 	struct nbd_sock *nsock;
 	int err;
 
-	sock = sockfd_lookup(arg, &err);
+	sock = nbd_get_socket(nbd, arg, &err);
 	if (!sock)
 		return err;
 
@@ -973,7 +992,7 @@ static int nbd_reconnect_socket(struct nbd_device *nbd, unsigned long arg)
 	int i;
 	int err;
 
-	sock = sockfd_lookup(arg, &err);
+	sock = nbd_get_socket(nbd, arg, &err);
 	if (!sock)
 		return err;
 
-- 
2.20.1



