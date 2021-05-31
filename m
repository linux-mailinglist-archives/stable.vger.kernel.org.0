Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A2B13962D6
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234246AbhEaPBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:01:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:51032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234372AbhEaO7V (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:59:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFC5F61CCA;
        Mon, 31 May 2021 14:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469668;
        bh=YN6Fa8RGRjU2S+rc9v9z1tqAVO9HBMiiCFEcAkIYEvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVXZAHQGhFbb0Q8NYyJb4hwtb8VPyyYETfZIOcZxpyG9XPL6VPeQLyVA/e+RyB09R
         GlOUDm6eIjCIDf7jGjw8Kt2BvKHFvslQ6hJoFjetgCTjDRFBezwam/s5YOkhJxTu5B
         mwqcXf3aaq9dsryF/DCPtp0EtngEjMXPYJ+JtnLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 250/296] net/smc: remove device from smcd_dev_list after failed device_add()
Date:   Mon, 31 May 2021 15:15:05 +0200
Message-Id: <20210531130712.173086965@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 444d7be9532dcfda8e0385226c862fd7e986f607 ]

If the device_add() for a smcd_dev fails, there's no cleanup step that
rolls back the earlier list_add(). The device subsequently gets freed,
and we end up with a corrupted list.

Add some error handling that removes the device from the list.

Fixes: c6ba7c9ba43d ("net/smc: add base infrastructure for SMC-D and ISM")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/smc_ism.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/smc/smc_ism.c b/net/smc/smc_ism.c
index 94b31f2551bc..967712ba52a0 100644
--- a/net/smc/smc_ism.c
+++ b/net/smc/smc_ism.c
@@ -429,6 +429,8 @@ EXPORT_SYMBOL_GPL(smcd_alloc_dev);
 
 int smcd_register_dev(struct smcd_dev *smcd)
 {
+	int rc;
+
 	mutex_lock(&smcd_dev_list.mutex);
 	if (list_empty(&smcd_dev_list.list)) {
 		u8 *system_eid = NULL;
@@ -448,7 +450,14 @@ int smcd_register_dev(struct smcd_dev *smcd)
 			    dev_name(&smcd->dev), smcd->pnetid,
 			    smcd->pnetid_by_user ? " (user defined)" : "");
 
-	return device_add(&smcd->dev);
+	rc = device_add(&smcd->dev);
+	if (rc) {
+		mutex_lock(&smcd_dev_list.mutex);
+		list_del(&smcd->list);
+		mutex_unlock(&smcd_dev_list.mutex);
+	}
+
+	return rc;
 }
 EXPORT_SYMBOL_GPL(smcd_register_dev);
 
-- 
2.30.2



