Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27D82127DB2
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 15:38:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfLTOfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 09:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:39722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728387AbfLTOfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Dec 2019 09:35:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A42E124684;
        Fri, 20 Dec 2019 14:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576852516;
        bh=0HuyhNq1O9Gim5LLI5/7VvT3lzV6D6Lo2ykpaANOOTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wW7cgZmriKsdJJD92QBlUSCHX4lkVW+dR3CQC8p+3T1v1hYq2SIDtV4LH2eFk7ydy
         nKvOkD+hMFcT2Lp8H5vI5vh0JOjHXgFwCQIytjleayQrht4TE47A48gKZ64pUB0FzH
         60/CBAFVdtiFmlGXvkHiArhtgDTJNw3yjinE/FGs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Nicholas Tsirakis <niko.tsirakis@gmail.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 4.19 33/34] xen/balloon: fix ballooned page accounting without hotplug enabled
Date:   Fri, 20 Dec 2019 09:34:32 -0500
Message-Id: <20191220143433.9922-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191220143433.9922-1-sashal@kernel.org>
References: <20191220143433.9922-1-sashal@kernel.org>
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
index 747a15acbce37..6fa7209f24f43 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -395,7 +395,8 @@ static struct notifier_block xen_memory_nb = {
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

