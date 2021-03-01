Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17286328F6D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:52:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241857AbhCATvl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:51:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:54202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232032AbhCATlu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:41:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 169FB65160;
        Mon,  1 Mar 2021 17:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618381;
        bh=j63jNsA8W4gWydGWpODFJVIhG+YXyml+DhvLBEl+VlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZSOnHRyIU8IA4qW+6Ka6tiyzt826Yb3nnDhREL3Ir0TARxT7LwcXcW5oUmtFVAjR+
         bbmtp6jANMF0PbVIcdBDv3syhCanxaWtFP+gfmWYj5K0YZPxLfpF8DWjor2NRREdmZ
         4eAmBs0q6T1gjUQ9IdZjZrXbDx6ECY7F/otWPKg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <stefan.wahren@i2se.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Phil Elwell <phil@raspberrypi.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/663] staging: vchiq: Fix bulk userdata handling
Date:   Mon,  1 Mar 2021 17:04:45 +0100
Message-Id: <20210301161143.624748939@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phil Elwell <phil@raspberrypi.com>

[ Upstream commit 96ae327678eceabf455b11a88ba14ad540d4b046 ]

The addition of the local 'userdata' pointer to
vchiq_irq_queue_bulk_tx_rx omitted the case where neither BLOCKING nor
WAITING modes are used, in which case the value provided by the
caller is not returned to them as expected, but instead it is replaced
with a NULL. This lack of a suitable context may cause the application
to crash or otherwise malfunction.

Fixes: 4184da4f316a ("staging: vchiq: fix __user annotations")
Tested-by: Stefan Wahren <stefan.wahren@i2se.com>
Acked-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Link: https://lore.kernel.org/r/20210105162030.1415213-2-phil@raspberrypi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 01125d9f991bb..5bc9b394212b8 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -953,7 +953,7 @@ static int vchiq_irq_queue_bulk_tx_rx(struct vchiq_instance *instance,
 	struct vchiq_service *service;
 	struct bulk_waiter_node *waiter = NULL;
 	bool found = false;
-	void *userdata = NULL;
+	void *userdata;
 	int status = 0;
 	int ret;
 
@@ -992,6 +992,8 @@ static int vchiq_irq_queue_bulk_tx_rx(struct vchiq_instance *instance,
 			"found bulk_waiter %pK for pid %d", waiter,
 			current->pid);
 		userdata = &waiter->bulk_waiter;
+	} else {
+		userdata = args->userdata;
 	}
 
 	/*
-- 
2.27.0



