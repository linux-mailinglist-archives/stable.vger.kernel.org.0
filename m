Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE334CAB2C
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387863AbfJCQPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:15:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732566AbfJCQPu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:15:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC56F2054F;
        Thu,  3 Oct 2019 16:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119349;
        bh=W4X8vXVHEFPFQSTdvRznwhMJHRc36QiMXlnVAAWFoUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2sd8/vwTnmwIGwMEB5fTh4qjP797uKLWbTKRw6tXipVC0Ilk/El0HlCdd0pPwFERf
         LsEH5W+slu6/QrKsb7Td77ubB5M8bO/YLw9OenKbNpkhW8+WHHm0RDN/vph6BUSG73
         iPPMQtjsUpbVaZMPVRshEH3j8sDbNB0bUjwI7qyM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com
Subject: [PATCH 4.19 007/211] net_sched: add max len check for TCA_KIND
Date:   Thu,  3 Oct 2019 17:51:13 +0200
Message-Id: <20191003154448.932834647@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 62794fc4fbf52f2209dc094ea255eaef760e7d01 ]

The TCA_KIND attribute is of NLA_STRING which does not check
the NUL char. KMSAN reported an uninit-value of TCA_KIND which
is likely caused by the lack of NUL.

Change it to NLA_NUL_STRING and add a max len too.

Fixes: 8b4c3cdd9dd8 ("net: sched: Add policy validation for tc attributes")
Reported-and-tested-by: syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_api.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1308,7 +1308,8 @@ check_loop_fn(struct Qdisc *q, unsigned
 }
 
 const struct nla_policy rtm_tca_policy[TCA_MAX + 1] = {
-	[TCA_KIND]		= { .type = NLA_STRING },
+	[TCA_KIND]		= { .type = NLA_NUL_STRING,
+				    .len = IFNAMSIZ - 1 },
 	[TCA_RATE]		= { .type = NLA_BINARY,
 				    .len = sizeof(struct tc_estimator) },
 	[TCA_STAB]		= { .type = NLA_NESTED },


