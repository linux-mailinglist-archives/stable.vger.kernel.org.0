Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8196C148349
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404586AbgAXLey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:34:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404538AbgAXLdB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:33:01 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D102020704;
        Fri, 24 Jan 2020 11:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865581;
        bh=o5UBPS4PzJndnqyFENeG0rQ9LWhNSKEmr6Ed1xVO4Ck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qZQzNWJCJGnYLjTFlCanvKwNe86UlemtoT5O3JEPhsnnbt/JGyGdonDTCS0xDz28m
         EzdKaY+QV5UaN6liQe6uTD3TItkEhSq5Oz4SJf5qLgfQstptExLD48hPVJVDEW/mIW
         RtuCvajqVU2DreKHSqDZg765Qo3q558fXA0nOkgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 585/639] net: sched: cbs: Avoid division by zero when calculating the port rate
Date:   Fri, 24 Jan 2020 10:32:35 +0100
Message-Id: <20200124093202.761623028@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

[ Upstream commit 83c8c3cf45163f0c823db37be6ab04dfcf8ac751 ]

As explained in the "net: sched: taprio: Avoid division by zero on
invalid link speed" commit, it is legal for the ethtool API to return
zero as a link speed. So guard against it to ensure we don't perform a
division by zero in kernel.

Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_cbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 289f66b9238d3..940e72d6db185 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -310,7 +310,7 @@ static void cbs_set_port_rate(struct net_device *dev, struct cbs_sched_data *q)
 	if (err < 0)
 		goto skip;
 
-	if (ecmd.base.speed != SPEED_UNKNOWN)
+	if (ecmd.base.speed && ecmd.base.speed != SPEED_UNKNOWN)
 		speed = ecmd.base.speed;
 
 skip:
-- 
2.20.1



