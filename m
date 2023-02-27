Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C926A37EE
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbjB0CNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:13:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjB0CMz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:12:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642671CF5A;
        Sun, 26 Feb 2023 18:11:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0312660DB6;
        Mon, 27 Feb 2023 02:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FA5C4339C;
        Mon, 27 Feb 2023 02:09:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463787;
        bh=7JX+Ew2lffhgnrNOgA2EopHIXnMXFa0FSQA/AH6E0gM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BXB9myKLlR6MLeJ9vO+PaArvRUwlysUTNv1bMCmRJGm+RMtF9zmrFK/moUstZgFWx
         lDLROdTaEs/Nz+blnZ8T/T+Ka0MnlPehVtnkR1nd/Cj7J2ZhUlpwpMEcF8/Gd+59VM
         BClO709wvsfM0Kxd6zuWCUy5azJHxojGd19dpPHl9N2RsyKFugKOmaVVQpU84GAUHg
         QJHac2/qP8qZq+afyYcckovDsCoYGgjV8RzFC1yK8kNXmZSDHS1frSsF+Rq9+INfSi
         eGWmAOB0tTs7oYx3KExXhdR03c24rN+zHuZHKVFEmlmKVecSX1biRDXp3fcV8fNNBt
         UpsY34Yx0rXhQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.15 20/25] scsi: snic: Fix memory leak with using debugfs_lookup()
Date:   Sun, 26 Feb 2023 21:08:43 -0500
Message-Id: <20230227020855.1051605-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230227020855.1051605-1-sashal@kernel.org>
References: <20230227020855.1051605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit ad0e4e2fab928477f74d742e6e77d79245d3d3e7 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic at
once.

Link: https://lore.kernel.org/r/20230202141009.2290380-1-gregkh@linuxfoundation.org
Cc: Karan Tilak Kumar <kartilak@cisco.com>
Cc: Sesidhar Baddela <sebaddel@cisco.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/snic/snic_debugfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index 5e0faeba516e5..76baa4f9a06e3 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -451,6 +451,6 @@ void snic_trc_debugfs_init(void)
 void
 snic_trc_debugfs_term(void)
 {
-	debugfs_remove(debugfs_lookup(TRC_FILE, snic_glob->trc_root));
-	debugfs_remove(debugfs_lookup(TRC_ENABLE_FILE, snic_glob->trc_root));
+	debugfs_lookup_and_remove(TRC_FILE, snic_glob->trc_root);
+	debugfs_lookup_and_remove(TRC_ENABLE_FILE, snic_glob->trc_root);
 }
-- 
2.39.0

