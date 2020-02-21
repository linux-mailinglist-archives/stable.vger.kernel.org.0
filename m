Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D2616722F
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731145AbgBUIBB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:01:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731142AbgBUIBA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:01:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8E2D2073A;
        Fri, 21 Feb 2020 08:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272059;
        bh=mKJXdC1spszpUhOmwpzsp8VjgJ+xnq6JmhBX2kjg/Cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UvVnbCCKKWA+54eRtau/wQAK7ot3CI/L6cT9e16Yk2dMOqX0XsBlfxLQ8Cc3OYdRl
         YwdEGCtss+BFLBQ1mF+VDt5vPnY8/oJC3QzhcLMrpg44Peh5Lw7ERCMfao/zEcuz6j
         xGmV3Z1xKalgZyvTrRyyz6mv4XxguE3BjUw3SLEc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 353/399] bpf: map_seq_next should always increase position index
Date:   Fri, 21 Feb 2020 08:41:18 +0100
Message-Id: <20200221072435.276879379@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit 90435a7891a2259b0f74c5a1bc5600d0d64cba8f ]

If seq_file .next fuction does not change position index,
read after some lseek can generate an unexpected output.

See also: https://bugzilla.kernel.org/show_bug.cgi?id=206283

v1 -> v2: removed missed increment in end of function

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/eca84fdd-c374-a154-d874-6c7b55fc3bc4@virtuozzo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/inode.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index ecf42bec38c00..6f22e0e74ef24 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -196,6 +196,7 @@ static void *map_seq_next(struct seq_file *m, void *v, loff_t *pos)
 	void *key = map_iter(m)->key;
 	void *prev_key;
 
+	(*pos)++;
 	if (map_iter(m)->done)
 		return NULL;
 
@@ -208,8 +209,6 @@ static void *map_seq_next(struct seq_file *m, void *v, loff_t *pos)
 		map_iter(m)->done = true;
 		return NULL;
 	}
-
-	++(*pos);
 	return key;
 }
 
-- 
2.20.1



