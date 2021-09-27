Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23EB419BF5
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236918AbhI0RY3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:24:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236387AbhI0RVy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:21:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9764D6113A;
        Mon, 27 Sep 2021 17:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762839;
        bh=PkICQW9vXMwjB5EsIqS6GBNtcgGHOQUMVJp+T4MPuL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gHsvHPVlvN6LD1+npQ6yqXsyKDKsn6Ur/A+6un45ri5nq6EkfjSfNyBtV3vUT+8bQ
         QBgNQoiJ4WxwPAuPqRa3VoTi5UmIqQJyLnWCVIfzm5ulVbUV9IaJSib0jBaNCVm840
         3nBY7cRnHv14FRLu3My7LsR96jFPu7xomtfT9Bkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 071/162] net: dsa: fix dsa_tree_setup error path
Date:   Mon, 27 Sep 2021 19:01:57 +0200
Message-Id: <20210927170235.915536910@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e5845aa0eadda3d8a950eb8845c1396827131f30 ]

Since the blamed commit, dsa_tree_teardown_switches() was split into two
smaller functions, dsa_tree_teardown_switches and dsa_tree_teardown_ports.

However, the error path of dsa_tree_setup stopped calling dsa_tree_teardown_ports.

Fixes: a57d8c217aad ("net: dsa: flush switchdev workqueue before tearing down CPU/DSA ports")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/dsa2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3a8136d5915d..383fdc0565c7 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1001,6 +1001,7 @@ static int dsa_tree_setup(struct dsa_switch_tree *dst)
 teardown_master:
 	dsa_tree_teardown_master(dst);
 teardown_switches:
+	dsa_tree_teardown_ports(dst);
 	dsa_tree_teardown_switches(dst);
 teardown_default_cpu:
 	dsa_tree_teardown_default_cpu(dst);
-- 
2.33.0



