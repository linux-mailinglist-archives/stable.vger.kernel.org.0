Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C86B4D4999
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244246AbiCJOdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343920AbiCJOb3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB028E5402;
        Thu, 10 Mar 2022 06:28:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F956B82544;
        Thu, 10 Mar 2022 14:28:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA10DC340E8;
        Thu, 10 Mar 2022 14:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922504;
        bh=Lkj2JTmQcMmKZ3TgT9AHY0CjWLU1osFRNI2CLANMr0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzUoV5kUowogskLlHVf8IoKOnEitHL4ebv3Go6bTyTdgn/EJtx8m99aMbUqGUUDxu
         wKrrrO1cMWv2nCyX056PDWexz7kxPZ+ETFpTnl1ITL2qP1ZCYSX+rYAN6YS3Oc3tkX
         0FyjwDpSDJyBsGr2cxnr0jBRt9K7qNdD5tOW8PtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 21/33] ARM: fix build warning in proc-v7-bugs.c
Date:   Thu, 10 Mar 2022 15:19:22 +0100
Message-Id: <20220310140809.364340265@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
References: <20220310140808.741682643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

commit b1a384d2cbccb1eb3f84765020d25e2c1929706e upstream.

The kernel test robot discovered that building without
HARDEN_BRANCH_PREDICTOR issues a warning due to a missing
argument to pr_info().

Add the missing argument.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 9dd78194a372 ("ARM: report Spectre v2 status through sysfs")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mm/proc-v7-bugs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -109,7 +109,8 @@ static unsigned int spectre_v2_install_w
 #else
 static unsigned int spectre_v2_install_workaround(unsigned int method)
 {
-	pr_info("CPU%u: Spectre V2: workarounds disabled by configuration\n");
+	pr_info("CPU%u: Spectre V2: workarounds disabled by configuration\n",
+		smp_processor_id());
 
 	return SPECTRE_VULNERABLE;
 }


