Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10A4AEB768
	for <lists+stable@lfdr.de>; Thu, 31 Oct 2019 19:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbfJaSnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Oct 2019 14:43:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38510 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729313AbfJaSnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Oct 2019 14:43:11 -0400
Received: by mail-pf1-f193.google.com with SMTP id c13so4967950pfp.5
        for <stable@vger.kernel.org>; Thu, 31 Oct 2019 11:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4/U+0okk1hniJy1PkkUgDrPxQjUiOYj9Xv+usDIOoa4=;
        b=C9JnBujpFzlRsnRd/lWJO6DEXwW+y2pKrlhlfH8huS/Y2Mf83z7RBBEOC9eanyAwyj
         jqAM1dwIYlUh0fY38gLXGMPfYUkhtY6o4JASs8b07fVj/CtRbkQOtjE6anTxaueANmuT
         ii5lv79CsjcYHqjtrb1WZVOeyPvGRYSnNS+IY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4/U+0okk1hniJy1PkkUgDrPxQjUiOYj9Xv+usDIOoa4=;
        b=QeDtspX4yK7grPOKsc1vWokFTdFCTCqDwEecSY456OU7nbF6BEIqaPguh2HovIWHBP
         VcgT5Ng5qzmQLMXaCDGCUR8XPlf+k0RqRVpY9C3wQsmzcpP8n3L2QlXVCeSIh+rWPBJt
         i7xeyvgF5X0sF7NyF4yn1K2jKyaIn5+XpC5G0YtHdsoRG8DiUVLfLJGuFMzMxmNaTx6L
         3FSG2RBooejZcWLGVI8VtW3jPrbbpy7P+8bqKHJ3Kod8rcnZ5DzTRU9qxxYtVt0wsahp
         KuC+QrzepMHyL4yosYxuuA/aUYT8hXW+bpPh2tHQQWqjmP1B/TGHT1slzZr0yGqQH0Hf
         zr5w==
X-Gm-Message-State: APjAAAWj0tRAxW5JQ0iE9RnI4riaMFQ1g4XiTtRBhriZCXN0Bb9JKNV6
        VrNjYd8fXcTbJawzQbUq+PQGCFfUg8k=
X-Google-Smtp-Source: APXvYqy8uicO20od+5wnpNg/OuuHSx1YIM0VbiuHdOfM+XEISaonl06QtnPrb6Pdz1Ij6O3soEY/Jg==
X-Received: by 2002:a17:90a:bf06:: with SMTP id c6mr9223783pjs.81.1572547388388;
        Thu, 31 Oct 2019 11:43:08 -0700 (PDT)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id h13sm3991151pfo.55.2019.10.31.11.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 11:43:07 -0700 (PDT)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net
Subject: [v4.14.y] net_sched: check cops->tcf_block in tc_bind_tclass()
Date:   Thu, 31 Oct 2019 11:42:59 -0700
Message-Id: <20191031184259.165183-1-zsm@chromium.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

commit 8b142a00edcf8422ca48b8de88d286efb500cb53 upstream

At least sch_red and sch_tbf don't implement ->tcf_block()
while still have a non-zero tc "class".

Instead of adding nop implementations to each of such qdisc's,
we can just relax the check of cops->tcf_block() in
tc_bind_tclass(). They don't support TC filter anyway.

Reported-by: syzbot+21b29db13c065852f64b@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Zubin Mithra <zsm@chromium.org>
---
Notes:
* Syzkaller triggered a NULL pointer dereference with the following
stacktrace:
 tc_bind_tclass+0x139/0x550 net/sched/sch_api.c:1697
 tc_ctl_tclass+0x9de/0xb30 net/sched/sch_api.c:1831
 rtnetlink_rcv_msg+0x545/0x1010 net/core/rtnetlink.c:4287
 netlink_rcv_skb+0x15e/0x3a0 net/netlink/af_netlink.c:2432
 rtnetlink_rcv+0x22/0x30 net/core/rtnetlink.c:4299
 netlink_unicast_kernel net/netlink/af_netlink.c:1286 [inline]
 netlink_unicast+0x4ac/0x6a0 net/netlink/af_netlink.c:1312
 netlink_sendmsg+0x943/0xec0 net/netlink/af_netlink.c:1877
 sock_sendmsg_nosec net/socket.c:646 [inline]
 sock_sendmsg+0xd5/0x110 net/socket.c:656
 ___sys_sendmsg+0x754/0x890 net/socket.c:2062
 __sys_sendmsg+0xd2/0x1f0 net/socket.c:2096
 C_SYSC_sendmsg net/compat.c:744 [inline]
 compat_SyS_sendmsg+0x2f/0x40 net/compat.c:742
 do_syscall_32_irqs_on arch/x86/entry/common.c:352 [inline]
 do_fast_syscall_32+0x3bb/0xdd1 arch/x86/entry/common.c:415
 entry_SYSENTER_compat+0x84/0x96 arch/x86/entry/entry_64_compat.S:139

* This commit is present in linux-4.19.y.

* Tests run: Chrome OS tryjobs, Syzkaller reproducer

 net/sched/sch_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 637949b576c63..296e95f72eb15 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1695,6 +1695,8 @@ static void tc_bind_tclass(struct Qdisc *q, u32 portid, u32 clid,
 	cl = cops->find(q, portid);
 	if (!cl)
 		return;
+	if (!cops->tcf_block)
+		return;
 	block = cops->tcf_block(q, cl);
 	if (!block)
 		return;
-- 
2.24.0.rc0.303.g954a862665-goog

