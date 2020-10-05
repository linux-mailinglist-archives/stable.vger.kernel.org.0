Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9429283AFB
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgJEPi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:38:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727792AbgJEPah (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:30:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D22820637;
        Mon,  5 Oct 2020 15:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911836;
        bh=Qh6Luh8pL05WhSEXBGdJQV+273ROVrAnhb5YAdEVCIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HA6h9UEsfcuv7HIYnBbAHv4hxgab2/rK/CvbvbhMGElViYTZyM8EbQVpk8BoiMB/B
         D8HAjXkJYKza9k2Q0oTGFvmtCu9ykeQxqyhWABM5iNRjstiz/MRiBzQUg0mF7J3Wue
         Cm7ivKKvdkZrc+5WWyjjMbS32d+PsIJDWpZQgyM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will McVicker <willmcvicker@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 57/57] netfilter: ctnetlink: add a range check for l3/l4 protonum
Date:   Mon,  5 Oct 2020 17:27:09 +0200
Message-Id: <20201005142112.543294525@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will McVicker <willmcvicker@google.com>

commit 1cc5ef91d2ff94d2bf2de3b3585423e8a1051cb6 upstream.

The indexes to the nf_nat_l[34]protos arrays come from userspace. So
check the tuple's family, e.g. l3num, when creating the conntrack in
order to prevent an OOB memory access during setup.  Here is an example
kernel panic on 4.14.180 when userspace passes in an index greater than
NFPROTO_NUMPROTO.

Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:...
Process poc (pid: 5614, stack limit = 0x00000000a3933121)
CPU: 4 PID: 5614 Comm: poc Tainted: G S      W  O    4.14.180-g051355490483
Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM
task: 000000002a3dfffe task.stack: 00000000a3933121
pc : __cfi_check_fail+0x1c/0x24
lr : __cfi_check_fail+0x1c/0x24
...
Call trace:
__cfi_check_fail+0x1c/0x24
name_to_dev_t+0x0/0x468
nfnetlink_parse_nat_setup+0x234/0x258
ctnetlink_parse_nat_setup+0x4c/0x228
ctnetlink_new_conntrack+0x590/0xc40
nfnetlink_rcv_msg+0x31c/0x4d4
netlink_rcv_skb+0x100/0x184
nfnetlink_rcv+0xf4/0x180
netlink_unicast+0x360/0x770
netlink_sendmsg+0x5a0/0x6a4
___sys_sendmsg+0x314/0x46c
SyS_sendmsg+0xb4/0x108
el0_svc_naked+0x34/0x38

This crash is not happening since 5.4+, however, ctnetlink still
allows for creating entries with unsupported layer 3 protocol number.

Fixes: c1d10adb4a521 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
Signed-off-by: Will McVicker <willmcvicker@google.com>
[pablo@netfilter.org: rebased original patch on top of nf.git]
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_conntrack_netlink.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1141,6 +1141,8 @@ ctnetlink_parse_tuple(const struct nlatt
 	if (!tb[CTA_TUPLE_IP])
 		return -EINVAL;
 
+	if (l3num != NFPROTO_IPV4 && l3num != NFPROTO_IPV6)
+		return -EOPNOTSUPP;
 	tuple->src.l3num = l3num;
 
 	err = ctnetlink_parse_tuple_ip(tb[CTA_TUPLE_IP], tuple);


