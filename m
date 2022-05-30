Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC095380B9
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239472AbiE3OJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 10:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240231AbiE3OGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 10:06:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605D540A3C;
        Mon, 30 May 2022 06:42:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E2AF60FC6;
        Mon, 30 May 2022 13:42:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204A9C3411A;
        Mon, 30 May 2022 13:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653918125;
        bh=91YafTY4rpyJMzqIXxTsoWBBfWiA6zSqMttXHOP6uKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvuXn8E7Tz7ykH116+HzfWWOg2vAUyb3zFnUQu+jY0h35fsxcfVWoUTZKa5gMF1ef
         VLeaADMQUxzOoDUF2CxXsrkID7CPtOMbUl/EMjso5cR9oBBB6zhP8BTuxMtACP6w7J
         QNynQsgUJtciFAmshKkPZigpd/hxPalfur2xMQjoc5UEiRfCQ1XfEqlwR1BfCRSIY/
         3KfUmzLrNZyA9BuFpre7cfSZAU2SCIBQDgzPm2W1Q2b6DUeNEyyFb6foNB4JBrCFKG
         qBkr1v8nMiRk2I2Nb5rbzIOkN/QB/6fuyDPz02/bTcJ1bIuFz/o7l3aMkV1bfYcyP7
         DF4410cF9sEvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>,
        kernel test robot <lkp@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.15 072/109] ipmi: Fix pr_fmt to avoid compilation issues
Date:   Mon, 30 May 2022 09:37:48 -0400
Message-Id: <20220530133825.1933431-72-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
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
index fe91090e04a4..2badf36d4816 100644
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

