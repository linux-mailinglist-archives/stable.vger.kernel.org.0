Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA4E427C50B
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgI2L3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729135AbgI2L3J (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:29:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41A9E221E8;
        Tue, 29 Sep 2020 11:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378613;
        bh=Aw4kfHxzkUH0lo6F2KmkpkhVf7og8us621qGC8fWFQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bxubWOjfOzT1xcvpftnOtsNKl4aKN2DD3cQAU7zuWoidKdhM4FRpW0/3EYyuH/dAe
         EOqhVYO+ej5BbAuSDu51YoJLIpgEOCmmtRiqmPyh+6/Pcd2BJ79TR9mx0cfjidPfG5
         Z1/8f4UMFUz8c3lwW03RK6Ru3rZHvOEAro4XQX3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/245] neigh_stat_seq_next() should increase position index
Date:   Tue, 29 Sep 2020 12:58:18 +0200
Message-Id: <20200929105949.289608113@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
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
index bf738ec68cb53..6e890f51b7d86 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2844,6 +2844,7 @@ static void *neigh_stat_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 		*pos = cpu+1;
 		return per_cpu_ptr(tbl->stats, cpu);
 	}
+	(*pos)++;
 	return NULL;
 }
 
-- 
2.25.1



