Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 540B71FE607
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgFRCa0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:30:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbgFRBPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:15:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02D9A221F6;
        Thu, 18 Jun 2020 01:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442952;
        bh=wSXH/t1nm9cYgnXHIJs3ya+RyoRsiYYIX2/TKeLDJgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H2Xa4GOGm8aVol+iRzuH6pyoI0M/NEfcxp/WD66rp/WE4kzaFM5KrKSzPXC5IfLBp
         gE4iMaG/rOxsCAo8yNxbOIX0X03YMpEmF54KLXeVaRUP4hS8qZkxl/Dfjv26Dn9bz9
         2g3HZ7R9hjRGSMWaAY8XWJdQ9QFP5FrFMWxz+28w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhihao Cheng <chengzhihao1@huawei.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 5.7 361/388] afs: Fix memory leak in afs_put_sysnames()
Date:   Wed, 17 Jun 2020 21:07:38 -0400
Message-Id: <20200618010805.600873-361-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 468e1713bce1..6f34c84a0fd0 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -563,6 +563,7 @@ void afs_put_sysnames(struct afs_sysnames *sysnames)
 			if (sysnames->subs[i] != afs_init_sysname &&
 			    sysnames->subs[i] != sysnames->blank)
 				kfree(sysnames->subs[i]);
+		kfree(sysnames);
 	}
 }
 
-- 
2.25.1

