Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28144360DCE
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhDOPGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:49076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234156AbhDOPDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:03:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0B6C6142F;
        Thu, 15 Apr 2021 14:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498702;
        bh=dhYxorx/1pSdpYb4mUa+fX1VX6NdweZAjcddJC4Olo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OlS/p45ZoanpzOZBTDl3OOawJzqZppcWjxw2JLvAr9dObcgpowYrvXH4QbEMEOOyS
         GQZ7x7yem9f/8q84M0Jx7SohnufterwR6MUfY1KmrByTodDFXtNsOdlkWHhI0ar94T
         Bc/BfIy8GjVP3rh1mFaPVsBAYjNSZLgvPklgIOwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris von Recklinghausen <crecklin@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 15/23] idr test suite: Take RCU read lock in idr_find_test_1
Date:   Thu, 15 Apr 2021 16:48:22 +0200
Message-Id: <20210415144413.626848414@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.146131392@linuxfoundation.org>
References: <20210415144413.146131392@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 703586410da69eb40062e64d413ca33bd735917a ]

When run on a single CPU, this test would frequently access already-freed
memory.  Due to timing, this bug never showed up on multi-CPU tests.

Reported-by: Chris von Recklinghausen <crecklin@redhat.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/radix-tree/idr-test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 44ceff95a9b3..4a9b451b7ba0 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -306,11 +306,15 @@ void idr_find_test_1(int anchor_id, int throbber_id)
 	BUG_ON(idr_alloc(&find_idr, xa_mk_value(anchor_id), anchor_id,
 				anchor_id + 1, GFP_KERNEL) != anchor_id);
 
+	rcu_read_lock();
 	do {
 		int id = 0;
 		void *entry = idr_get_next(&find_idr, &id);
+		rcu_read_unlock();
 		BUG_ON(entry != xa_mk_value(id));
+		rcu_read_lock();
 	} while (time(NULL) < start + 11);
+	rcu_read_unlock();
 
 	pthread_join(throbber, NULL);
 
-- 
2.30.2



