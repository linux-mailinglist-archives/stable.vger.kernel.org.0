Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C94814EC14D
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344488AbiC3L4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344767AbiC3Lxd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:53:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC1726C2FF;
        Wed, 30 Mar 2022 04:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E77EAB81BBA;
        Wed, 30 Mar 2022 11:49:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E51FC34112;
        Wed, 30 Mar 2022 11:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640976;
        bh=B+LL6HqRHaXg/j5A4/f7HpsysJBncMEphF9/Mdw/N7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cs8vojwpVPhQ8EHsRPIOW3bARxTJfVGFFAGqwzhEMxtj3zDTms0W80pz93yXJTmnl
         PdPMjocKj7xLz4qwehRlgg/poBrMTPiNts4AJGUigLzemx4spXbXy3xQQHTOBg+fQA
         APtGnLwNJUDJpy4lI5/7+L47awbrnZwtVMNfwc2VJDSAe/ASGOhmQ/7aJ5UCnjtxAY
         RWTeKF4QY/4zhc5tVctlDhqbUgxk9whgDp3UbNWeVsNeZeqpuwqNomCTx3MxIvE00E
         i4Mbdhg2oYd2uPm/f/By/IIuAQHFP2TJ943U9q60KiAA255nPObAAg8SlLbb7fpGaU
         w/LvVdu3Jn9iA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.16 41/59] lib/test_lockup: fix kernel pointer check for separate address spaces
Date:   Wed, 30 Mar 2022 07:48:13 -0400
Message-Id: <20220330114831.1670235-41-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114831.1670235-1-sashal@kernel.org>
References: <20220330114831.1670235-1-sashal@kernel.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 5a06fcb15b43d1f7bf740c672950122331cb5655 ]

test_kernel_ptr() uses access_ok() to figure out if a given address
points to user space instead of kernel space. However on architectures
that set CONFIG_ALTERNATE_USER_ADDRESS_SPACE, a pointer can be valid
for both, and the check always fails because access_ok() returns true.

Make the check for user space pointers conditional on the type of
address space layout.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_lockup.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/lib/test_lockup.c b/lib/test_lockup.c
index 6a0f329a794a..c3fd87d6c2dd 100644
--- a/lib/test_lockup.c
+++ b/lib/test_lockup.c
@@ -417,9 +417,14 @@ static bool test_kernel_ptr(unsigned long addr, int size)
 		return false;
 
 	/* should be at least readable kernel address */
-	if (access_ok((void __user *)ptr, 1) ||
-	    access_ok((void __user *)ptr + size - 1, 1) ||
-	    get_kernel_nofault(buf, ptr) ||
+	if (!IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) &&
+	    (access_ok((void __user *)ptr, 1) ||
+	     access_ok((void __user *)ptr + size - 1, 1))) {
+		pr_err("user space ptr invalid in kernel: %#lx\n", addr);
+		return true;
+	}
+
+	if (get_kernel_nofault(buf, ptr) ||
 	    get_kernel_nofault(buf, ptr + size - 1)) {
 		pr_err("invalid kernel ptr: %#lx\n", addr);
 		return true;
-- 
2.34.1

