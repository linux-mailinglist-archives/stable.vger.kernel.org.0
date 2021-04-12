Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A49135BCB8
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhDLIo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:44:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:36600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237642AbhDLIoa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:44:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7473F60241;
        Mon, 12 Apr 2021 08:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217053;
        bh=ie4AqU6PGRCGqkdDrKAMALP35KYc4CX5LNy4K6p6SSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZQvFi33dssdYIxtRw3sILBJtyCRGE1HDLN/hLNFUAZeMWheWgaZZMMK8h13VjyVsT
         SEB0T7sVYYrp8PX4K90cYar3zPo6webVg9wW8Mh/I8XYH9fd7H9ITE3QpQzpvXVMX9
         oNHlnzh/qEo6+8n3DQfqdRhxCBfwVqlzh6WB7Q44=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 52/66] net: sched: bump refcount for new action in ACT replace mode
Date:   Mon, 12 Apr 2021 10:40:58 +0200
Message-Id: <20210412083959.808110959@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412083958.129944265@linuxfoundation.org>
References: <20210412083958.129944265@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

commit 6855e8213e06efcaf7c02a15e12b1ae64b9a7149 upstream.

Currently, action creation using ACT API in replace mode is buggy.
When invoking for non-existent action index 42,

	tc action replace action bpf obj foo.o sec <xyz> index 42

kernel creates the action, fills up the netlink response, and then just
deletes the action after notifying userspace.

	tc action show action bpf

doesn't list the action.

This happens due to the following sequence when ovr = 1 (replace mode)
is enabled:

tcf_idr_check_alloc is used to atomically check and either obtain
reference for existing action at index, or reserve the index slot using
a dummy entry (ERR_PTR(-EBUSY)).

This is necessary as pointers to these actions will be held after
dropping the idrinfo lock, so bumping the reference count is necessary
as we need to insert the actions, and notify userspace by dumping their
attributes. Finally, we drop the reference we took using the
tcf_action_put_many call in tcf_action_add. However, for the case where
a new action is created due to free index, its refcount remains one.
This when paired with the put_many call leads to the kernel setting up
the action, notifying userspace of its creation, and then tearing it
down. For existing actions, the refcount is still held so they remain
unaffected.

Fortunately due to rtnl_lock serialization requirement, such an action
with refcount == 1 will not be concurrently deleted by anything else, at
best CLS API can move its refcount up and down by binding to it after it
has been published from tcf_idr_insert_many. Since refcount is atleast
one until put_many call, CLS API cannot delete it. Also __tcf_action_put
release path already ensures deterministic outcome (either new action
will be created or existing action will be reused in case CLS API tries
to bind to action concurrently) due to idr lock serialization.

We fix this by making refcount of newly created actions as 2 in ACT API
replace mode. A relaxed store will suffice as visibility is ensured only
after the tcf_idr_insert_many call.

Note that in case of creation or overwriting using CLS API only (i.e.
bind = 1), overwriting existing action object is not allowed, and any
such request is silently ignored (without error).

The refcount bump that occurs in tcf_idr_check_alloc call there for
existing action will pair with tcf_exts_destroy call made from the
owner module for the same action. In case of action creation, there
is no existing action, so no tcf_exts_destroy callback happens.

This means no code changes for CLS API.

Fixes: cae422f379f3 ("net: sched: use reference counting action init")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_api.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -900,6 +900,9 @@ struct tc_action *tcf_action_init_1(stru
 		return ERR_PTR(-EINVAL);
 	}
 
+	if (!bind && ovr && err == ACT_P_CREATED)
+		refcount_set(&a->tcfa_refcnt, 2);
+
 	return a;
 
 err_mod:


