Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8AB01A6419
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 10:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgDMIOB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 04:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:41666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbgDMIN7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 04:13:59 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6771C00860B
        for <stable@vger.kernel.org>; Mon, 13 Apr 2020 01:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=TeuaDVrLi4KBM05emhU233WXUFgTZo3Tvg/ab5fwH+0=; b=U76uF4ThDZsFSlRUGKqGQEZFm5
        IAdjLWsWKFGufkoxmi9NryrGtrNjoAphF/C+SyDb7f7MURmkU+0gr5A4zdkJDPjGzfmi1ICaxIkZ6
        XTJI60SdDbYwjzM8ciyC9VS8jjW/GxPeof6NbdL9WdMoxl77lmOHGzpoLmo4kN6VBfAd4AADtG/+P
        U9IwUvJfVn+Rc8ahStDpxvV9ZptMEnVpLP9t6iSRq2XviLxXPlL/Lb5lHPqpxsdnp2c4aPuEfqpRf
        fav/FOdddCVobBT4qCgNPtMOtnyP8NfDz64wnuzTebgSKKOWhHz68saoril+d9fz29nBwIwkyqXzn
        xDB/tSSA==;
Received: from [2601:647:4802:9070:c866:767e:2caa:28fe] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jNuE6-000313-CW; Mon, 13 Apr 2020 08:13:54 +0000
From:   Sagi Grimberg <sagi@grimberg.me>
To:     stable@vger.kernel.org
Subject: [PATCH stable 4.18+] nvme: Treat discovery subsystems as unique subsystems
Date:   Mon, 13 Apr 2020 01:13:49 -0700
Message-Id: <20200413081349.16278-1-sagi@grimberg.me>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit c26aa572027d438de9cc311aaebcbe972f698c24 ]

Current code matches subnqn and collapses all controllers to the
same subnqn to a single subsystem structure. This is good for
recognizing multiple controllers for the same subsystem. But with
the well-known discovery subnqn, the subsystems aren't truly the
same subsystem. As such, subsystem specific rules, such as no
overlap of controller id, do not apply. With today's behavior, the
check for overlap of controller id can fail, preventing the new
discovery controller from being created.

When searching for like subsystem nqn, exclude the discovery nqn
from matching. This will result in each discovery controller being
attached to a unique subsystem structure.

Signed-off-by: James Smart <jsmart2021@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/core.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index fad04282148d..0545eb97d838 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2374,6 +2374,17 @@ static struct nvme_subsystem *__nvme_find_get_subsystem(const char *subsysnqn)
 
 	lockdep_assert_held(&nvme_subsystems_lock);
 
+	/*
+	 * Fail matches for discovery subsystems. This results
+	 * in each discovery controller bound to a unique subsystem.
+	 * This avoids issues with validating controller values
+	 * that can only be true when there is a single unique subsystem.
+	 * There may be multiple and completely independent entities
+	 * that provide discovery controllers.
+	 */
+	if (!strcmp(subsysnqn, NVME_DISC_SUBSYS_NAME))
+		return NULL;
+
 	list_for_each_entry(subsys, &nvme_subsystems, entry) {
 		if (strcmp(subsys->subnqn, subsysnqn))
 			continue;
-- 
2.20.1

