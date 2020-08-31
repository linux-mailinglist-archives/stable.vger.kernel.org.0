Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D81C257D33
	for <lists+stable@lfdr.de>; Mon, 31 Aug 2020 17:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgHaPfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 11:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728824AbgHaPbP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 Aug 2020 11:31:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF751214DB;
        Mon, 31 Aug 2020 15:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598887875;
        bh=RazqLH9uDWL+hfSipxTzeDHvS/5XJ6j9dFUUdoFDnB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tLW7qhc48pUSBiCRjo0ai3t8h9KmQAvxX5OtRSts49gO2zQkRSP1vrFv+lJV+SDf2
         zRfM8hTIR77l6SA4MjBYC64tUJcIYepqtskVBvBDAwejtmvqWKUBiSFOx2n56pC/1M
         3ZkMH+E8HfSqUdYW3BCD41g+GXj8fq8QfW68RsAk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Simon Leiner <simon@leiner.me>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>, xen-devel@lists.xenproject.org
Subject: [PATCH AUTOSEL 5.4 22/23] xen/xenbus: Fix granting of vmalloc'd memory
Date:   Mon, 31 Aug 2020 11:30:38 -0400
Message-Id: <20200831153039.1024302-22-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831153039.1024302-1-sashal@kernel.org>
References: <20200831153039.1024302-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Leiner <simon@leiner.me>

[ Upstream commit d742db70033c745e410523e00522ee0cfe2aa416 ]

On some architectures (like ARM), virt_to_gfn cannot be used for
vmalloc'd memory because of its reliance on virt_to_phys. This patch
introduces a check for vmalloc'd addresses and obtains the PFN using
vmalloc_to_pfn in that case.

Signed-off-by: Simon Leiner <simon@leiner.me>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Link: https://lore.kernel.org/r/20200825093153.35500-1-simon@leiner.me
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/xenbus/xenbus_client.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index a38292ef79f6d..f38bdaea0ef11 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -363,8 +363,14 @@ int xenbus_grant_ring(struct xenbus_device *dev, void *vaddr,
 	int i, j;
 
 	for (i = 0; i < nr_pages; i++) {
-		err = gnttab_grant_foreign_access(dev->otherend_id,
-						  virt_to_gfn(vaddr), 0);
+		unsigned long gfn;
+
+		if (is_vmalloc_addr(vaddr))
+			gfn = pfn_to_gfn(vmalloc_to_pfn(vaddr));
+		else
+			gfn = virt_to_gfn(vaddr);
+
+		err = gnttab_grant_foreign_access(dev->otherend_id, gfn, 0);
 		if (err < 0) {
 			xenbus_dev_fatal(dev, err,
 					 "granting access to ring page");
-- 
2.25.1

