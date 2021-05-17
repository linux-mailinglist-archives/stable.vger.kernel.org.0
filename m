Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63323837B8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244427AbhEQPqm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:46:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243746AbhEQPoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:44:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 056A36135D;
        Mon, 17 May 2021 14:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262584;
        bh=zvP5z3xHUUP8GpW6ufPFOYxcKv8Sv1SSyqT4M5368b8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npm/zE1wONcONbeAjSV9wQlNQnjiCIMlcliFskEDxgOwrNd5BPspXdCtAcUs5KRfh
         jtE74VAE/Esegq7+U/IWp79vAeHlaYQ3dVOcoyKgsirI3r6sKiHkjhDpHalfSr2qPP
         aM0IoNqexBsZ2ieLZuKURMzXbQc/mAE43KDb7W6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/289] xen/unpopulated-alloc: consolidate pgmap manipulation
Date:   Mon, 17 May 2021 16:02:24 +0200
Message-Id: <20210517140312.516794815@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 3a250629d7325f27b278dad1aaf44eab00090e76 ]

Cleanup fill_list() to keep all the pgmap manipulations in a single
location of the function.  Update the exit unwind path accordingly.

Link: http://lore.kernel.org/r/6186fa28-d123-12db-6171-a75cb6e615a5@oracle.com
Link: https://lkml.kernel.org/r/160272253442.3136502.16683842453317773487.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/unpopulated-alloc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/xen/unpopulated-alloc.c b/drivers/xen/unpopulated-alloc.c
index 7762c1bb23cb..e64e6befc63b 100644
--- a/drivers/xen/unpopulated-alloc.c
+++ b/drivers/xen/unpopulated-alloc.c
@@ -27,11 +27,6 @@ static int fill_list(unsigned int nr_pages)
 	if (!res)
 		return -ENOMEM;
 
-	pgmap = kzalloc(sizeof(*pgmap), GFP_KERNEL);
-	if (!pgmap)
-		goto err_pgmap;
-
-	pgmap->type = MEMORY_DEVICE_GENERIC;
 	res->name = "Xen scratch";
 	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 
@@ -43,6 +38,11 @@ static int fill_list(unsigned int nr_pages)
 		goto err_resource;
 	}
 
+	pgmap = kzalloc(sizeof(*pgmap), GFP_KERNEL);
+	if (!pgmap)
+		goto err_pgmap;
+
+	pgmap->type = MEMORY_DEVICE_GENERIC;
 	pgmap->range = (struct range) {
 		.start = res->start,
 		.end = res->end,
@@ -92,10 +92,10 @@ static int fill_list(unsigned int nr_pages)
 	return 0;
 
 err_memremap:
-	release_resource(res);
-err_resource:
 	kfree(pgmap);
 err_pgmap:
+	release_resource(res);
+err_resource:
 	kfree(res);
 	return ret;
 }
-- 
2.30.2



