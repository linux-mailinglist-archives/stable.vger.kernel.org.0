Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69B4328471
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhCAQfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:35:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhCAQ3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:29:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A574264F53;
        Mon,  1 Mar 2021 16:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615834;
        bh=fSi0IQR8VkifieCtuCA1OdSgP1hC6blVO0eHirRxd9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f5IPKmT/jM8KVwZAtQNRvOWZY8KKM6N89IkZxuJKrZtU1OfM+8ZrwxXsjaYepYnXT
         uI98CATI+fm7Am1kWaBQBG59czFtAVApYir53Y0K3h2/bGVnmRbTQKFBOLZI0ZdKM6
         iyaUfA8iDRnBUrrvb/46yll+qdaqBN0bh+8P9CvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vishnu Dasa <vdasa@vmware.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 077/134] VMCI: Use set_page_dirty_lock() when unregistering guest memory
Date:   Mon,  1 Mar 2021 17:12:58 +0100
Message-Id: <20210301161017.359165240@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jorgen Hansen <jhansen@vmware.com>

[ Upstream commit 5a16c535409f8dcb7568e20737309e3027ae3e49 ]

When the VMCI host support releases guest memory in the case where
the VM was killed, the pinned guest pages aren't locked. Use
set_page_dirty_lock() instead of set_page_dirty().

Testing done: Killed VM while having an active VMCI based vSocket
connection and observed warning from ext4. With this fix, no
warning was observed. Ran various vSocket tests without issues.

Fixes: 06164d2b72aa ("VMCI: queue pairs implementation.")
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
Signed-off-by: Jorgen Hansen <jhansen@vmware.com>
Link: https://lore.kernel.org/r/1611160360-30299-1-git-send-email-jhansen@vmware.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_vmci/vmci_queue_pair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index 6ac3c59c9ae78..7c7ed3f8441ab 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -732,7 +732,7 @@ static void qp_release_pages(struct page **pages,
 
 	for (i = 0; i < num_pages; i++) {
 		if (dirty)
-			set_page_dirty(pages[i]);
+			set_page_dirty_lock(pages[i]);
 
 		put_page(pages[i]);
 		pages[i] = NULL;
-- 
2.27.0



