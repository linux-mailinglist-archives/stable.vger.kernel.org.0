Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92B16127E95
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfLTOr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:47:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727861AbfLTOr6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:47:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39A3524680;
        Fri, 20 Dec 2019 14:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576853278;
        bh=Tbquh1Fj1o2WG2c/z313x7NCjA3H4GBJz8gcqT1tAcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vxwfSws05OI5Be+aGh0cEVrycj4alyc445GgDtnqRgHnLv4F58JI1aD8zV24ETQxK
         zmfuJ9YSi0+9nw8jNlS029d4OAZKcZyzPK2EHbDsDN2Gk8iclreTOqDF5ApjAA18p2
         g7GpBMMZQTy03v95P+kSqY49MRo9DXVGZiK9G1H4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Nicholas Tsirakis <niko.tsirakis@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 4.4 11/11] xen/balloon: fix ballooned page accounting without hotplug enabled
Date:   Fri, 20 Dec 2019 09:47:43 -0500
Message-Id: <20191220144744.10565-11-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220144744.10565-1-sashal@kernel.org>
References: <20191220144744.10565-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

[ Upstream commit c673ec61ade89bf2f417960f986bc25671762efb ]

When CONFIG_XEN_BALLOON_MEMORY_HOTPLUG is not defined
reserve_additional_memory() will set balloon_stats.target_pages to a
wrong value in case there are still some ballooned pages allocated via
alloc_xenballooned_pages().

This will result in balloon_process() no longer be triggered when
ballooned pages are freed in batches.

Reported-by: Nicholas Tsirakis <niko.tsirakis@gmail.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/balloon.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index cfab1d24e4bcc..1c789056e7e84 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -392,7 +392,8 @@ static struct notifier_block xen_memory_nb = {
 #else
 static enum bp_state reserve_additional_memory(void)
 {
-	balloon_stats.target_pages = balloon_stats.current_pages;
+	balloon_stats.target_pages = balloon_stats.current_pages +
+				     balloon_stats.target_unpopulated;
 	return BP_ECANCELED;
 }
 #endif /* CONFIG_XEN_BALLOON_MEMORY_HOTPLUG */
-- 
2.20.1

