Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94DC30C115
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234148AbhBBOMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:12:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233753AbhBBOLb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:11:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 43A9064F5F;
        Tue,  2 Feb 2021 13:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273899;
        bh=rjJVGb7YvzA8j5GbKSOGVEPBW6LXLKIUcms8p1OFTrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrBR7zKY/APGbmfRGjUXE8/sdF96sImSu1AINLP8maUZ68vHUf09OfhbdB7Ka+jeG
         EULjlP8E7ZKjj9i8yA/MMlwDDDBsdiABfoBPvWSn4tYLZgLK//wBLfjHUMt68Whyfi
         vLFQOkSR1crUyrqAQCIIS5foYorHZwWXV2Opkr+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 01/30] nbd: freeze the queue while were adding connections
Date:   Tue,  2 Feb 2021 14:38:42 +0100
Message-Id: <20210202132942.200246773@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

commit b98e762e3d71e893b221f871825dc64694cfb258 upstream.

When setting up a device, we can krealloc the config->socks array to add
new sockets to the configuration.  However if we happen to get a IO
request in at this point even though we aren't setup we could hit a UAF,
as we deref config->socks without any locking, assuming that the
configuration was setup already and that ->socks is safe to access it as
we have a reference on the configuration.

But there's nothing really preventing IO from occurring at this point of
the device setup, we don't want to incur the overhead of a lock to
access ->socks when it will never change while the device is running.
To fix this UAF scenario simply freeze the queue if we are adding
sockets.  This will protect us from this particular case without adding
any additional overhead for the normal running case.

Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/nbd.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -952,6 +952,12 @@ static int nbd_add_socket(struct nbd_dev
 	if (!sock)
 		return err;
 
+	/*
+	 * We need to make sure we don't get any errant requests while we're
+	 * reallocating the ->socks array.
+	 */
+	blk_mq_freeze_queue(nbd->disk->queue);
+
 	if (!netlink && !nbd->task_setup &&
 	    !test_bit(NBD_BOUND, &config->runtime_flags))
 		nbd->task_setup = current;
@@ -990,10 +996,12 @@ static int nbd_add_socket(struct nbd_dev
 	nsock->cookie = 0;
 	socks[config->num_connections++] = nsock;
 	atomic_inc(&config->live_connections);
+	blk_mq_unfreeze_queue(nbd->disk->queue);
 
 	return 0;
 
 put_socket:
+	blk_mq_unfreeze_queue(nbd->disk->queue);
 	sockfd_put(sock);
 	return err;
 }


