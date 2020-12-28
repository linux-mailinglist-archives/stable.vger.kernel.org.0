Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C982E41EC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437969AbgL1OGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:06:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437873AbgL1OGO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21E2B207B6;
        Mon, 28 Dec 2020 14:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164333;
        bh=TEdnqWdjjDu9DHd2eze2o2SrxM0uyzuNi3qi3D26uHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOYje4hlQqAGcEhFYuzyoLbGnufCXYM20MXRSkhDbH2VJeeNd58OMno6wwkX/sfBd
         qolS3ASo6tQqdcHxSg5UIPKHeYmzhclPqypE9mjkkBzjHIVFJv2BiRSpyfCGDtDLkS
         JUC6Lc3izLvLyKZEo8lAdSO1STrLvX3DCN2q/lAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jing Xiangfeng <jingxiangfeng@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/717] staging: gasket: interrupt: fix the missed eventfd_ctx_put() in gasket_interrupt.c
Date:   Mon, 28 Dec 2020 13:41:50 +0100
Message-Id: <20201228125026.324107976@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jing Xiangfeng <jingxiangfeng@huawei.com>

[ Upstream commit ab5b769a23af12a675b9f3d7dd529250c527f5ac ]

gasket_interrupt_set_eventfd() misses to call eventfd_ctx_put() in an
error path. We check interrupt is valid before calling
eventfd_ctx_fdget() to fix it.

There is the same issue in gasket_interrupt_clear_eventfd(), Add the
missed function call to fix it.

Fixes: 9a69f5087ccc ("drivers/staging: Gasket driver framework + Apex driver")
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
Link: https://lore.kernel.org/r/20201112064924.99680-1-jingxiangfeng@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gasket/gasket_interrupt.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/gasket/gasket_interrupt.c b/drivers/staging/gasket/gasket_interrupt.c
index 2d6195f7300e9..864342acfd86e 100644
--- a/drivers/staging/gasket/gasket_interrupt.c
+++ b/drivers/staging/gasket/gasket_interrupt.c
@@ -487,14 +487,16 @@ int gasket_interrupt_system_status(struct gasket_dev *gasket_dev)
 int gasket_interrupt_set_eventfd(struct gasket_interrupt_data *interrupt_data,
 				 int interrupt, int event_fd)
 {
-	struct eventfd_ctx *ctx = eventfd_ctx_fdget(event_fd);
-
-	if (IS_ERR(ctx))
-		return PTR_ERR(ctx);
+	struct eventfd_ctx *ctx;
 
 	if (interrupt < 0 || interrupt >= interrupt_data->num_interrupts)
 		return -EINVAL;
 
+	ctx = eventfd_ctx_fdget(event_fd);
+
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
 	interrupt_data->eventfd_ctxs[interrupt] = ctx;
 	return 0;
 }
@@ -505,6 +507,9 @@ int gasket_interrupt_clear_eventfd(struct gasket_interrupt_data *interrupt_data,
 	if (interrupt < 0 || interrupt >= interrupt_data->num_interrupts)
 		return -EINVAL;
 
-	interrupt_data->eventfd_ctxs[interrupt] = NULL;
+	if (interrupt_data->eventfd_ctxs[interrupt]) {
+		eventfd_ctx_put(interrupt_data->eventfd_ctxs[interrupt]);
+		interrupt_data->eventfd_ctxs[interrupt] = NULL;
+	}
 	return 0;
 }
-- 
2.27.0



