Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB68206167
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392155AbgFWUlB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389939AbgFWUlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:41:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D17920675;
        Tue, 23 Jun 2020 20:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944861;
        bh=M5b3VYofXKUdsZ3mPHAW68HmE9bw1kEkqwELp613G/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUlMW/8ZjrXyGHhAx+VwSZLAnK2skmmr0UDuwjyD2yXiDJ1hnBPiYtudz7ZYCIlNZ
         fKysQ7tIVDzD/smp6B3WwHCTY+zqahbzVtRYb1sLO0ANvfc7d2B6APzWjGGIKiiH3b
         MfJVLtBRRdXx185YJPsNCFuQbGITtM2aM5cEHX/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhihao Cheng <chengzhihao1@huawei.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/206] afs: Fix memory leak in afs_put_sysnames()
Date:   Tue, 23 Jun 2020 21:58:01 +0200
Message-Id: <20200623195324.522836049@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 2ca068be09bf8e285036603823696140026dcbe7 ]

Fix afs_put_sysnames() to actually free the specified afs_sysnames
object after its reference count has been decreased to zero and
its contents have been released.

Fixes: 6f8880d8e681557 ("afs: Implement @sys substitution handling")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index 9101f62707af2..e445c02dea3df 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -512,6 +512,7 @@ void afs_put_sysnames(struct afs_sysnames *sysnames)
 			if (sysnames->subs[i] != afs_init_sysname &&
 			    sysnames->subs[i] != sysnames->blank)
 				kfree(sysnames->subs[i]);
+		kfree(sysnames);
 	}
 }
 
-- 
2.25.1



