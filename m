Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70234360DA1
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 17:05:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbhDOPEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 11:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235390AbhDOPBH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 11:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12F98613BA;
        Thu, 15 Apr 2021 14:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498639;
        bh=ff4cqhax3E3hwB+ISw+nXEkNQW0+siOpxAPImNkUF6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9o12ohK0CocBsYG1HWx1u9hU2HbyWKKKc/lhjmytGSneQId1S7W8pN16fJ3Y/flL
         ZvS6n9OUeG8Tzu5mMeSvnx3/njrRVQMv2/DWurxdCezibVro7r3CqDo339zD50EkTh
         nthpWhgM8Fzk64SbXtwQhVgum+b/yYxIPVMx8Iwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 16/25] idr test suite: Create anchor before launching throbber
Date:   Thu, 15 Apr 2021 16:48:10 +0200
Message-Id: <20210415144413.670873097@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.165663182@linuxfoundation.org>
References: <20210415144413.165663182@linuxfoundation.org>
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



