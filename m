Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9A05A05ED
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiHYBgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbiHYBfn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:35:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B265D97D5D;
        Wed, 24 Aug 2022 18:35:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E3FF61A2D;
        Thu, 25 Aug 2022 01:35:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E2FC433D6;
        Thu, 25 Aug 2022 01:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391341;
        bh=+mnEnYPLgKN9UzGQW5SC5TIUgnU5oWTAhZSDgxHEcSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIHsB6sO0mbQqU/CGE9NCOFRtFU3w372Ts+EcXUT2JDGwpAIw+3wnPEAkTsA/7Fss
         qzFntgqWSmRPQO/UCs/ndrMVXeC924cYpC9qC9l7IeAkDHUd3ZJWLO/wHLWxDohL0+
         IqB388sUKn1ZG0kQjSg4vnL4NTOsFqb05V9CL6JRj2SEcs71P03r+2GTA7imKy1xoo
         Nt1QNXLyKrEIsyVIYSxzLAOYv964Ot9dFlFCH2juKZq4G+yNb6B6ej4sC65GV2BRn8
         cKZXltY01eQ6Q4m+to7y0ZoENM4bHsg1JjhMH+LQIxMR95BMlmPXI09p33C5BFeU1p
         PHMlGHXEk6ruQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 19/38] s390/hypfs: avoid error message under KVM
Date:   Wed, 24 Aug 2022 21:33:42 -0400
Message-Id: <20220825013401.22096-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
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
index 5c97f48cea91..ee919bfc8186 100644
--- a/arch/s390/hypfs/inode.c
+++ b/arch/s390/hypfs/inode.c
@@ -496,9 +496,9 @@ static int __init hypfs_init(void)
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

