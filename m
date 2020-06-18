Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2961FE7E6
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387898AbgFRCoP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:44:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbgFRBLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:11:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5C7021D7E;
        Thu, 18 Jun 2020 01:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442673;
        bh=TS51LkKgjmjEv2BFagb1w17wjUJM5ZYvOrdt2wSaGh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=js1/BdXIk8LUvZoxamm2vcStRezJWvpl+Njz8RXH5F9thpbYiDwNoBSBgxxK28w9a
         G+tU0JwlPN0yyizXIolEj14+MerDYQ72tpp6J/f11ro/f3z3NJbIZQDcUvuszz+4c/
         soc0M2g01t2OUwdicHuhWoT/gONe3M6W072rp6rc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 142/388] s390/qdio: tear down thinint indicator after early error
Date:   Wed, 17 Jun 2020 21:03:59 -0400
Message-Id: <20200618010805.600873-142-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 68a381746f20e5435206173e22d0a011ef78790e ]

qdio_establish() calls qdio_establish_thinint(), but later has an error
exit path that doesn't roll this call back. Fix it.

Fixes: 779e6e1c724d ("[S390] qdio: new qdio driver.")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/qdio_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index da5a11138020..80cc811bd2e0 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -1363,6 +1363,7 @@ int qdio_establish(struct ccw_device *cdev,
 	if (rc) {
 		DBF_ERROR("%4x est IO ERR", irq_ptr->schid.sch_no);
 		DBF_ERROR("rc:%4x", rc);
+		qdio_shutdown_thinint(irq_ptr);
 		qdio_shutdown_irq(irq_ptr);
 		mutex_unlock(&irq_ptr->setup_mutex);
 		return rc;
-- 
2.25.1

