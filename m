Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FB153826B
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239015AbiE3OXj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240596AbiE3OT4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:19:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 527491248F1;
        Mon, 30 May 2022 06:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C60660FFA;
        Mon, 30 May 2022 13:48:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E7BC341C0;
        Mon, 30 May 2022 13:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918522;
        bh=3wuBoO78M/jyBi9wiMoupv9Wxz2G3NRlkB+0uX6BVHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FbIyUb2ktqXgQe5uU0i9KXW3Wrf0CuXwRNcGVKsftzfTunI/OrcwACjH9rz5+T9pr
         zWta4/tzh/gfCmV+D1WqjUArTTftRja9I6dDyaivPThexVvKaNK670V+ZSE9JTQsYe
         Dv68EglaZxgLHxXP/pWvCyfIAkNY0T5RMdA7BgY+FGvgMU1iTk9+U6D2mo/40CBAb6
         cj+Y0IuwSX/awv3mZOMbyADSkU5OBdSocABsNU1B9iUqV4WCTcREkRGARsMIScLhQn
         X2n/IzTYocAV3hSrX+tshyj6O2499B+xR2MiSSHG5qq0m8jiwb0srZGrKDVDEeJ7ri
         2PFRTZE1wdtyA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.4 40/55] ipmi: Fix pr_fmt to avoid compilation issues
Date:   Mon, 30 May 2022 09:46:46 -0400
Message-Id: <20220530134701.1935933-40-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530134701.1935933-1-sashal@kernel.org>
References: <20220530134701.1935933-1-sashal@kernel.org>
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
index ad2e6d55d4a5..736970312bbc 100644
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

