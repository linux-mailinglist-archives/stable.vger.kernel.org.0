Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDECF360D77
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhDOPC6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235073AbhDOPAV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:00:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EFB261412;
        Thu, 15 Apr 2021 14:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498577;
        bh=ff4cqhax3E3hwB+ISw+nXEkNQW0+siOpxAPImNkUF6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8LXC8g7A9Umrm+dVpmcJR7V4EH48yt0ml564Son5qR5PGDr6Fy223+8cdyEuqvQA
         GhEyBcD9oRastnQcjSmagI3x3TUHWmKz/luoiDKGuKWvLnv+0L30pfNv+G8zRLkFQ0
         zmAyh2LwW7SUACQcsGGVa4oBAXQzR4MeTy/cqrCs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 10/18] idr test suite: Create anchor before launching throbber
Date:   Thu, 15 Apr 2021 16:48:03 +0200
Message-Id: <20210415144413.374056584@linuxfoundation.org>
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



