Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2AB54D71A
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729737AbfFTSQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729730AbfFTSQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:16:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C71892082C;
        Thu, 20 Jun 2019 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054568;
        bh=2khrPAEcIHE8KFALuvBXdNyBuY58gqu34hTQh9PaFzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSxkrCWZFecIIp0uWaxiDDjns1NKmm07HvCDX5CRiPGTA80rkntI1xGSwwMIZiE5O
         7ofW+HCzlWIn5RuqWfTHA/yIf+UW3wN4i/nPdfsln8WRKym5Fzm4geHiFFtBj5Tjqf
         zsOK6iJF1LisUPZ1a/hLi1gpkCjrp7FGdVyh4zmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 73/98] xenbus: Avoid deadlock during suspend due to open transactions
Date:   Thu, 20 Jun 2019 19:57:40 +0200
Message-Id: <20190620174352.879335822@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d10e0cc113c9e1b64b5c6e3db37b5c839794f3df ]

During a suspend/resume, the xenwatch thread waits for all outstanding
xenstore requests and transactions to complete. This does not work
correctly for transactions started by userspace because it waits for
them to complete after freezing userspace threads which means the
transactions have no way of completing, resulting in a deadlock. This is
trivial to reproduce by running this script and then suspending the VM:

    import pyxs, time
    c = pyxs.client.Client(xen_bus_path="/dev/xen/xenbus")
    c.connect()
    c.transaction()
    time.sleep(3600)

Even if this deadlock were resolved, misbehaving userspace should not
prevent a VM from being migrated. So, instead of waiting for these
transactions to complete before suspending, store the current generation
id for each transaction when it is started. The global generation id is
incremented during resume. If the caller commits the transaction and the
generation id does not match the current generation id, return EAGAIN so
that they try again. If the transaction was instead discarded, return OK
since no changes were made anyway.

This only affects users of the xenbus file interface. In-kernel users of
xenbus are assumed to be well-behaved and complete all transactions
before freezing.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus.h              |  3 +++
 drivers/xen/xenbus/xenbus_dev_frontend.c | 18 ++++++++++++++++++
 drivers/xen/xenbus/xenbus_xs.c           |  7 +++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus.h b/drivers/xen/xenbus/xenbus.h
index 092981171df1..d75a2385b37c 100644
--- a/drivers/xen/xenbus/xenbus.h
+++ b/drivers/xen/xenbus/xenbus.h
@@ -83,6 +83,7 @@ struct xb_req_data {
 	int num_vecs;
 	int err;
 	enum xb_req_state state;
+	bool user_req;
 	void (*cb)(struct xb_req_data *);
 	void *par;
 };
@@ -133,4 +134,6 @@ void xenbus_ring_ops_init(void);
 int xenbus_dev_request_and_reply(struct xsd_sockmsg *msg, void *par);
 void xenbus_dev_queue_reply(struct xb_req_data *req);
 
+extern unsigned int xb_dev_generation_id;
+
 #endif
diff --git a/drivers/xen/xenbus/xenbus_dev_frontend.c b/drivers/xen/xenbus/xenbus_dev_frontend.c
index 0782ff3c2273..39c63152a358 100644
--- a/drivers/xen/xenbus/xenbus_dev_frontend.c
+++ b/drivers/xen/xenbus/xenbus_dev_frontend.c
@@ -62,6 +62,8 @@
 
 #include "xenbus.h"
 
+unsigned int xb_dev_generation_id;
+
 /*
  * An element of a list of outstanding transactions, for which we're
  * still waiting a reply.
@@ -69,6 +71,7 @@
 struct xenbus_transaction_holder {
 	struct list_head list;
 	struct xenbus_transaction handle;
+	unsigned int generation_id;
 };
 
 /*
@@ -441,6 +444,7 @@ static int xenbus_write_transaction(unsigned msg_type,
 			rc = -ENOMEM;
 			goto out;
 		}
+		trans->generation_id = xb_dev_generation_id;
 		list_add(&trans->list, &u->transactions);
 	} else if (msg->hdr.tx_id != 0 &&
 		   !xenbus_get_transaction(u, msg->hdr.tx_id))
@@ -449,6 +453,20 @@ static int xenbus_write_transaction(unsigned msg_type,
 		 !(msg->hdr.len == 2 &&
 		   (!strcmp(msg->body, "T") || !strcmp(msg->body, "F"))))
 		return xenbus_command_reply(u, XS_ERROR, "EINVAL");
+	else if (msg_type == XS_TRANSACTION_END) {
+		trans = xenbus_get_transaction(u, msg->hdr.tx_id);
+		if (trans && trans->generation_id != xb_dev_generation_id) {
+			list_del(&trans->list);
+			kfree(trans);
+			if (!strcmp(msg->body, "T"))
+				return xenbus_command_reply(u, XS_ERROR,
+							    "EAGAIN");
+			else
+				return xenbus_command_reply(u,
+							    XS_TRANSACTION_END,
+							    "OK");
+		}
+	}
 
 	rc = xenbus_dev_request_and_reply(&msg->hdr, u);
 	if (rc && trans) {
diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index 49a3874ae6bb..ddc18da61834 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -105,6 +105,7 @@ static void xs_suspend_enter(void)
 
 static void xs_suspend_exit(void)
 {
+	xb_dev_generation_id++;
 	spin_lock(&xs_state_lock);
 	xs_suspend_active--;
 	spin_unlock(&xs_state_lock);
@@ -125,7 +126,7 @@ static uint32_t xs_request_enter(struct xb_req_data *req)
 		spin_lock(&xs_state_lock);
 	}
 
-	if (req->type == XS_TRANSACTION_START)
+	if (req->type == XS_TRANSACTION_START && !req->user_req)
 		xs_state_users++;
 	xs_state_users++;
 	rq_id = xs_request_id++;
@@ -140,7 +141,7 @@ void xs_request_exit(struct xb_req_data *req)
 	spin_lock(&xs_state_lock);
 	xs_state_users--;
 	if ((req->type == XS_TRANSACTION_START && req->msg.type == XS_ERROR) ||
-	    (req->type == XS_TRANSACTION_END &&
+	    (req->type == XS_TRANSACTION_END && !req->user_req &&
 	     !WARN_ON_ONCE(req->msg.type == XS_ERROR &&
 			   !strcmp(req->body, "ENOENT"))))
 		xs_state_users--;
@@ -286,6 +287,7 @@ int xenbus_dev_request_and_reply(struct xsd_sockmsg *msg, void *par)
 	req->num_vecs = 1;
 	req->cb = xenbus_dev_queue_reply;
 	req->par = par;
+	req->user_req = true;
 
 	xs_send(req, msg);
 
@@ -313,6 +315,7 @@ static void *xs_talkv(struct xenbus_transaction t,
 	req->vec = iovec;
 	req->num_vecs = num_vecs;
 	req->cb = xs_wake_up;
+	req->user_req = false;
 
 	msg.req_id = 0;
 	msg.tx_id = t.id;
-- 
2.20.1



