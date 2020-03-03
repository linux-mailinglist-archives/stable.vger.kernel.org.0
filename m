Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13148176CC0
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 03:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728184AbgCCC6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 21:58:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728231AbgCCCr7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 21:47:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8BBE246D6;
        Tue,  3 Mar 2020 02:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583203678;
        bh=m3/5GV8iND6nq+ZvNW2PfXvQ5eZR+5DVF27T+hS7AB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OT/96ng/nGYJPcu4xo0hlDfLhygu3zDj24+aqKX8RC8FW0UQAzJ5sgoF//XTmdeLU
         3/c8XW9/FTdJKeRSMANGJQ4u/O51HAZWzM06ynuNhhTFqyR8Cf/lr78WnQgOQTmuRJ
         RPUtVahyc0xeCE3DrYFWT8KCQNd8N/hZA6TLbJ+U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomas Henzl <thenzl@redhat.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 15/58] scsi: megaraid_sas: silence a warning
Date:   Mon,  2 Mar 2020 21:46:57 -0500
Message-Id: <20200303024740.9511-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200303024740.9511-1-sashal@kernel.org>
References: <20200303024740.9511-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 0e99b2c625da181aebf1a3d13493e3f7a5057a9c ]

Add a flag to DMA memory allocation to silence a warning.

This driver allocates DMA memory for IO frames. This allocation may exceed
MAX_ORDER pages for few megaraid_sas controllers (controllers with very
high queue depth). Consequently, the driver has logic to keep reducing the
controller queue depth until the DMA memory allocation succeeds.

On impacted megaraid_sas controllers there would be multiple DMA allocation
failures until driver settled on an allocation that fit. These failed DMA
allocation requests caused stack traces in system logs. These were not
harmful and this patch silences those warnings/stack traces.

[mkp: clarified commit desc]

Link: https://lore.kernel.org/r/20200204152413.7107-1-thenzl@redhat.com
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 46bc062d873ef..d868388018053 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -594,7 +594,8 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
 
 	fusion->io_request_frames =
 			dma_pool_alloc(fusion->io_request_frames_pool,
-				GFP_KERNEL, &fusion->io_request_frames_phys);
+				GFP_KERNEL | __GFP_NOWARN,
+				&fusion->io_request_frames_phys);
 	if (!fusion->io_request_frames) {
 		if (instance->max_fw_cmds >= (MEGASAS_REDUCE_QD_COUNT * 2)) {
 			instance->max_fw_cmds -= MEGASAS_REDUCE_QD_COUNT;
@@ -632,7 +633,7 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
 
 		fusion->io_request_frames =
 			dma_pool_alloc(fusion->io_request_frames_pool,
-				       GFP_KERNEL,
+				       GFP_KERNEL | __GFP_NOWARN,
 				       &fusion->io_request_frames_phys);
 
 		if (!fusion->io_request_frames) {
-- 
2.20.1

