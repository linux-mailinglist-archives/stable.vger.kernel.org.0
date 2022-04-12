Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D06414FCB54
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 03:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345784AbiDLBEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 21:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346633AbiDLA66 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:58:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F55835DCC;
        Mon, 11 Apr 2022 17:51:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B38F160B33;
        Tue, 12 Apr 2022 00:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E1EC385AA;
        Tue, 12 Apr 2022 00:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724717;
        bh=pJ2M5/+qEwvfUYmQmLNTCFIGmh9gFKayrlgbg4eF8lo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nozCNnvrlPLzJ2IILVZMIv8Z92DK8SVtHsR4N/v2qQmnx5SUIFqWvO4FMuHgAxxri
         MZ4I5riOlU/DWme18kN+WRcFc3JHPtOPqimziXPlKjTpyULIalUGFIrnLqS7k5QRef
         xvbLk7KZrljcUa4jlipAdwSSYmB4WEC3ByM7OBt3UDJJa7fvnwWqyWB+E+pvHmDZd/
         TdXSakTmGz2V0SBVod2HJbMKBBLUHED2RJglqPBnEDrylcDRFqytjNSd11HIYXnBo5
         fR5PNP8PRMT14TOEk8LLPbw+/fbuRekRkcfW0ayTnGHLWz2jBZ8DqowpVYaarYnaiB
         tVK4ehweJ5yKQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tyrel Datwyler <tyreld@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, mikecyr@linux.ibm.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 05/12] scsi: ibmvscsis: Increase INITIAL_SRP_LIMIT to 1024
Date:   Mon, 11 Apr 2022 20:51:38 -0400
Message-Id: <20220412005148.351391-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005148.351391-1-sashal@kernel.org>
References: <20220412005148.351391-1-sashal@kernel.org>
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

From: Tyrel Datwyler <tyreld@linux.ibm.com>

[ Upstream commit 0bade8e53279157c7cc9dd95d573b7e82223d78a ]

The adapter request_limit is hardcoded to be INITIAL_SRP_LIMIT which is
currently an arbitrary value of 800. Increase this value to 1024 which
better matches the characteristics of the typical IBMi Initiator that
supports 32 LUNs and a queue depth of 32.

This change also has the secondary benefit of being a power of two as
required by the kfifo API. Since, Commit ab9bb6318b09 ("Partially revert
"kfifo: fix kfifo_alloc() and kfifo_init()"") the size of IU pool for each
target has been rounded down to 512 when attempting to kfifo_init() those
pools with the current request_limit size of 800.

Link: https://lore.kernel.org/r/20220322194443.678433-1-tyreld@linux.ibm.com
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index f42a619198c4..79bc6c3bfa6e 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -44,7 +44,7 @@
 
 #define IBMVSCSIS_VERSION	"v0.2"
 
-#define	INITIAL_SRP_LIMIT	800
+#define	INITIAL_SRP_LIMIT	1024
 #define	DEFAULT_MAX_SECTORS	256
 #define MAX_TXU			1024 * 1024
 
-- 
2.35.1

