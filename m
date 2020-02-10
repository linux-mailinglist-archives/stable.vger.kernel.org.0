Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C57157673
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728568AbgBJMwl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:52:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:46368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbgBJMmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:19 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B321C24650;
        Mon, 10 Feb 2020 12:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338538;
        bh=a5qcjP+kDxAn/qvCFH3xMONL9V4BA5fly2WYTF6a/e0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyyT74GcZogXPr7phAu7m+Dz87pX48JG2JEvNMVGUw7q6dTJ7vv4wVxQWsNdD2bcj
         G+4Yc+dsoACg8nzX3DIOlSYM+uJYrC8FPdDP5N9dZ/Pobjl8vOGAIL3Yoyf63UHpU7
         DP6weDC4DaL/TvuGHGO/5Y0JSxhzsohR++2ot6F8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 338/367] taprio: Use taprio_reset_tc() to reset Traffic Classes configuration
Date:   Mon, 10 Feb 2020 04:34:11 -0800
Message-Id: <20200210122453.898485878@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 7c16680a08ee1e444a67d232c679ccf5b30fad16 ]

When destroying the current taprio instance, which can happen when the
creation of one fails, we should reset the traffic class configuration
back to the default state.

netdev_reset_tc() is a better way because in addition to setting the
number of traffic classes to zero, it also resets the priority to
traffic classes mapping to the default value.

Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/sch_taprio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1588,7 +1588,7 @@ static void taprio_destroy(struct Qdisc
 	}
 	q->qdiscs = NULL;
 
-	netdev_set_num_tc(dev, 0);
+	netdev_reset_tc(dev);
 
 	if (q->oper_sched)
 		call_rcu(&q->oper_sched->rcu, taprio_free_sched_cb);


