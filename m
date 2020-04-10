Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 657A31A4098
	for <lists+stable@lfdr.de>; Fri, 10 Apr 2020 05:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgDJDtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 23:49:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728578AbgDJDtf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Apr 2020 23:49:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5948520B1F;
        Fri, 10 Apr 2020 03:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586490575;
        bh=qmbLUSU/w7JaoSjE/dGj7Mwn2TrAusEL8vM6d4qoZQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I8WzbQTdH3RTM74kmjAR47YJFM1rZwil1zrDTfkahO8OLlaTyn0bhpKlL1HCTNcRN
         sJPaxOKKZ+H6ywNp6Pwqj8jsY4rk1YA/QVgWhaRPYKgHz3J8yQRi6GIHwJIA9lygU8
         2Iv96dxQ/1DfBgARAe42Jf++lU8Xa9J3xUs1ee3o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Logan Gunthorpe <logang@deltatee.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/46] PCI/switchtec: Fix init_completion race condition with poll_wait()
Date:   Thu,  9 Apr 2020 23:48:44 -0400
Message-Id: <20200410034909.8922-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200410034909.8922-1-sashal@kernel.org>
References: <20200410034909.8922-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit efbdc769601f4d50018bf7ca50fc9f7c67392ece ]

The call to init_completion() in mrpc_queue_cmd() can theoretically
race with the call to poll_wait() in switchtec_dev_poll().

  poll()			write()
    switchtec_dev_poll()   	  switchtec_dev_write()
      poll_wait(&s->comp.wait);      mrpc_queue_cmd()
			               init_completion(&s->comp)
				         init_waitqueue_head(&s->comp.wait)

To my knowledge, no one has hit this bug.

Fix this by using reinit_completion() instead of init_completion() in
mrpc_queue_cmd().

Fixes: 080b47def5e5 ("MicroSemi Switchtec management interface driver")

Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://lkml.kernel.org/r/20200313183608.2646-1-logang@deltatee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/switch/switchtec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index cc43c855452f7..2c9c3061894b2 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -175,7 +175,7 @@ static int mrpc_queue_cmd(struct switchtec_user *stuser)
 	kref_get(&stuser->kref);
 	stuser->read_len = sizeof(stuser->data);
 	stuser_set_state(stuser, MRPC_QUEUED);
-	init_completion(&stuser->comp);
+	reinit_completion(&stuser->comp);
 	list_add_tail(&stuser->list, &stdev->mrpc_queue);
 
 	mrpc_cmd_submit(stdev);
-- 
2.20.1

