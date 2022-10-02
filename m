Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F095F26CE
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 01:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiJBW7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 18:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiJBW6W (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 18:58:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD48B40575;
        Sun,  2 Oct 2022 15:55:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 927D160F2C;
        Sun,  2 Oct 2022 22:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55BCC433C1;
        Sun,  2 Oct 2022 22:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664751169;
        bh=3z4xjd6rC4Y+qNEmVpMFVeGkTQLZ9ph+XAsHLmwze58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KN/vcRmTb3ppOCDK+8V5cFmGbN+bBrVlQXIn2eIubuAkvBm+hOMlefpYlZKbLCxzK
         FjDm1IcUyKeuK5DAmXRf+8rfaMyGop/MjWJsD4Fu9nHklCt6jS61yjmL6PzY1DYyhO
         vSgq7KHtwCFlpYDHdLZdGCF9LJnlz5V/FRylz0vw43D8ukjOhe0u/wbSYBxwpWwGyv
         R43EY2mSjjE7eIsV3Lt+lHt8749Urt091o7LwRRLwugnx5hfzh4VgK6dcluix1m4rI
         9uaxcZ1qCNdZ1FbOMGeqY8/Bf0YGntH4dF0PYfNONIHwzN8/g6OtdfjAB+4fPm1QRW
         wOWq4EjBplCZA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Letu Ren <fantasquex@gmail.com>, Zheyu Ma <zheyuma97@gmail.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Wende Tan <twd2.me@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, jhasan@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 5/9] scsi: qedf: Fix a UAF bug in __qedf_probe()
Date:   Sun,  2 Oct 2022 18:52:32 -0400
Message-Id: <20221002225236.239675-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221002225236.239675-1-sashal@kernel.org>
References: <20221002225236.239675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Letu Ren <fantasquex@gmail.com>

[ Upstream commit fbfe96869b782364caebae0445763969ddb6ea67 ]

In __qedf_probe(), if qedf->cdev is NULL which means
qed_ops->common->probe() failed, then the program will goto label err1, and
scsi_host_put() will free lport->host pointer. Because the memory qedf
points to is allocated by libfc_host_alloc(), it will be freed by
scsi_host_put(). However, the if statement below label err0 only checks
whether qedf is NULL but doesn't check whether the memory has been freed.
So a UAF bug can occur.

There are two ways to reach the statements below err0. The first one is
described as before, "qedf" should be set to NULL. The second one is goto
"err0" directly. In the latter scenario qedf hasn't been changed and it has
the initial value NULL. As a result the if statement is not reachable in
any situation.

The KASAN logs are as follows:

[    2.312969] BUG: KASAN: use-after-free in __qedf_probe+0x5dcf/0x6bc0
[    2.312969]
[    2.312969] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
[    2.312969] Call Trace:
[    2.312969]  dump_stack_lvl+0x59/0x7b
[    2.312969]  print_address_description+0x7c/0x3b0
[    2.312969]  ? __qedf_probe+0x5dcf/0x6bc0
[    2.312969]  __kasan_report+0x160/0x1c0
[    2.312969]  ? __qedf_probe+0x5dcf/0x6bc0
[    2.312969]  kasan_report+0x4b/0x70
[    2.312969]  ? kobject_put+0x25d/0x290
[    2.312969]  kasan_check_range+0x2ca/0x310
[    2.312969]  __qedf_probe+0x5dcf/0x6bc0
[    2.312969]  ? selinux_kernfs_init_security+0xdc/0x5f0
[    2.312969]  ? trace_rpm_return_int_rcuidle+0x18/0x120
[    2.312969]  ? rpm_resume+0xa5c/0x16e0
[    2.312969]  ? qedf_get_generic_tlv_data+0x160/0x160
[    2.312969]  local_pci_probe+0x13c/0x1f0
[    2.312969]  pci_device_probe+0x37e/0x6c0

Link: https://lore.kernel.org/r/20211112120641.16073-1-fantasquex@gmail.com
Reported-by: Zheyu Ma <zheyuma97@gmail.com>
Acked-by: Saurav Kashyap <skashyap@marvell.com>
Co-developed-by: Wende Tan <twd2.me@gmail.com>
Signed-off-by: Wende Tan <twd2.me@gmail.com>
Signed-off-by: Letu Ren <fantasquex@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index c95e04cc6424..f864ef059d29 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3544,11 +3544,6 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
 err1:
 	scsi_host_put(lport->host);
 err0:
-	if (qedf) {
-		QEDF_INFO(&qedf->dbg_ctx, QEDF_LOG_DISC, "Probe done.\n");
-
-		clear_bit(QEDF_PROBING, &qedf->flags);
-	}
 	return rc;
 }
 
-- 
2.35.1

