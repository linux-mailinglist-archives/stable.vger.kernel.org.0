Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8056EF435
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 14:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240838AbjDZMYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 08:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240507AbjDZMYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 08:24:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 269451702
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 05:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682511835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=a7VyJWExlkKUzJjG8HnQUmFJ6LdeZ7qwLn5Dr7wuZsU=;
        b=PTbTyFCBGJA2TeViG1tnz4RwsDCjJHdY6/trWWOzJQ5IDWi5DjBe1/7PeuhQhhPHF8PtjH
        Uffwj1UE1wlxYuuLXFdE24vuDCF2VHBh+paGmN6rZfEiE1rJb9p0n0vhPQzAQfgKj9f8Yk
        HU61VderoriHZ1Gb95ZEivDenpcbCZs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-212-aceqxdYSMfyWAjfvtjAXmw-1; Wed, 26 Apr 2023 08:23:50 -0400
X-MC-Unique: aceqxdYSMfyWAjfvtjAXmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1A73038123BA;
        Wed, 26 Apr 2023 12:23:44 +0000 (UTC)
Received: from dcaratti.users.ipa.redhat.com (unknown [10.45.225.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70F6E215CDA5;
        Wed, 26 Apr 2023 12:23:42 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     stable@vger.kernel.org
Cc:     edumazet@google.com, pctammela@mojatatu.com, kuba@kernel.org
Subject: [PATCH stable] net/sched: sch_fq: fix integer overflow of "credit"
Date:   Wed, 26 Apr 2023 14:23:11 +0200
Message-Id: <d330e2608d3b079886c7ba627b21e104bbb9be6e.1682511574.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 7041101ff6c3073fd8f2e99920f535b111c929cb upstream.

if sch_fq is configured with "initial quantum" having values greater than
INT_MAX, the first assignment of "credit" does signed integer overflow to
a very negative value.
In this situation, the syzkaller script provided by Cristoph triggers the
CPU soft-lockup warning even with few sockets. It's not an infinite loop,
but "credit" wasn't probably meant to be minus 2Gb for each new flow.
Capping "initial quantum" to INT_MAX proved to fix the issue.

This patch doesn't use netlink validation helpers, since they might not be
available on all stable branches.

Reported-by: Christoph Paasch <cpaasch@apple.com>
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/377
Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
Cc: <stable@vger.kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/sch_fq.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 48d14fb90ba0..12efbcfc2938 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -842,8 +842,16 @@ static int fq_change(struct Qdisc *sch, struct nlattr *opt,
 		}
 	}
 
-	if (tb[TCA_FQ_INITIAL_QUANTUM])
-		q->initial_quantum = nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
+	if (tb[TCA_FQ_INITIAL_QUANTUM]) {
+		u32 initial_quantum = nla_get_u32(tb[TCA_FQ_INITIAL_QUANTUM]);
+
+		if (initial_quantum <= INT_MAX) {
+			q->initial_quantum = initial_quantum;
+		} else {
+			NL_SET_ERR_MSG_MOD(extack, "invalid initial quantum");
+			err = -EINVAL;
+		}
+	}
 
 	if (tb[TCA_FQ_FLOW_DEFAULT_RATE])
 		pr_warn_ratelimited("sch_fq: defrate %u ignored.\n",
-- 
2.39.2

