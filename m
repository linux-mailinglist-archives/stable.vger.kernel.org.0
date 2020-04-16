Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C98A1AC273
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895768AbgDPN22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895717AbgDPN2W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:28:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D65121BE5;
        Thu, 16 Apr 2020 13:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043700;
        bh=ZTGCCw01lPhTo/izv+JIZcVsDGvAQR9XfAGcQdEpLOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aotWsfpq3/HPtRJMWSpbr1Bgd0Y/6UwKPnjLsrojuEIRn79bN+KhuJSOksXfWb6c/
         Uin5fsBSxUndQYbu86sT/WMiDsq3ehbm4GWBJWWWmUcNjJll4tAQCS0z0ll0PPnux5
         F9vR3PLjS417YVdECoOVRQzOK6VCX4Pc3wSUR8fc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Smart <jsmart2021@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Max Gurtovoy <maxg@mellanox.com>
Subject: [PATCH 4.19 063/146] nvme: Treat discovery subsystems as unique subsystems
Date:   Thu, 16 Apr 2020 15:23:24 +0200
Message-Id: <20200416131251.520217772@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

commit c26aa572027d438de9cc311aaebcbe972f698c24 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/nvme/host/core.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2200,6 +2200,17 @@ static struct nvme_subsystem *__nvme_fin
 
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


