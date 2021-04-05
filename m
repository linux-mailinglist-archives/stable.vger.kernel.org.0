Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C22E6354466
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 18:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242210AbhDEQFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 12:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242162AbhDEQE6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 12:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F063B613F1;
        Mon,  5 Apr 2021 16:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617638692;
        bh=V/EI5/0USRO1S1Novl45CCqwydSlfLph0clCRaXR6B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oAg5ADoPf9I94PTV9oaInyaLknczBVC+Mpi21SdQcps16gY/aHL+vicgWvjk5gafZ
         9BQYsg3nh+OkMeIXOaHnOtdd1K2BnoZbx6poeJ7W2Jk8yYLRUELtIglvWzyDLmPbBb
         GAc5K1a+kWcnfDSgNwj9yta6FDanoOdKBIr3LKjcIQ3a97VENdQ4mDdYvCa4bM9cJG
         9WNg6Pi6L1uO8YPNl3FGLBjcU9DmY5Ucg7H54kPm77FAUbhjbDDC8HbYIWtjvW3dZJ
         +uXZVaV6H64SczCPMAZzJ/QWoWFn+nDrA5cApZ+BtOb+BQh6wmnoEQ2dV57fVdTIGs
         wazV+XrfdJOrg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 17/22] idr test suite: Create anchor before launching throbber
Date:   Mon,  5 Apr 2021 12:04:26 -0400
Message-Id: <20210405160432.268374-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210405160432.268374-1-sashal@kernel.org>
References: <20210405160432.268374-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

[ Upstream commit 094ffbd1d8eaa27ed426feb8530cb1456348b018 ]

The throbber could race with creation of the anchor entry and cause the
IDR to have zero entries in it, which would cause the test to fail.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/radix-tree/idr-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 4a9b451b7ba0..6ce7460f3c7a 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -301,11 +301,11 @@ void idr_find_test_1(int anchor_id, int throbber_id)
 	pthread_t throbber;
 	time_t start = time(NULL);
 
-	pthread_create(&throbber, NULL, idr_throbber, &throbber_id);
-
 	BUG_ON(idr_alloc(&find_idr, xa_mk_value(anchor_id), anchor_id,
 				anchor_id + 1, GFP_KERNEL) != anchor_id);
 
+	pthread_create(&throbber, NULL, idr_throbber, &throbber_id);
+
 	rcu_read_lock();
 	do {
 		int id = 0;
-- 
2.30.2

