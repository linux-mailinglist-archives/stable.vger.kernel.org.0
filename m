Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E426D4A5E
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:46:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbjDCOqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbjDCOq3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:46:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE7B18268
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:46:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C7EC61EFC
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923E0C4339B;
        Mon,  3 Apr 2023 14:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533168;
        bh=MQZ9Jx9tTKTYZJS4HmSyWAdSXLS2QVhQEql2jvYVN0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RAvGgswAtK+vCXQKJHjyz+SMd0IIHzyYc3xIAhsN0VNXUsRj/LmdBydsNDorH9Ekq
         dfAn2fbtQ7+F4kmLQN3Bz2YsUK3pOJ8kRi+K3a6V0UjubRU36Z4rSvDJpQ7I6nSSoi
         21jIhi7ZLaIhpNKkSTXBl/0ABynYN5jGydwSJVa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tomas Henzl <thenzl@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 079/187] scsi: megaraid_sas: Fix crash after a double completion
Date:   Mon,  3 Apr 2023 16:08:44 +0200
Message-Id: <20230403140418.565177964@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 2309df27111a51734cb9240b4d3c25f2f3c6ab06 ]

When a physical disk is attached directly "without JBOD MAP support" (see
megasas_get_tm_devhandle()) then there is no real error handling in the
driver.  Return FAILED instead of SUCCESS.

Fixes: 18365b138508 ("megaraid_sas: Task management support")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230324150134.14696-1-thenzl@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index fe70f8f114352..5f746b4a6b8da 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4768,7 +4768,7 @@ int megasas_task_abort_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"task abort issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
@@ -4838,7 +4838,7 @@ int megasas_reset_target_fusion(struct scsi_cmnd *scmd)
 	devhandle = megasas_get_tm_devhandle(scmd->device);
 
 	if (devhandle == (u16)ULONG_MAX) {
-		ret = SUCCESS;
+		ret = FAILED;
 		sdev_printk(KERN_INFO, scmd->device,
 			"target reset issued for invalid devhandle\n");
 		mutex_unlock(&instance->reset_mutex);
-- 
2.39.2



