Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 925986D476F
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbjDCOUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233130AbjDCOTw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:19:52 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CF82D7E8
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:19:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A4C8ECE12BD
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911DFC4339B;
        Mon,  3 Apr 2023 14:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680531577;
        bh=Fy2YrRAAoImnTVqUwdTNS4OCM1YV9jkc4SNPDePF8FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zIS7+R5d5GT3i7ZUpRqkMTiAO/PyfbdD2rUzSBswvw/PCGbdmIlI7Z0QoDBW9W6Th
         S/jGSxEgcpaxT5ie9gbNKuijVp9XQn2FxrOEf2OXFiJVQNMtrg4N6+OU01qTRzY0Kv
         qfFEq2v4mVilgv4+IvQLDlV5hB/T49HHX2R/xqPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yu Kuai <yukuai3@huawei.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/104] scsi: scsi_dh_alua: Fix memleak for qdata in alua_activate()
Date:   Mon,  3 Apr 2023 16:08:00 +0200
Message-Id: <20230403140404.436099703@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
References: <20230403140403.549815164@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit a13faca032acbf2699293587085293bdfaafc8ae ]

If alua_rtpg_queue() failed from alua_activate(), then 'qdata' is not
freed, which will cause following memleak:

unreferenced object 0xffff88810b2c6980 (size 32):
  comm "kworker/u16:2", pid 635322, jiffies 4355801099 (age 1216426.076s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    40 39 24 c1 ff ff ff ff 00 f8 ea 0a 81 88 ff ff  @9$.............
  backtrace:
    [<0000000098f3a26d>] alua_activate+0xb0/0x320
    [<000000003b529641>] scsi_dh_activate+0xb2/0x140
    [<000000007b296db3>] activate_path_work+0xc6/0xe0 [dm_multipath]
    [<000000007adc9ace>] process_one_work+0x3c5/0x730
    [<00000000c457a985>] worker_thread+0x93/0x650
    [<00000000cb80e628>] kthread+0x1ba/0x210
    [<00000000a1e61077>] ret_from_fork+0x22/0x30

Fix the problem by freeing 'qdata' in error path.

Fixes: 625fe857e4fa ("scsi: scsi_dh_alua: Check scsi_device_get() return value")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20230315062154.668812-1-yukuai1@huaweicloud.com
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index fe8a5e5c0df84..bf0b3178f84d0 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -1036,10 +1036,12 @@ static int alua_activate(struct scsi_device *sdev,
 	rcu_read_unlock();
 	mutex_unlock(&h->init_mutex);
 
-	if (alua_rtpg_queue(pg, sdev, qdata, true))
+	if (alua_rtpg_queue(pg, sdev, qdata, true)) {
 		fn = NULL;
-	else
+	} else {
+		kfree(qdata);
 		err = SCSI_DH_DEV_OFFLINED;
+	}
 	kref_put(&pg->kref, release_port_group);
 out:
 	if (fn)
-- 
2.39.2



