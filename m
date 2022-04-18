Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDD950510A
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbiDRMas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240193AbiDRM3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:29:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA8420BE1;
        Mon, 18 Apr 2022 05:23:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 526FB60FD8;
        Mon, 18 Apr 2022 12:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B69FC385A1;
        Mon, 18 Apr 2022 12:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284603;
        bh=dz4DyjCE1hkovpKUeU40FoIrDG+dduM3Lv3sZS9Qj9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAyj7lmHPYoahm09cYMOSrEP/qFF4rCFGJdF+QEeIdkj9kT9RqT/DvVMuV/TIhueJ
         Zn+JuQSkZM1bQiQmrl5ob78hBOLXnfqt2npBF/eN/ePwFDJxl+IBMg+/xdjsDhhjjP
         /Q7MdqhKcairJMqMCwU4fEDe3dK+ofzskZan7KPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 167/219] scsi: mpt3sas: Fail reset operation if config request timed out
Date:   Mon, 18 Apr 2022 14:12:16 +0200
Message-Id: <20220418121211.557252279@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

[ Upstream commit f61eb1216c959f93ffabd3b8781fa5b2b22f8907 ]

As part of controller reset operation the driver issues a config request
command. If this command gets times out, then fail the controller reset
operation instead of retrying it.

Link: https://lore.kernel.org/r/20220405120637.20528-1-sreekanth.reddy@broadcom.com
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_config.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
index 0563078227de..a8dd14c91efd 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_config.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
@@ -394,10 +394,13 @@ _config_request(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigRequest_t
 		retry_count++;
 		if (ioc->config_cmds.smid == smid)
 			mpt3sas_base_free_smid(ioc, smid);
-		if ((ioc->shost_recovery) || (ioc->config_cmds.status &
-		    MPT3_CMD_RESET) || ioc->pci_error_recovery)
+		if (ioc->config_cmds.status & MPT3_CMD_RESET)
 			goto retry_config;
-		issue_host_reset = 1;
+		if (ioc->shost_recovery || ioc->pci_error_recovery) {
+			issue_host_reset = 0;
+			r = -EFAULT;
+		} else
+			issue_host_reset = 1;
 		goto free_mem;
 	}
 
-- 
2.35.1



