Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B75469A90
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhLFPIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:08:49 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39846 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346588AbhLFPGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:06:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A26BDB810F1;
        Mon,  6 Dec 2021 15:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBE0EC341C5;
        Mon,  6 Dec 2021 15:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802997;
        bh=uYXDFSPFZbtjpC4Y373rOWrzdQGl0i1UsKHhx8qDUrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i0mKRKld5IZoPs3mOEgEIH6U5PYKgKS9uts5dH8y4Jq4p3/9XdaIqFi9qVgeaDyyg
         zejLZFezuBe08Aaebj9Jg+UZnhaadvO235ElLamXgmm+oTWRt+4+ujrg28VFh7qc8v
         isd/t66bZRlBACR31lXLUI28uAY6CjNX5p+uRIVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhou Qingyang <zhou1615@umn.edu>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 55/62] net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()
Date:   Mon,  6 Dec 2021 15:56:38 +0100
Message-Id: <20211206145551.108279336@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhou Qingyang <zhou1615@umn.edu>

commit e2dabc4f7e7b60299c20a36d6a7b24ed9bf8e572 upstream.

In qlcnic_83xx_add_rings(), the indirect function of
ahw->hw_ops->alloc_mbx_args will be called to allocate memory for
cmd.req.arg, and there is a dereference of it in qlcnic_83xx_add_rings(),
which could lead to a NULL pointer dereference on failure of the
indirect function like qlcnic_83xx_alloc_mbx_args().

Fix this bug by adding a check of alloc_mbx_args(), this patch
imitates the logic of mbx_cmd()'s failure handling.

This bug was found by a static analyzer. The analysis employs
differential checking to identify inconsistent security operations
(e.g., checks or kfrees) between two code paths and confirms that the
inconsistent operations are not recovered in the current function or
the callers, so they constitute bugs.

Note that, as a bug found by static analysis, it can be a false
positive or hard to trigger. Multiple researchers have cross-reviewed
the bug.

Builds with CONFIG_QLCNIC=m show no new warnings, and our
static analyzer no longer warns about this code.

Fixes: 7f9664525f9c ("qlcnic: 83xx memory map and HW access routine")
Signed-off-by: Zhou Qingyang <zhou1615@umn.edu>
Link: https://lore.kernel.org/r/20211130110848.109026-1-zhou1615@umn.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -1078,8 +1078,14 @@ static int qlcnic_83xx_add_rings(struct
 	sds_mbx_size = sizeof(struct qlcnic_sds_mbx);
 	context_id = recv_ctx->context_id;
 	num_sds = adapter->drv_sds_rings - QLCNIC_MAX_SDS_RINGS;
-	ahw->hw_ops->alloc_mbx_args(&cmd, adapter,
-				    QLCNIC_CMD_ADD_RCV_RINGS);
+	err = ahw->hw_ops->alloc_mbx_args(&cmd, adapter,
+					QLCNIC_CMD_ADD_RCV_RINGS);
+	if (err) {
+		dev_err(&adapter->pdev->dev,
+			"Failed to alloc mbx args %d\n", err);
+		return err;
+	}
+
 	cmd.req.arg[1] = 0 | (num_sds << 8) | (context_id << 16);
 
 	/* set up status rings, mbx 2-81 */


