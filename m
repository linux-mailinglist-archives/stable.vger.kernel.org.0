Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5366F13F807
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387524AbgAPTO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:14:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:42780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733241AbgAPQ42 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 428EB20730;
        Thu, 16 Jan 2020 16:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193788;
        bh=EVK8+bMUW7+5NJwclqnG4oQpje6rvaXknNBN5JRwWNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abUxfRduBk7SB4/x3lNPU/NxN2ukO7IUtqZKd1WpQgMw1oxCXzKq6lzYa41rstK/y
         bWmCsaXBf2Qi3fGgxBaGjlExudHWlyUrj3+5NQk+DH7UqHvYVybFbYgY3CZ6jjBaAY
         xyA1AOKuLbCGolt3OlWJD3Hr8/0ZISYxdvzfHtWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Nishanth Menon <nm@ti.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 063/671] mailbox: ti-msgmgr: Off by one in ti_msgmgr_of_xlate()
Date:   Thu, 16 Jan 2020 11:44:54 -0500
Message-Id: <20200116165502.8838-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 78f3ff524fca63e7d2a57149a34ade23d2c12798 ]

The > comparison should be >= or we access one element beyond the end
of the array.

(The inst->qinsts[] array is allocated in the ti_msgmgr_probe() function
and it has ->num_valid_queues elements.)

Fixes: a2b79838b891 ("mailbox: ti-msgmgr: Add support for Secure Proxy")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/ti-msgmgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/ti-msgmgr.c b/drivers/mailbox/ti-msgmgr.c
index 5bceafbf6699..01e9e462512b 100644
--- a/drivers/mailbox/ti-msgmgr.c
+++ b/drivers/mailbox/ti-msgmgr.c
@@ -547,7 +547,7 @@ static struct mbox_chan *ti_msgmgr_of_xlate(struct mbox_controller *mbox,
 	}
 
 	if (d->is_sproxy) {
-		if (req_pid > d->num_valid_queues)
+		if (req_pid >= d->num_valid_queues)
 			goto err;
 		qinst = &inst->qinsts[req_pid];
 		return qinst->chan;
-- 
2.20.1

