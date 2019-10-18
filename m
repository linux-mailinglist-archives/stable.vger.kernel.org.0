Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E614DCF02
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 21:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394859AbfJRTG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 15:06:56 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35896 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfJRTG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 15:06:56 -0400
Received: by mail-pf1-f194.google.com with SMTP id y22so4445358pfr.3
        for <stable@vger.kernel.org>; Fri, 18 Oct 2019 12:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dkuVIjOlCQOpHsxzmtvwrYOjz5O+g97jbUngQdVvxNw=;
        b=MldHpSLuP5VmGF2mdu4qf3YJP0a250Na+TGBSu+snKA+wBqLtIS89+ZZNPGC+VOTyc
         GJxZn9qJL103cLOsaTaHaZMi/btjTsszhW58YFsFEhB7CKuQAlvZcUXIDLNkz3VSKPwj
         q6SyxekbICOdI37Nq3550NwlEkfLx9zN8P0p4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dkuVIjOlCQOpHsxzmtvwrYOjz5O+g97jbUngQdVvxNw=;
        b=DOVtlHPqILo8r9NEBR4kXpdHszGiSrxANuv+uMxJmU5dowwCqE7rK4tnGOvPJsuoLF
         n2aLgiGe4wLDgw9yTzAhTADRDXgfF7/jZPfre/hzne0/tfr8qiWLlNc+YFx3CXlaZaDc
         eKWOk1UnBmgNsZrfrePY4t/84ynwaG+b1PbHYRAZRZ/LhmlDLtOGHCBdKhB63Mo86HJv
         4APwNOj2H3+Grpt5i4NKFmWyASR3Lt6CvuOs0lnoNChHvHnVOW8WyfhFHg5SLDLFqn77
         8tMc4zsnXER9aJmw6vvYSP+NDPKbczWQrzmbIgT3dE066HDD+MheCfZyb3JwaS+LTqjl
         osWA==
X-Gm-Message-State: APjAAAVqwm2SLqTSaD+37WxNVpWyq/sHjSd0nKVuXnxWdHcJ9DseFcL5
        +2nr81shwrst4k3dPDZqHrvW1/xK0+U=
X-Google-Smtp-Source: APXvYqw3TruQtEEF5oHFaP3bFIA1TcZhdBq8tFR8uMlzRpK/1w6BkcUBY6dWaPnzcU3OOL4wtPXyjg==
X-Received: by 2002:a62:2bc6:: with SMTP id r189mr3796826pfr.210.1571425614571;
        Fri, 18 Oct 2019 12:06:54 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id u7sm6862135pfn.61.2019.10.18.12.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 12:06:53 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        keescook@chromium.org, davem@davemloft.net
Subject: [v4.4.y] net: sched: Fix memory exposure from short TCA_U32_SEL
Date:   Fri, 18 Oct 2019 12:06:47 -0700
Message-Id: <20191018190647.158575-1-zsm@chromium.org>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

commit 98c8f125fd8a6240ea343c1aa50a1be9047791b8 upstream

Via u32_change(), TCA_U32_SEL has an unspecified type in the netlink
policy, so max length isn't enforced, only minimum. This means nkeys
(from userspace) was being trusted without checking the actual size of
nla_len(), which could lead to a memory over-read, and ultimately an
exposure via a call to u32_dump(). Reachability is CAP_NET_ADMIN within
a namespace.

Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Zubin Mithra <zsm@chromium.org>
---
Notes:
* Syzkaller triggered an OOB read in u32_change with the following
stacktrace:
 [<ffffffff81cb8911>] __dump_stack lib/dump_stack.c:15 [inline]
 [<ffffffff81cb8911>] dump_stack+0xc1/0x120 lib/dump_stack.c:51
 [<ffffffff81525640>] print_trailer+0x151/0x15a mm/slub.c:658
 [<ffffffff81525913>] object_err+0x35/0x3d mm/slub.c:665
 [<ffffffff8152619f>] print_address_description mm/kasan/report.c:188 [inline]
 [<ffffffff8152619f>] kasan_report_error mm/kasan/report.c:285 [inline]
 [<ffffffff8152619f>] kasan_report.part.0.cold+0x21a/0x4c1 mm/kasan/report.c:310
 [<ffffffff814ec0a5>] kasan_report+0x25/0x30 mm/kasan/report.c:297
 [<ffffffff814eb336>] check_memory_region_inline mm/kasan/kasan.c:292 [inline]
 [<ffffffff814eb336>] check_memory_region+0x116/0x190 mm/kasan/kasan.c:299
 [<ffffffff814eb7d4>] memcpy+0x24/0x50 mm/kasan/kasan.c:334
 [<ffffffff823b6d33>] u32_change+0xb03/0x1e60 net/sched/cls_u32.c:844
 [<ffffffff8232f1a0>] tc_ctl_tfilter+0xc20/0x15f0 net/sched/cls_api.c:335
 [<ffffffff822d82e5>] rtnetlink_rcv_msg+0x4f5/0x6d0 net/core/rtnetlink.c:3605
 [<ffffffff823c92ef>] netlink_rcv_skb+0xdf/0x2f0 net/netlink/af_netlink.c:2361
 [<ffffffff822d7de0>] rtnetlink_rcv+0x30/0x40 net/core/rtnetlink.c:3611
 [<ffffffff823c7f02>] netlink_unicast_kernel net/netlink/af_netlink.c:1277 [inline]
 [<ffffffff823c7f02>] netlink_unicast+0x462/0x650 net/netlink/af_netlink.c:1303
 [<ffffffff823c8891>] netlink_sendmsg+0x7a1/0xc50 net/netlink/af_netlink.c:1859
 [<ffffffff8223b165>] sock_sendmsg_nosec net/socket.c:627 [inline]
 [<ffffffff8223b165>] sock_sendmsg+0xd5/0x110 net/socket.c:637
 [<ffffffff8223ebe7>] ___sys_sendmsg+0x767/0x890 net/socket.c:1964
 [<ffffffff8224175b>] __sys_sendmsg+0xbb/0x150 net/socket.c:1998
 [<ffffffff82241822>] SYSC_sendmsg net/socket.c:2009 [inline]
 [<ffffffff82241822>] SyS_sendmsg+0x32/0x50 net/socket.c:2005
 [<ffffffff82a489e7>] entry_SYSCALL_64_fastpath+0x1e/0xa0

* The commit is present in linux-4.9.y.

* This backport is similar to the commit in linux-4.9.y and addresses
conflicts related to struct_size() not being present.

* Tests run: Chrome OS tryjobs, Syzkaller reproducer

 net/sched/cls_u32.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4fbb67430ce48..4d745a2efd201 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -734,6 +734,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 	struct nlattr *opt = tca[TCA_OPTIONS];
 	struct nlattr *tb[TCA_U32_MAX + 1];
 	u32 htid;
+	size_t sel_size;
 	int err;
 #ifdef CONFIG_CLS_U32_PERF
 	size_t size;
@@ -827,8 +828,11 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 		return -EINVAL;
 
 	s = nla_data(tb[TCA_U32_SEL]);
+	sel_size = sizeof(*s) + sizeof(*s->keys) * s->nkeys;
+	if (nla_len(tb[TCA_U32_SEL]) < sel_size)
+		return -EINVAL;
 
-	n = kzalloc(sizeof(*n) + s->nkeys*sizeof(struct tc_u32_key), GFP_KERNEL);
+	n = kzalloc(offsetof(typeof(*n), sel) + sel_size, GFP_KERNEL);
 	if (n == NULL)
 		return -ENOBUFS;
 
@@ -841,7 +845,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 	}
 #endif
 
-	memcpy(&n->sel, s, sizeof(*s) + s->nkeys*sizeof(struct tc_u32_key));
+	memcpy(&n->sel, s, sel_size);
 	RCU_INIT_POINTER(n->ht_up, ht);
 	n->handle = handle;
 	n->fshift = s->hmask ? ffs(ntohl(s->hmask)) - 1 : 0;
-- 
2.23.0.866.gb869b98d4c-goog

