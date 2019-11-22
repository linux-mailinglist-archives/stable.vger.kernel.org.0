Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 114A7106B94
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfKVKpm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:45:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:52264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729521AbfKVKpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:45:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45D6C20718;
        Fri, 22 Nov 2019 10:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419541;
        bh=1cb9MWqtHS9XKZYwGFko2caVYbppdnjIrOxi/cdSZbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlT73KSCUU0uQ+DVZKeUGHMHdAL1++rZ17VLt5agtA+RrvkWedBmosFBu/x4n+nK3
         tCAAPpiZX3nm5/erbY7zPUWtDHfeBhj7RjfibUrGS62HuFr98o7C3/arv9teQ2MNtd
         qadOrjxmzkqnF/L6gS0uDwbp/Sa6vKAcfxvqdseo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhong jiang <zhongjiang@huawei.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 4.9 146/222] memfd: Use radix_tree_deref_slot_protected to avoid the warning.
Date:   Fri, 22 Nov 2019 11:28:06 +0100
Message-Id: <20191122100913.339562558@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhong jiang <zhongjiang@huawei.com>

The commit 3ce6b467b9b2 ("memfd: Fix locking when tagging pins")
introduces the following warning messages.

*WARNING: suspicious RCU usage in memfd_wait_for_pins*

It is because we still use radix_tree_deref_slot without read_rcu_lock.
We should use radix_tree_deref_slot_protected instead in the case.

Cc: stable@vger.kernel.org
Fixes: 3ce6b467b9b2 ("memfd: Fix locking when tagging pins")
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2464,7 +2464,7 @@ static void shmem_tag_pins(struct addres
 
 	spin_lock_irq(&mapping->tree_lock);
 	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
-		page = radix_tree_deref_slot(slot);
+		page = radix_tree_deref_slot_protected(slot, &mapping->tree_lock);
 		if (!page || radix_tree_exception(page)) {
 			if (radix_tree_deref_retry(page)) {
 				slot = radix_tree_iter_retry(&iter);


