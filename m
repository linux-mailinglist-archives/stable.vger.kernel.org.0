Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C8A6AEA4D
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231591AbjCGRce (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:32:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjCGRcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:32:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334B284800
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:27:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C36606150C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC073C433D2;
        Tue,  7 Mar 2023 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210066;
        bh=6/JlZ7+fNkJTLRJeQtpbctCE5wwDegtJYJf1VizDYMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LuuFBHlcomnAg5+N0pxdE7j4XfCUYeNOfqEBqLinbgEpqXeYVRH2r/n55SneQsEP7
         ZPC66/K62vnIhx82eqnZxmoFZ9a4TsRysOlYQQBNspNLAF5H5mBNSFvjaWCx23gLEW
         OGjSEAr/sk+uarNg9lsYB76rl3m6Dz5FPvs//lYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0420/1001] scsi: mpt3sas: Fix a memory leak
Date:   Tue,  7 Mar 2023 17:53:12 +0100
Message-Id: <20230307170039.569541734@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 54dd96015e8d7a2a07359e2dfebf05b529d1780c ]

Add a forgotten kfree().

Fixes: dbec4c9040ed ("scsi: mpt3sas: lockless command submission")
Link: https://lore.kernel.org/r/20230207152159.18627-1-thenzl@redhat.com
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 69061545d9d2f..2ee9ea57554d7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5849,6 +5849,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		}
 		dma_pool_destroy(ioc->pcie_sgl_dma_pool);
 	}
+	kfree(ioc->pcie_sg_lookup);
+	ioc->pcie_sg_lookup = NULL;
+
 	if (ioc->config_page) {
 		dexitprintk(ioc,
 			    ioc_info(ioc, "config_page(0x%p): free\n",
-- 
2.39.2



