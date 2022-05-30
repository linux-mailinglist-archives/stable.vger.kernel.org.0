Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36D195381C7
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:33:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241149AbiE3OVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241387AbiE3ORd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:17:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929CF8DDFA;
        Mon, 30 May 2022 06:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 485C6B80DA8;
        Mon, 30 May 2022 13:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D1FC3411C;
        Mon, 30 May 2022 13:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918362;
        bh=NJw/Da0vXMhBNgmTxMYq7qrM55Vi2LB9o0Wk6RJm0rM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=udRAifdRHt38UMtXldlzLkXFZbZL2YbKpxqgNw9jLNcAd1s+1moWKIjycQLs/5VWv
         cOCRpWU6YVfw9jZ1tA6NUVdT6LdN+DQ+p2LqCBKzozyaU2suGhasZwvkcdt982C927
         4jQucwqJXSHhsqlr4rBC/zQPZLSYhyZPAa9oasgp8/GtKEkXlqXPWmsFkwQ5hg/xlL
         WlfVeR/T6SbzGjy9rs2fMklyRbVBYuFNFY/EQEO76r+29HBRDSRjdkb50v9RLEZul0
         Jv4b8otapgJWc2s6myri8ZKnXs456hZE0OBN52HcPC6VlyacK6UxIl7XzpRbp65p7m
         bkuf48da8gl5A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.10 53/76] ipmi: Fix pr_fmt to avoid compilation issues
Date:   Mon, 30 May 2022 09:43:43 -0400
Message-Id: <20220530134406.1934928-53-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134406.1934928-1-sashal@kernel.org>
References: <20220530134406.1934928-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

[ Upstream commit 2ebaf18a0b7fb764bba6c806af99fe868cee93de ]

The was it was wouldn't work in some situations, simplify it.  What was
there was unnecessary complexity.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_msghandler.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 8f147274f826..05e7339752ac 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -11,8 +11,8 @@
  * Copyright 2002 MontaVista Software Inc.
  */
 
-#define pr_fmt(fmt) "%s" fmt, "IPMI message handler: "
-#define dev_fmt pr_fmt
+#define pr_fmt(fmt) "IPMI message handler: " fmt
+#define dev_fmt(fmt) pr_fmt(fmt)
 
 #include <linux/module.h>
 #include <linux/errno.h>
-- 
2.35.1

