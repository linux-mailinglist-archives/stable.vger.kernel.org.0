Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0964147F93
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbgAXLD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:03:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729742AbgAXLDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:03:07 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE6FF2077C;
        Fri, 24 Jan 2020 11:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863786;
        bh=O0x8TH3TRSsWugHDFjUjzQpetWW9RhiLHPU8x6whfbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AI75rv+LbTYJYxKj5yqWLdSH4q6x+/nozpfiTBSNZg6SFAGTerJyJ2yR7E/OdjKBp
         6YufGFNdw5K6l174dsu/XY5k6MPBBfN7fa7uL6AnLVR93nE54gQRYEEsxCX3BgIMj/
         sBdS5tvcySQ8Cyy3z5eyXRy3lAY/a4y3pwaNq9LE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Nishanth Menon <nm@ti.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 080/639] mailbox: ti-msgmgr: Off by one in ti_msgmgr_of_xlate()
Date:   Fri, 24 Jan 2020 10:24:10 +0100
Message-Id: <20200124093057.408055662@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5bceafbf66993..01e9e462512b7 100644
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



