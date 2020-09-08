Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E88B261440
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 18:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbgIHQLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 12:11:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731420AbgIHQK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:10:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A7C1247D9;
        Tue,  8 Sep 2020 15:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579751;
        bh=RazqLH9uDWL+hfSipxTzeDHvS/5XJ6j9dFUUdoFDnB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Je56071eBScf76zl4Z3elK4MG5rz0gBw52sL6bFdYZQt9lB4lFsg07+1GrA8yzqn7
         1Hcot/vbmbQ9/vR+7wwdLqzONzq7MaWu0cy4Ms8s7kuvBkdRsFBW/V6Eu05yGVmDiF
         B04qbk5WtVen8DIoy6jcUTlVOm0xZ1Pn01EKXDUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Leiner <simon@leiner.me>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/129] xen/xenbus: Fix granting of vmallocd memory
Date:   Tue,  8 Sep 2020 17:24:21 +0200
Message-Id: <20200908152230.714475270@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152229.689878733@linuxfoundation.org>
References: <20200908152229.689878733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



