Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB4D1EA926
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgFAR6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 13:58:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbgFAR6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 13:58:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E28DA2076B;
        Mon,  1 Jun 2020 17:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034322;
        bh=/5kicnZVDq8sN3yiXqwn4vjSktVMba+QyaOXUAnja/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aNh3ZF32IbI2hN9VOcApCPbn2yRC4aavX3zzN7cR5BnnXjthWSSvNo9PKLb1gybjx
         y6OAkqB1VP7ql9I7TEaWep6widGO3rDo+rDON8rKmzD9LABAH5gXxmFs1t4aeJpTt0
         xN59TTxZLc5m1nVyoJ30Xbx3tFaWnvwFQqcptODc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 04/61] net sched: fix reporting the first-time use timestamp
Date:   Mon,  1 Jun 2020 19:53:11 +0200
Message-Id: <20200601174012.179925644@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174010.316778377@linuxfoundation.org>
References: <20200601174010.316778377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roman Mashak <mrv@mojatatu.com>

[ Upstream commit b15e62631c5f19fea9895f7632dae9c1b27fe0cd ]

When a new action is installed, firstuse field of 'tcf_t' is explicitly set
to 0. Value of zero means "new action, not yet used"; as a packet hits the
action, 'firstuse' is stamped with the current jiffies value.

tcf_tm_dump() should return 0 for firstuse if action has not yet been hit.

Fixes: 48d8ee1694dd ("net sched actions: aggregate dumping of actions timeinfo")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Roman Mashak <mrv@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/act_api.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -94,7 +94,8 @@ static inline void tcf_tm_dump(struct tc
 {
 	dtm->install = jiffies_to_clock_t(jiffies - stm->install);
 	dtm->lastuse = jiffies_to_clock_t(jiffies - stm->lastuse);
-	dtm->firstuse = jiffies_to_clock_t(jiffies - stm->firstuse);
+	dtm->firstuse = stm->firstuse ?
+		jiffies_to_clock_t(jiffies - stm->firstuse) : 0;
 	dtm->expires = jiffies_to_clock_t(stm->expires);
 }
 


