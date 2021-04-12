Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C9935C098
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240362AbhDLJOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:14:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240887AbhDLJLI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AFF1613AE;
        Mon, 12 Apr 2021 09:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218430;
        bh=cedOHoga62bjOCCok7zdEi/5iWBFbe7RjjrWHmGHuOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgPANq0+xdYcQlqzHUj0pJ/Vk37O9YY2aXwtNOGuFpb4l9TUlefIEHGIesrOscBE5
         PH3FclBM4B7qW6U1Be/3A5wXX3q258Nr/pyOzKOTBCXw0GxZ6d1gM9pwhszRNp+1St
         BM0IpAsXBCS3rxtrT/KKc6FxThdeiLiiN+W/3DlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.11 194/210] net: sched: bump refcount for new action in ACT replace mode
Date:   Mon, 12 Apr 2021 10:41:39 +0200
Message-Id: <20210412084022.477353803@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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
@@ -1049,6 +1049,9 @@ struct tc_action *tcf_action_init_1(stru
 	if (!name)
 		a->hw_stats = hw_stats;
 
+	if (!bind && ovr && err == ACT_P_CREATED)
+		refcount_set(&a->tcfa_refcnt, 2);
+
 	return a;
 
 err_out:


