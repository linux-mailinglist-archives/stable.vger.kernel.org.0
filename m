Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F310635648
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbiKWJ3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237714AbiKWJ2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:28:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC32C7207
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:26:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67773B81EF2
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8A71C433D7;
        Wed, 23 Nov 2022 09:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195610;
        bh=iHtYXJUW5kF5M8kJ0vGoQn8upBt80fEQeivL6K3pozs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CyiZezmnsZNdvLURekPGxifEVc0v+J5zWkUgfxjQPKM9qSdAYuBlwOgBV7LEyShN3
         8LvNgX37YqYXiRYuJv9PATDUqwpEoXhmMNWkNbQNd/Oc22tioLqlPgfyCMjtPLDXT2
         cKyO50GddOHNSrPsh2IkU0dJRKe1r5zGTf9NRjxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/149] scsi: scsi_debug: Fix possible UAF in sdebug_add_host_helper()
Date:   Wed, 23 Nov 2022 09:51:57 +0100
Message-Id: <20221123084602.746806291@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit e208a1d795a08d1ac0398c79ad9c58106531bcc5 ]

If device_register() fails in sdebug_add_host_helper(), it will goto clean
and sdbg_host will be freed, but sdbg_host->host_list will not be removed
from sdebug_host_list, then list traversal may cause UAF. Fix it.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Link: https://lore.kernel.org/r/20221117084421.58918-1-yuancan@huawei.com
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5eb959b5f701..261b915835b4 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7079,8 +7079,12 @@ static int sdebug_add_host_helper(int per_host_idx)
 	dev_set_name(&sdbg_host->dev, "adapter%d", sdebug_num_hosts);
 
 	error = device_register(&sdbg_host->dev);
-	if (error)
+	if (error) {
+		spin_lock(&sdebug_host_list_lock);
+		list_del(&sdbg_host->host_list);
+		spin_unlock(&sdebug_host_list_lock);
 		goto clean;
+	}
 
 	++sdebug_num_hosts;
 	return 0;
-- 
2.35.1



