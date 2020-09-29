Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAFE27C476
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbgI2LOP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:14:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729186AbgI2LOO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:14:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B71C21D92;
        Tue, 29 Sep 2020 11:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378048;
        bh=tRfPMEK6EgPgwCmyDz52kwhFQzirjlhRXhN8bUwPkic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KjYyTI1ZwvQs+kZb57hcSuRAFKN1P06B6wUl3EVMwoglfUsiS+bkEgFakCu1GlRzD
         o2PtoPjtNCihSOP/o2++bB4W7+94aQu5MPD4sqEppMDHeWMq9uEVrqBeZw+C4GBzpQ
         vP3ZjcUHwTSEOnSdGg5Yx2Kcw2UIyjbCfx+cOFIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 043/166] neigh_stat_seq_next() should increase position index
Date:   Tue, 29 Sep 2020 12:59:15 +0200
Message-Id: <20200929105937.351930742@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 1e3f9f073c47bee7c23e77316b07bc12338c5bba ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/neighbour.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 567e431813e59..20f6c634ad68a 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2836,6 +2836,7 @@ static void *neigh_stat_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		*pos = cpu+1;
 		return per_cpu_ptr(tbl->stats, cpu);
 	}
+	(*pos)++;
 	return NULL;
 }
 
-- 
2.25.1



