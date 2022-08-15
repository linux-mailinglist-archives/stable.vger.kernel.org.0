Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF4E593DED
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345272AbiHOUdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348296AbiHOUc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:32:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA4913F0F;
        Mon, 15 Aug 2022 12:05:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2AB761299;
        Mon, 15 Aug 2022 19:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C2BC433D6;
        Mon, 15 Aug 2022 19:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590329;
        bh=r8VC5k8yCnxrmhJJjc40MMt9lv8g2qFUnZotxUDIYhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s1m133Y9WgbzeidEUh86d8sbISjNrpGMyVczHLC+t5HHnI+bsB1MrwrtM0Ke5UxcU
         tnpIczr2dXquMMgoKYvkUHi3wDKxx1kg8v8A85Ccf6A8/QlxfwWdtJKJqo2JkEZ0bN
         u2InamQ1cCiteE8H9kJ91nWjPJPlpua9+3NQhgJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0198/1095] x86/pmem: Fix platform-device leak in error path
Date:   Mon, 15 Aug 2022 19:53:17 +0200
Message-Id: <20220815180437.818621157@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 229e73d46994f15314f58b2d39bf952111d89193 ]

Make sure to free the platform device in the unlikely event that
registration fails.

Fixes: 7a67832c7e44 ("libnvdimm, e820: make CONFIG_X86_PMEM_LEGACY a tristate option")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220620140723.9810-1-johan@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/pmem.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pmem.c b/arch/x86/kernel/pmem.c
index 6b07faaa1579..23154d24b117 100644
--- a/arch/x86/kernel/pmem.c
+++ b/arch/x86/kernel/pmem.c
@@ -27,6 +27,11 @@ static __init int register_e820_pmem(void)
 	 * simply here to trigger the module to load on demand.
 	 */
 	pdev = platform_device_alloc("e820_pmem", -1);
-	return platform_device_add(pdev);
+
+	rc = platform_device_add(pdev);
+	if (rc)
+		platform_device_put(pdev);
+
+	return rc;
 }
 device_initcall(register_e820_pmem);
-- 
2.35.1



