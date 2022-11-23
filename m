Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4300C635780
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238074AbiKWJlq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbiKWJl0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:41:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54969C7207
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:38:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E097361A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:38:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2756C433C1;
        Wed, 23 Nov 2022 09:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196336;
        bh=yZlU3xvpBCtDBfZMgssOPt2vFUm1cFFzhLnsq/c26m0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEJhIhC8nwjND9cmUKgZgfsoOgdw4Q5OMN8RAJtcT8XWyHezfsk/x9rOCYCmMIOUu
         9G+jhbaZpZCUBn0s1ZiUJc417dWv3QM3UJIwKbqmt2NGi8n57rZ8H+kjGkzhN9v4oD
         1aLS6t0AB4+evAw7hZKw4mYIjzWudF8S2EMuCW/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 165/181] scsi: scsi_debug: Fix possible UAF in sdebug_add_host_helper()
Date:   Wed, 23 Nov 2022 09:52:08 +0100
Message-Id: <20221123084609.477645639@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
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
index 747e1cbb7ec9..2b5e249f5d5b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7132,8 +7132,12 @@ static int sdebug_add_host_helper(int per_host_idx)
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



