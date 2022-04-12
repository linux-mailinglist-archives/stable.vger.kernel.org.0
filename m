Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069494FC9F6
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiDLAuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243086AbiDLAtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:49:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A2131515;
        Mon, 11 Apr 2022 17:46:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1D2AB8186F;
        Tue, 12 Apr 2022 00:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B7CC385AA;
        Tue, 12 Apr 2022 00:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724390;
        bh=dz4DyjCE1hkovpKUeU40FoIrDG+dduM3Lv3sZS9Qj9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O84g80fLG6wOE5C8NkfInAgL+wYXMoJ02qDgB0ToHab+9hHv4shNEICkVTUoFFwIq
         B0CItrqd6GK9hjv8pKrleqe6FxKVVSF6OYM07qxi3OzA47ZaBX5SAz0wfTRrDNe5Hq
         mNXhkBO5C9q7q91h62TbjEb6ufwo7nw117el2upM56+YSY1npJJUeFlsd8LrsEnJjh
         mZRUdIZV2y+1EICZEtkcylx+V0iEjzYggtrkxFZgJaw/JgO90Ew+T79zj5QKVVsb6u
         wxCLaX5Pe+DlG3oPu80oTLBX9GxEEmw2KoFa2nH0lTcCHa0fWQ4aNl6w1zTIYRRg2j
         hPLiAo1d8FooQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 41/49] scsi: mpt3sas: Fail reset operation if config request timed out
Date:   Mon, 11 Apr 2022 20:43:59 -0400
Message-Id: <20220412004411.349427-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

