Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539694FD23D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 09:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346048AbiDLHJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352294AbiDLHFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:05:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797CD4739E;
        Mon, 11 Apr 2022 23:47:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2F65B81B43;
        Tue, 12 Apr 2022 06:47:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17911C385A1;
        Tue, 12 Apr 2022 06:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649746074;
        bh=+jloK1x6yesqpkLixBF6zJTts935DxetEL6Gh082koc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osiotdPzWDukE1QhH8YptcM9qE9/CoPJbduPFasoc5Op/siuxkg+x8dJw8NF6RDU7
         x6VSFxhPFWxaX1sgh8z1aJoTvnJx3wNZlvvgxCXEYdujW2143X/MWbltnIZQjz8AuO
         /AoIgoXnnLhQ6v9Mk02o2tmLn3E4fLVHTYvD4j1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 152/277] scsi: core: Fix sbitmap depth in scsi_realloc_sdev_budget_map()
Date:   Tue, 12 Apr 2022 08:29:15 +0200
Message-Id: <20220412062946.437671584@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062942.022903016@linuxfoundation.org>
References: <20220412062942.022903016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Garry <john.garry@huawei.com>

[ Upstream commit eaba83b5b8506bbc9ee7ca2f10aeab3fff3719e7 ]

In commit edb854a3680b ("scsi: core: Reallocate device's budget map on
queue depth change"), the sbitmap for the device budget map may be
reallocated after the slave device depth is configured.

When the sbitmap is reallocated we use the result from
scsi_device_max_queue_depth() for the sbitmap size, but don't resize to
match the actual device queue depth.

Fix by resizing the sbitmap after reallocating the budget sbitmap. We do
this instead of init'ing the sbitmap to the device queue depth as the user
may want to change the queue depth later via sysfs or other.

Link: https://lore.kernel.org/r/1647423870-143867-1-git-send-email-john.garry@huawei.com
Fixes: edb854a3680b ("scsi: core: Reallocate device's budget map on queue depth change")
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 7266880c70c2..9466474ff01b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -207,6 +207,8 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 	int ret;
 	struct sbitmap sb_backup;
 
+	depth = min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev));
+
 	/*
 	 * realloc if new shift is calculated, which is caused by setting
 	 * up one new default queue depth after calling ->slave_configure
@@ -229,6 +231,9 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 				scsi_device_max_queue_depth(sdev),
 				new_shift, GFP_KERNEL,
 				sdev->request_queue->node, false, true);
+	if (!ret)
+		sbitmap_resize(&sdev->budget_map, depth);
+
 	if (need_free) {
 		if (ret)
 			sdev->budget_map = sb_backup;
-- 
2.35.1



