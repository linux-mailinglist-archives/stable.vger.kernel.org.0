Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8E70257704
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 11:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726081AbgHaJ6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 05:58:34 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:41433 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbgHaJ6d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 05:58:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id EEED5642;
        Mon, 31 Aug 2020 05:58:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 31 Aug 2020 05:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iAWQhq
        snvIKOzgdkRsDgKDVOwg39kmR5cXQ9EPhJMA8=; b=LlWSEPe4tMuLna0rD1stVN
        ZXE+ucVxS9Iu+MLxW9SZeeMI773RMZycHqQWus13xWTRlxH8QHRNN3JsLydQtgMB
        GtARIdidYSoJ20UqXOBe3q6YerNaszAF3O360rkeh9RD1OrObON1u+ETXT/g1kWm
        Ku7u9OrhwEksL5ZikZIQo+6dtCX7QL6LiTbkOkBwQlgQ6atXOQkK9oJ5MvO/bkTs
        1EeIxsxgy6nONPVjMPAIeqYTIjjL0ZQ+T2n1aUKgJ8L6/WatZFpLFv2XvMos9Z24
        264ruxu7Mpd7kKm+gKUBu2lmlfjLJ88zAW06XgygWdZr97itqF/C4yQgyKXp982A
        ==
X-ME-Sender: <xms:yMlMX_pQ7JD6_V6WQNW7UpzhGucP8pyysEjBUUMKBJtI0eGgqiYjTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudefhedgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:yMlMX5oyzb82zYN6mIg2L9K1HWIMu3HCcU2gTaaLp8s9UL0WGIaFzw>
    <xmx:yMlMX8M_LS8ppQNHW3jR3pEpjSCcIpoPq5TntzNatpxorWJeLkGvyg>
    <xmx:yMlMXy7ENOSibjYzsiX6c-w2-ohErT5PqtibvN7syJ03etvYi1gQaw>
    <xmx:yMlMX7Ve55HqM_Xxy2meqaGISaA29AAl7bl0PvKllw75CW2mu80oRcoSbK0>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1ACA9306005E;
        Mon, 31 Aug 2020 05:58:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] io_uring: don't use poll handler if file can't be nonblocking" failed to apply to 5.8-stable tree
To:     axboe@kernel.dk, wisp3rwind@posteo.eu
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Aug 2020 11:58:41 +0200
Message-ID: <159886792176158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.8-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9dab14b81807a40dab8e464ec87043935c562c2c Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Tue, 25 Aug 2020 12:27:50 -0600
Subject: [PATCH] io_uring: don't use poll handler if file can't be nonblocking
 read/written

There's no point in using the poll handler if we can't do a nonblocking
IO attempt of the operation, since we'll need to go async anyway. In
fact this is actively harmful, as reading from eg pipes won't return 0
to indicate EOF.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: Benedikt Ames <wisp3rwind@posteo.eu>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 384df86dfc69..d15139088e4c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4889,12 +4889,20 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask, ret;
+	int rw;
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
 	if (req->flags & REQ_F_POLLED)
 		return false;
-	if (!def->pollin && !def->pollout)
+	if (def->pollin)
+		rw = READ;
+	else if (def->pollout)
+		rw = WRITE;
+	else
+		return false;
+	/* if we can't nonblock try, then no point in arming a poll handler */
+	if (!io_file_supports_async(req->file, rw))
 		return false;
 
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);

