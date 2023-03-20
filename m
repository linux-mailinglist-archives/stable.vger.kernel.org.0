Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86C756C1669
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231967AbjCTPGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjCTPE6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:04:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844767EF6
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:01:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06FD061585
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12791C433EF;
        Mon, 20 Mar 2023 15:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324412;
        bh=VMSUrnKNdtZB+7VOB0rfiY8ZH4xxNqFTZxPKcMoqK4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Opqs35yCaLYvu6gEKzTkxy1rTtcQ4mskrTWyYTGaiR0AR2lpbengCZqCFfLUpyXRD
         ZflM7S2WrGEM11ipyx+qswpOPx3QlpPQH37fiZjVJ/rtxlIZbOExX08w0vEQfOU+pf
         G6EulEeADW0db7vJGqT+HGjUUjnC8rKmIOyT2YI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xiang Chen <chenxiang66@hisilicon.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 15/60] scsi: core: Fix a comment in function scsi_host_dev_release()
Date:   Mon, 20 Mar 2023 15:54:24 +0100
Message-Id: <20230320145431.521587042@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
References: <20230320145430.861072439@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

[ Upstream commit 2dde5c8d912efea43be94d6a83ac9cb74879fa12 ]

Commit 3be8828fc507 ("scsi: core: Avoid that ATA error handling can
trigger a kernel hang or oops") moved rcu to scsi_cmnd instead of
shost. Modify "shost->rcu" to "scmd->rcu" in a comment.

Link: https://lore.kernel.org/r/1620646526-193154-1-git-send-email-chenxiang66@hisilicon.com
Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: be03df3d4bfe ("scsi: core: Fix a procfs host directory removal regression")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hosts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index b08d963013db6..d3a63961b98a9 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -322,7 +322,7 @@ static void scsi_host_dev_release(struct device *dev)
 	/* In case scsi_remove_host() has not been called. */
 	scsi_proc_hostdir_rm(shost->hostt);
 
-	/* Wait for functions invoked through call_rcu(&shost->rcu, ...) */
+	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
 	rcu_barrier();
 
 	if (shost->tmf_work_q)
-- 
2.39.2



