Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849BB1E2EAD
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390421AbgEZTbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390534AbgEZS7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1FA02086A;
        Tue, 26 May 2020 18:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519570;
        bh=vIFPGfnOooX503xJ1gdmHM1nbIJtBhMbHWlsuxlq6OY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CcNvqWGNSJQCuK/9tsN9SaRIq/zFhASmKFFHhKHGcbG0v+8OFOzjObrwTABfxFCfF
         lJOnc48C8x10eDmct3oUos+i2M+WcSqumXAcTTUaDBSSV38dh4/LPS8em4QvnhPof6
         TeWh7CFaYRujsa7JdjCyJC5kcfnw4uwtmz+siYe0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 55/64] libnvdimm/btt: Remove unnecessary code in btt_freelist_init
Date:   Tue, 26 May 2020 20:53:24 +0200
Message-Id: <20200526183930.920098416@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishal Verma <vishal.l.verma@intel.com>

[ Upstream commit 2f8c9011151337d0bc106693f272f9bddbccfab2 ]

We call btt_log_read() twice, once to get the 'old' log entry, and again
to get the 'new' entry. However, we have no use for the 'old' entry, so
remove it.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/btt.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 0c46ada027cf..e90ecb179622 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -447,9 +447,9 @@ static int btt_log_init(struct arena_info *arena)
 
 static int btt_freelist_init(struct arena_info *arena)
 {
-	int old, new, ret;
+	int new, ret;
 	u32 i, map_entry;
-	struct log_entry log_new, log_old;
+	struct log_entry log_new;
 
 	arena->freelist = kcalloc(arena->nfree, sizeof(struct free_entry),
 					GFP_KERNEL);
@@ -457,10 +457,6 @@ static int btt_freelist_init(struct arena_info *arena)
 		return -ENOMEM;
 
 	for (i = 0; i < arena->nfree; i++) {
-		old = btt_log_read(arena, i, &log_old, LOG_OLD_ENT);
-		if (old < 0)
-			return old;
-
 		new = btt_log_read(arena, i, &log_new, LOG_NEW_ENT);
 		if (new < 0)
 			return new;
-- 
2.25.1



