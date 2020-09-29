Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D789527CD83
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgI2Mo4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:44:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:47392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728691AbgI2LIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:08:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19D3221D92;
        Tue, 29 Sep 2020 11:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377677;
        bh=1QMLin64MVWTNPN6qqj3EmmEWt0wEi4HzuuQKU7Nb3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w4cvDx/4EKVFZ42c2/TrWD/mJXhzurfnqNoHq+FGaEOxWRoXYJXWtEyLWnkt/3jEm
         STID2JoBxBCHxv7g3LqzyfjLxpbGv/ziTKumZK65ckJezniy7FLahgPMDrWpNBny6f
         PIXR4jZ1Mr+yzhlJo+FM1Wkuc8NZ2ewW76txMCXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 032/121] rt_cpu_seq_next should increase position index
Date:   Tue, 29 Sep 2020 12:59:36 +0200
Message-Id: <20200929105931.771885095@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit a3ea86739f1bc7e121d921842f0f4a8ab1af94d9 ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/route.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index c8c51bd2d695b..e9aae4686536a 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -271,6 +271,7 @@ static void *rt_cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		*pos = cpu+1;
 		return &per_cpu(rt_cache_stat, cpu);
 	}
+	(*pos)++;
 	return NULL;
 
 }
-- 
2.25.1



