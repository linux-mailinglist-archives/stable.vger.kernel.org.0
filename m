Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7005A06AC
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiHYBog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235714AbiHYBoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:44:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E738B12AB6;
        Wed, 24 Aug 2022 18:39:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5422861B19;
        Thu, 25 Aug 2022 01:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AFBC433D6;
        Thu, 25 Aug 2022 01:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391589;
        bh=ZYBgH2FIuzIL5lnTg9JpERmr3mQXVkh5N9FCybZmjAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhT1Xe8n8aHcRKJ9T/o3q8k5HZ6MrtIizQ6vbJ9Uzdq54zuVSucSSz8nzmS4Wvmwq
         YtByeuyE3OgKgIhL/IZ2DDj5YIczSVHXW7ZJuvCbli3EkW2OwMVNi3quUcf+i2p4+J
         JWaTXsz32ypmOGsuZtgkR/VxCbt7UlRJ3O/6f9Y32Sc95OXq/juVe+oszxjbAYR9ps
         lMg2Gd6uEhFV+26MU7iJNlofgoH1ApqIrPZlQ8TozjiOFbdayRyKV7vsWYwox8av5+
         RyqeFv6iUCbdhX16chYwa+e+G6OjcjygfTKzup1LHlIfJOMTZ07SBKgu+X6EC4m7n9
         Jkgpm71YScbMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 4/8] s390/hypfs: avoid error message under KVM
Date:   Wed, 24 Aug 2022 21:39:23 -0400
Message-Id: <20220825013932.23467-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013932.23467-1-sashal@kernel.org>
References: <20220825013932.23467-1-sashal@kernel.org>
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 7b6670b03641ac308aaa6fa2e6f964ac993b5ea3 ]

When booting under KVM the following error messages are issued:

hypfs.7f5705: The hardware system does not support hypfs
hypfs.7a79f0: Initialization of hypfs failed with rc=-61

Demote the severity of first message from "error" to "info" and issue
the second message only in other error cases.

Signed-off-by: Juergen Gross <jgross@suse.com>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Link: https://lore.kernel.org/r/20220620094534.18967-1-jgross@suse.com
[arch/s390/hypfs/hypfs_diag.c changed description]
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/hypfs/hypfs_diag.c | 2 +-
 arch/s390/hypfs/inode.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/hypfs/hypfs_diag.c b/arch/s390/hypfs/hypfs_diag.c
index f0bc4dc3e9bf..6511d15ace45 100644
--- a/arch/s390/hypfs/hypfs_diag.c
+++ b/arch/s390/hypfs/hypfs_diag.c
@@ -437,7 +437,7 @@ __init int hypfs_diag_init(void)
 	int rc;
 
 	if (diag204_probe()) {
-		pr_err("The hardware system does not support hypfs\n");
+		pr_info("The hardware system does not support hypfs\n");
 		return -ENODATA;
 	}
 
diff --git a/arch/s390/hypfs/inode.c b/arch/s390/hypfs/inode.c
index 70139d0791b6..ca4fc66a361f 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -501,9 +501,9 @@ static int __init hypfs_init(void)
 	hypfs_vm_exit();
 fail_hypfs_diag_exit:
 	hypfs_diag_exit();
+	pr_err("Initialization of hypfs failed with rc=%i\n", rc);
 fail_dbfs_exit:
 	hypfs_dbfs_exit();
-	pr_err("Initialization of hypfs failed with rc=%i\n", rc);
 	return rc;
 }
 device_initcall(hypfs_init)
-- 
2.35.1

