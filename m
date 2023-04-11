Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77716DDB91
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:03:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbjDKND1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjDKNDX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:03:23 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D124EDD
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1681218181; x=1712754181;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=F6afHIhDjsEA9/+NgDws+ajjyJCaWOzln2n2exsbkNQ=;
  b=l2NhLiFSzi4nX8Zbqo+KeKjbjCh5bDFs+hOe+8p+Hwwv3yiWzJkBbMp9
   d4GKsCJc6eSXo6b7pjEG+I5S2+nvo/uDyW/lWyGj16UiR5gPRojTM6lgv
   Ct07ylyJU7KlErjN4g5Io8keHCGSfxdyKGct/qqn5j5+PeqW5vyk1m+Cm
   g=;
X-IronPort-AV: E=Sophos;i="5.98,336,1673913600"; 
   d="scan'208";a="319085699"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2023 13:02:18 +0000
Received: from EX19D002EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-a893d89c.us-west-2.amazon.com (Postfix) with ESMTPS id EA93340D72;
        Tue, 11 Apr 2023 13:02:16 +0000 (UTC)
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D002EUA003.ant.amazon.com (10.252.50.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Tue, 11 Apr 2023 13:02:15 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP Server id
 15.2.1118.26 via Frontend Transport; Tue, 11 Apr 2023 13:02:15 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id 1AC3922B50; Tue, 11 Apr 2023 15:02:14 +0200 (CEST)
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Pratyush Yadav <ptyadav@amazon.de>, <stable@vger.kernel.org>,
        <patches@lists.linux.dev>, Eric Dumazet <edumazet@google.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Zubin Mithra <zsm@google.com>,
        Norbert Manthey <nmanthey@amazon.de>
Subject: [PATCH 5.4] net_sched: prevent NULL dereference if default qdisc setup failed
Date:   Tue, 11 Apr 2023 15:02:10 +0200
Message-ID: <20230411130210.113555-1-ptyadav@amazon.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If qdisc_create_dflt() fails, it returns NULL. With CONFIG_NET_SCHED
enabled, the check qdisc != &noop_qdisc passes and qdisc will be passed
to qdisc_hash_add(), which dereferences it.

This assignment was present in the upstream commit
5891cd5ec46c2 ("net_sched: add __rcu annotation to netdev->qdisc") but
was missed in the backport 22d95b5449249 ("net_sched: add __rcu
annotation to netdev->qdisc"), perhaps due to merge conflicts.
dev->qdisc is &noop_qdisc by default and if qdisc_create_dflt() fails,
this assignment will make sure qdisc == &noop_qdisc and no NULL
dereference will take place.

This bug was discovered and resolved using Coverity Static Analysis
Security Testing (SAST) by Synopsys, Inc.

Fixes: 22d95b5449249 ("net_sched: add __rcu annotation to netdev->qdisc")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
---

As usual, this was found by our static code analysis bot. I have
compile-tested this patch and ran a simple boot test. Did not do any
testing specifically to hit this bug.

 net/sched/sch_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 1f055c21be4cf..4250f3cf30e72 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1116,6 +1116,7 @@ static void attach_default_qdiscs(struct net_device *dev)
 			qdisc->ops->attach(qdisc);
 		}
 	}
+	qdisc = rtnl_dereference(dev->qdisc);

 #ifdef CONFIG_NET_SCHED
 	if (qdisc != &noop_qdisc)
--
2.39.2

