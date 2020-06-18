Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A2C1FE183
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733245AbgFRBzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:55:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:32894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731499AbgFRBZs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:25:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9632E221E8;
        Thu, 18 Jun 2020 01:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443547;
        bh=Eair0641usXtg1g7P/Wo/pv6a4IQbpLEhlZUStc4uHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDycjg5XoSabWm9GHX1aSMDsx+3Va5sNOW+gGx5I8lYKF6KLDxYPe/J6e8c/2BIqH
         JDzrC3EyjgeFqj+fhgezrRsWDJgeaW5/zk7OPDXeDDLeY4/g/2I7a4Kpm6MA8oKgIY
         VIRZ48ju66XxHKQ1MeznVCp+FPP+qaQNgoZ9TDLA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhihao Cheng <chengzhihao1@huawei.com>,
        David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-afs@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 163/172] afs: Fix memory leak in afs_put_sysnames()
Date:   Wed, 17 Jun 2020 21:22:09 -0400
Message-Id: <20200618012218.607130-163-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012218.607130-1-sashal@kernel.org>
References: <20200618012218.607130-1-sashal@kernel.org>
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
index 9101f62707af..e445c02dea3d 100644
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

