Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F59659D839
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351102AbiHWJfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351101AbiHWJeR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:34:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813A894ECE;
        Tue, 23 Aug 2022 01:39:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3675B81C3B;
        Tue, 23 Aug 2022 08:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD66C433D6;
        Tue, 23 Aug 2022 08:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661243887;
        bh=g6tcTm+ZXaW5n+EYtlo3JwpzKEML7hs46wOKet194ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUFv40MF63nsxFRV3N/qJm5dLRGChB0kF0h6ZdMN+YH5l76zeHNfwO83XguW/t0x+
         cn0RdeyPdABot0QY5D2W9yA4bWp/D7D/ZYGGDXM5OYBue+AyBwaAaYgooABjf9AbzL
         /tu2RDk4SoFwx0C+hQlHonPidbOKn5xwmKZXye7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 051/229] x86/pmem: Fix platform-device leak in error path
Date:   Tue, 23 Aug 2022 10:23:32 +0200
Message-Id: <20220823080055.531533153@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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
index 3fe690067802..ada7c077ec2f 100644
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



