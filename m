Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C306E171EC0
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387726AbgB0OFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:05:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:41878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387721AbgB0OFO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:05:14 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F0FD21D7E;
        Thu, 27 Feb 2020 14:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812314;
        bh=mABAXKpoGeiMojiRINknGF4bDYTJblHbCObSYDzQYyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlzWoWjFHflb65ZOjA3NV8Pw+LP9KNmzVhBgYL3J8YPi+Fe/dXI3p0Dh1J3BmDd5W
         G4HKj4MJJXXScTv7Bw7va4tZ/ZYr5/noZ6+bXp1pphSkH9+eKqxOG0HBez8ORl7VN3
         oRI8fs4msK9rRvADkh5mGLf2jHruWPlulS2if898=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miles Chen <miles.chen@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 60/97] lib/stackdepot: Fix outdated comments
Date:   Thu, 27 Feb 2020 14:37:08 +0100
Message-Id: <20200227132224.337663006@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132214.553656188@linuxfoundation.org>
References: <20200227132214.553656188@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miles Chen <miles.chen@mediatek.com>

[ Upstream commit ee050dc83bc326ad5ef8ee93bca344819371e7a5 ]

Replace "depot_save_stack" with "stack_depot_save" in code comments because
depot_save_stack() was replaced in commit c0cfc337264c ("lib/stackdepot:
Provide functions which operate on plain storage arrays") and removed in
commit 56d8f079c51a ("lib/stackdepot: Remove obsolete functions")

Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190815113246.18478-1-miles.chen@mediatek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/stackdepot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index e513459a5601a..c5e06c43228f9 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -96,7 +96,7 @@ static bool init_stack_slab(void **prealloc)
 		stack_slabs[depot_index + 1] = *prealloc;
 		/*
 		 * This smp_store_release pairs with smp_load_acquire() from
-		 * |next_slab_inited| above and in depot_save_stack().
+		 * |next_slab_inited| above and in stack_depot_save().
 		 */
 		smp_store_release(&next_slab_inited, 1);
 	}
@@ -123,7 +123,7 @@ static struct stack_record *depot_alloc_stack(unsigned long *entries, int size,
 		depot_offset = 0;
 		/*
 		 * smp_store_release() here pairs with smp_load_acquire() from
-		 * |next_slab_inited| in depot_save_stack() and
+		 * |next_slab_inited| in stack_depot_save() and
 		 * init_stack_slab().
 		 */
 		if (depot_index + 1 < STACK_ALLOC_MAX_SLABS)
-- 
2.20.1



