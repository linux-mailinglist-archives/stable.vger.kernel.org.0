Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6459C6DEE35
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjDLIlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231217AbjDLIkG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:40:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509E07AA1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:39:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53E6D6289E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:38:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67EBEC4339B;
        Wed, 12 Apr 2023 08:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288692;
        bh=3vvwhEoRZYs80la9alaXfOPN9v/OrH7gBkX11P39nt4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=od9tLUezHWL7o3LNWPjEy/7gacK+H/+YSnBc5CJM8hCWpe/8ug6P78yTlHE/oX9hj
         no1PjaG0njtlWwKyalLtsx3sKAAWDp714yOfOyAoRshwXudjIU/N9r2kJ1JDBZeYok
         B6KWGBzzb03l7KXVy5qY8hahdTPaYNXd0PSjvMwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Li Zetao <lizetao1@huawei.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 74/93] scsi: qla2xxx: Fix memory leak in qla2x00_probe_one()
Date:   Wed, 12 Apr 2023 10:34:15 +0200
Message-Id: <20230412082826.247990257@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zetao <lizetao1@huawei.com>

[ Upstream commit 85ade4010e13ef152ea925c74d94253db92e5428 ]

There is a memory leak reported by kmemleak:

  unreferenced object 0xffffc900003f0000 (size 12288):
    comm "modprobe", pid 19117, jiffies 4299751452 (age 42490.264s)
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<00000000629261a8>] __vmalloc_node_range+0xe56/0x1110
      [<0000000001906886>] __vmalloc_node+0xbd/0x150
      [<000000005bb4dc34>] vmalloc+0x25/0x30
      [<00000000a2dc1194>] qla2x00_create_host+0x7a0/0xe30 [qla2xxx]
      [<0000000062b14b47>] qla2x00_probe_one+0x2eb8/0xd160 [qla2xxx]
      [<00000000641ccc04>] local_pci_probe+0xeb/0x1a0

The root cause is traced to an error-handling path in qla2x00_probe_one()
when the adapter "base_vha" initialize failed. The fab_scan_rp "scan.l" is
used to record the port information and it is allocated in
qla2x00_create_host(). However, it is not released in the error handling
path "probe_failed".

Fix this by freeing the memory of "scan.l" when an error occurs in the
adapter initialization process.

Fixes: a4239945b8ad ("scsi: qla2xxx: Add switch command to simplify fabric discovery")
Signed-off-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/r/20230325110004.363898-1-lizetao1@huawei.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_os.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 6063f48558081..2efe31327ed1e 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3573,6 +3573,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 probe_failed:
 	qla_enode_stop(base_vha);
 	qla_edb_stop(base_vha);
+	vfree(base_vha->scan.l);
 	if (base_vha->gnl.l) {
 		dma_free_coherent(&ha->pdev->dev, base_vha->gnl.size,
 				base_vha->gnl.l, base_vha->gnl.ldma);
-- 
2.39.2



