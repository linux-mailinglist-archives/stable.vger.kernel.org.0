Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDEDE635924
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbiKWKH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236777AbiKWKGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:06:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C266210573
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:57:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 675DCB81EF6
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD643C433D6;
        Wed, 23 Nov 2022 09:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197436;
        bh=+iJ9RqEU6UjHbKqIjJD5ROmq13KHPKyPL25slfKHbZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=czIIttZzXt/bNp1sRlF3Wz29iXG8nagiLQXW3iSB+J4IGz4nfHP3v6hYILBmXg4PN
         BkpgxBpDud718hCHRHc8w/UvCGAWSd/1TA3Wto0PxA0WeQtQ+OiGSuUSmYHfgjm3dE
         EfVoQd1+YUrmhMA3u14AQlT1xKrP5lceJZD2EzGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 293/314] scsi: scsi_debug: Fix possible UAF in sdebug_add_host_helper()
Date:   Wed, 23 Nov 2022 09:52:18 +0100
Message-Id: <20221123084638.808905597@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
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
index b8a76b89f85a..95f940f5c996 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7316,8 +7316,12 @@ static int sdebug_add_host_helper(int per_host_idx)
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



