Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADA54F315B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343622AbiDEI5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239149AbiDEIbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:31:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FD75370B;
        Tue,  5 Apr 2022 01:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B554B81BBF;
        Tue,  5 Apr 2022 08:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B05C385A1;
        Tue,  5 Apr 2022 08:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146996;
        bh=B+LL6HqRHaXg/j5A4/f7HpsysJBncMEphF9/Mdw/N7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IUD6fql9DbiCYm3NHsHPKEYt7AQo1osr2JnApSPcpi5wRbmpIJJ89sUNpAOU1fAHP
         53ShSUG7p/lv0rQ5oaVOW9yrGgJqORHm7kVddKeUndcueBaIxk9ICF6jm+5+NeiaPd
         phNCVcMydfsVRXlS7UQBhEa0yNd0vndwEpfknFvU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0926/1126] lib/test_lockup: fix kernel pointer check for separate address spaces
Date:   Tue,  5 Apr 2022 09:27:53 +0200
Message-Id: <20220405070434.700016124@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



