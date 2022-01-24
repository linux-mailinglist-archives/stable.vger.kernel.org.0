Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F666499AA6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573644AbiAXVp1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58036 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444637AbiAXVjb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:39:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64EAD612E5;
        Mon, 24 Jan 2022 21:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D26AC340E4;
        Mon, 24 Jan 2022 21:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060366;
        bh=MwVDU5KHXsZMAwuTBPhjmF0Tyu+ExRo7B82mYWrX2lQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icgJoUL/oGhuK3ZuQgraHVw/m+NO10p/fitA4OFn5NH3J/9IKJT5t4AtBTSRscZDb
         sZj62ylWqGyl8DiP2ssluTBrM534u8s18p1L+1IMA1lyPpdNAXCVVXUnbBsZqwzbpm
         nmpinDyeKaDd/iZdCQyEsnfy/+ORNYAY0yOLyXYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Van <lucas.van@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.16 0924/1039] dmaengine: idxd: fix wq settings post wq disable
Date:   Mon, 24 Jan 2022 19:45:13 +0100
Message-Id: <20220124184156.355071904@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

commit 0f225705cf6536826318180831e18a74595efc8d upstream.

By the spec, wq size and group association is not changeable unless device
is disabled. Exclude clearing the shadow copy on wq disable/reset. This
allows wq type to be changed after disable to be re-enabled.

Move the size and group association to its own cleanup and only call it
during device disable.

Fixes: 0dcfe41e9a4c ("dmanegine: idxd: cleanup all device related bits after disabling device")
Reported-by: Lucas Van <lucas.van@intel.com>
Tested-by: Lucas Van <lucas.van@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/163951291732.2987775.13576571320501115257.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/device.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -382,8 +382,6 @@ static void idxd_wq_disable_cleanup(stru
 	lockdep_assert_held(&wq->wq_lock);
 	memset(wq->wqcfg, 0, idxd->wqcfg_size);
 	wq->type = IDXD_WQT_NONE;
-	wq->size = 0;
-	wq->group = NULL;
 	wq->threshold = 0;
 	wq->priority = 0;
 	wq->ats_dis = 0;
@@ -392,6 +390,15 @@ static void idxd_wq_disable_cleanup(stru
 	memset(wq->name, 0, WQ_NAME_SIZE);
 }
 
+static void idxd_wq_device_reset_cleanup(struct idxd_wq *wq)
+{
+	lockdep_assert_held(&wq->wq_lock);
+
+	idxd_wq_disable_cleanup(wq);
+	wq->size = 0;
+	wq->group = NULL;
+}
+
 static void idxd_wq_ref_release(struct percpu_ref *ref)
 {
 	struct idxd_wq *wq = container_of(ref, struct idxd_wq, wq_active);
@@ -699,6 +706,7 @@ static void idxd_device_wqs_clear_state(
 
 		if (wq->state == IDXD_WQ_ENABLED) {
 			idxd_wq_disable_cleanup(wq);
+			idxd_wq_device_reset_cleanup(wq);
 			wq->state = IDXD_WQ_DISABLED;
 		}
 	}


