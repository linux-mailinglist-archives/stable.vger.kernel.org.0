Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0267113261
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730825AbfLDSH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730832AbfLDSH5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:07:57 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F8D620674;
        Wed,  4 Dec 2019 18:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482876;
        bh=GYUwYBLbPvTeBue7pRSHLIh9EK/b9Y9ty9FB+eIcFBk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hqj/ZVFvk+vquW9On5F4dzofi04NpYUrBam8CwXi7xoX078LBa02iM88+c+LRgrJJ
         /WfhX0GPBve2P8gtihaMqRIuNyvftLl4/59NBcgMY7M4Y4JJ7GlenUpG/5q+EKbir/
         /FdUVXSQ+cTBl9YTZJoF4YpHefCaaHY6qZ5HSzW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <dong.menglong@zte.com.cn>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 169/209] macvlan: schedule bc_work even if error
Date:   Wed,  4 Dec 2019 18:56:21 +0100
Message-Id: <20191204175335.116295557@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

[ Upstream commit 1d7ea55668878bb350979c377fc72509dd6f5b21 ]

While enqueueing a broadcast skb to port->bc_queue, schedule_work()
is called to add port->bc_work, which processes the skbs in
bc_queue, to "events" work queue. If port->bc_queue is full, the
skb will be discarded and schedule_work(&port->bc_work) won't be
called. However, if port->bc_queue is full and port->bc_work is not
running or pending, port->bc_queue will keep full and schedule_work()
won't be called any more, and all broadcast skbs to macvlan will be
discarded. This case can happen:

macvlan_process_broadcast() is the pending function of port->bc_work,
it moves all the skbs in port->bc_queue to the queue "list", and
processes the skbs in "list". During this, new skbs will keep being
added to port->bc_queue in macvlan_broadcast_enqueue(), and
port->bc_queue may already full when macvlan_process_broadcast()
return. This may happen, especially when there are a lot of real-time
threads and the process is preempted.

Fix this by calling schedule_work(&port->bc_work) even if
port->bc_work is full in macvlan_broadcast_enqueue().

Fixes: 412ca1550cbe ("macvlan: Move broadcasts into a work queue")
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -363,10 +363,11 @@ static void macvlan_broadcast_enqueue(st
 	}
 	spin_unlock(&port->bc_queue.lock);
 
+	schedule_work(&port->bc_work);
+
 	if (err)
 		goto free_nskb;
 
-	schedule_work(&port->bc_work);
 	return;
 
 free_nskb:


