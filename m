Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28ABC360D8A
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbhDOPD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:03:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235228AbhDOPAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF93F613C0;
        Thu, 15 Apr 2021 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498600;
        bh=dhYxorx/1pSdpYb4mUa+fX1VX6NdweZAjcddJC4Olo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CO2DTXonUVANdOFgW92h7TAKFL3EzwTaLN4P2DOf6qySRFwlUVz1eDvaNT0yLqerl
         527RQtuIZ+KGAitZl36TSqtttpem7BtRQ0jimuJ6+sNKxw+Vmltqjuv9S5bhL/Ulae
         +G38P1Hl9wD0V/RAfFh9iZyAmjwSZw4n25xROaw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chris von Recklinghausen <crecklin@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/18] idr test suite: Take RCU read lock in idr_find_test_1
Date:   Thu, 15 Apr 2021 16:48:02 +0200
Message-Id: <20210415144413.344891808@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.055232956@linuxfoundation.org>
References: <20210415144413.055232956@linuxfoundation.org>
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



