Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9182E6750
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbfJ0VTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731551AbfJ0VTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:49 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D4152070B;
        Sun, 27 Oct 2019 21:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211189;
        bh=D4p/k8K+pcrKKBqKJkh62m+JChkk/cjGS2MuusHjUes=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyaGJm3sBCKSFey5nRaxN/87+ditK11ku9dQ9IaHFCP8FNMiCtF0w/aPHB9360yd7
         /qlzdbnNZDYer3bP4vOJ/+w8vQDFZzLb/+UABZUTM9fpVjVePHokiCKfoEPkJAHoyZ
         f8DmKqwa/QktzENvEh6qvLm/KMR3624S9+OXawyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 063/197] net_sched: fix backward compatibility for TCA_ACT_KIND
Date:   Sun, 27 Oct 2019 21:59:41 +0100
Message-Id: <20191027203355.066356964@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit 4b793feccae3b06764268377a4030eb774ed924e ]

For TCA_ACT_KIND, we have to keep the backward compatibility too,
and rely on nla_strlcpy() to check and terminate the string with
a NUL.

Note for TC actions, nla_strcmp() is already used to compare kind
strings, so we don't need to fix other places.

Fixes: 199ce850ce11 ("net_sched: add policy validation for action attributes")
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 2558f00f6b3ed..4e7429c6f8649 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -832,8 +832,7 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
 }
 
 static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
-	[TCA_ACT_KIND]		= { .type = NLA_NUL_STRING,
-				    .len = IFNAMSIZ - 1 },
+	[TCA_ACT_KIND]		= { .type = NLA_STRING },
 	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
 	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
 				    .len = TC_COOKIE_MAX_SIZE },
@@ -865,8 +864,10 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
 			goto err_out;
 		}
-		nla_strlcpy(act_name, kind, IFNAMSIZ);
-
+		if (nla_strlcpy(act_name, kind, IFNAMSIZ) >= IFNAMSIZ) {
+			NL_SET_ERR_MSG(extack, "TC action name too long");
+			goto err_out;
+		}
 		if (tb[TCA_ACT_COOKIE]) {
 			cookie = nla_memdup_cookie(tb);
 			if (!cookie) {
-- 
2.20.1



