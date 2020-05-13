Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFFD71D0EEC
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 12:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733064AbgEMJs0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:48:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733061AbgEMJs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:48:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35D7D20753;
        Wed, 13 May 2020 09:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363305;
        bh=2//70JfgGrfyqpGrlGdGZMeHpKH1PrGxXfJ48VpBiDI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oTp0U8KM+Tb2PHgCpN49ivZW4RlE8yM0kmvRh/HhLR9Y5WyYC0/1bQmBvC/WAjJvS
         DbiW0lmGxrOeScxCvT7VsabUphfYcE2SJrW79QIYhswwK0CxGWq+B0HU8O3IWNHon2
         abfyGsPhpzNqSfKURazKEC5Gi/lRKRSaeqRILg1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 20/90] net_sched: sch_skbprio: add message validation to skbprio_change()
Date:   Wed, 13 May 2020 11:44:16 +0200
Message-Id: <20200513094410.864230402@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094408.810028856@linuxfoundation.org>
References: <20200513094408.810028856@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2761121af87de45951989a0adada917837d8fa82 ]

Do not assume the attribute has the right size.

Fixes: aea5f654e6b7 ("net/sched: add skbprio scheduler")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_skbprio.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/sch_skbprio.c
+++ b/net/sched/sch_skbprio.c
@@ -169,6 +169,9 @@ static int skbprio_change(struct Qdisc *
 {
 	struct tc_skbprio_qopt *ctl = nla_data(opt);
 
+	if (opt->nla_len != nla_attr_size(sizeof(*ctl)))
+		return -EINVAL;
+
 	sch->limit = ctl->limit;
 	return 0;
 }


