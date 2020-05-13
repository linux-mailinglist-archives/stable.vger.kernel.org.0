Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 837091D0CA5
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:46:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732646AbgEMJqb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:46:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:43920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732622AbgEMJq3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 05:46:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F0E12492C;
        Wed, 13 May 2020 09:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589363188;
        bh=4MFURn699aH2rSYMG6kW1QgGR/t00LzkOG1i+nuVH1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GuejD/ehuDlgRJ428/aZTOGDnEYSVGma18alKNEIEd6YAkzV+YXlln8BJq3BEVrJ/
         ZcQo8VDBf2eImpEov2h+/G1n46zQFyLYCpBbkFTHRN9KsAUaT+wKaI42WsZ3AC1xiX
         rDwpJ39Wxz+ez/Kazq8ozuCla4POlas+7WtALBPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 08/48] net_sched: sch_skbprio: add message validation to skbprio_change()
Date:   Wed, 13 May 2020 11:44:34 +0200
Message-Id: <20200513094354.050443366@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200513094351.100352960@linuxfoundation.org>
References: <20200513094351.100352960@linuxfoundation.org>
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
@@ -173,6 +173,9 @@ static int skbprio_change(struct Qdisc *
 {
 	struct tc_skbprio_qopt *ctl = nla_data(opt);
 
+	if (opt->nla_len != nla_attr_size(sizeof(*ctl)))
+		return -EINVAL;
+
 	sch->limit = ctl->limit;
 	return 0;
 }


