Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BF5760A4C6
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232999AbiJXMPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbiJXMO7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:14:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 089993055D;
        Mon, 24 Oct 2022 04:55:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1EC52612E9;
        Mon, 24 Oct 2022 11:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE60C433D7;
        Mon, 24 Oct 2022 11:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612531;
        bh=ruyn6ny/iz6Zqxp+/ivNz+r7BDWMhMcf5ChJDxysrYo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZxNdhhXWGFuuj00OvT3WfcMRFq7sFDEHyGujjQTb/Q4YYJVSR/AxlRo7vr806CZZ
         tDHjRccWHaFlchA2LpEZEJ1YhPYh/hGdSMjp8wED89ZIobRk3ts1NAFmu5g/cnLpTa
         VRSAjZQtECdaIPT6/f7a2+xbAvdf0Ne6khD1CnAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Saurav Kashyap <skashyap@marvell.com>,
        Wende Tan <twd2.me@gmail.com>, Letu Ren <fantasquex@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 009/229] scsi: qedf: Fix a UAF bug in __qedf_probe()
Date:   Mon, 24 Oct 2022 13:28:48 +0200
Message-Id: <20221024112959.416076778@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b253523217b8..01e27285b26b 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -3345,11 +3345,6 @@ static int __qedf_probe(struct pci_dev *pdev, int mode)
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



