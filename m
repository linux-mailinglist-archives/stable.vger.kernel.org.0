Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E356927C9C9
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730177AbgI2MNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730124AbgI2Lha (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:37:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C29223B44;
        Tue, 29 Sep 2020 11:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379248;
        bh=ezujFYqmD86XxnJTFCEK4MfNsI9UP82mauqLmNamF5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNQR5prWvUmfhY9RSRHW0gjxjmA8JiMXmaUc8IZ3vzH0lj9khT4iV8botreO0vztR
         krWuNlo8JBxcpQK4aAPXj3LJ+5lq2+dHsWBzJ7dko19meiPEnudMp99pzxdGqnGh9C
         eOeMh/Zcm+Bhv8oYZqzwlUMT38E/0Le8JA0QHmjw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/388] rt_cpu_seq_next should increase position index
Date:   Tue, 29 Sep 2020 12:56:49 +0200
Message-Id: <20200929110014.257949964@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
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
index aa77f989ba817..7a5f64cf1fdd2 100644
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



