Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E264F70D4
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbiDGBWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240492AbiDGBUC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C6321835;
        Wed,  6 Apr 2022 18:17:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33EC761DEA;
        Thu,  7 Apr 2022 01:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A6BC385A6;
        Thu,  7 Apr 2022 01:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649294240;
        bh=/9/EoeSHUACmbJ7HvXHZB554Rh0bzWIVC1Sfe8QGiZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejSoowQ+CFdlGrhAAs2YIJhD2sX69LBRKyUT83EWbXX4AsUcVavauM3/8HN40Ezsd
         IjYuU1OiGRBS3EKik9PFlmnkzLW8sHw/d/MdzLfpVGacgy45LWqkFP8QZTWQ4oXHNS
         VeaZ1u0xIsuRlCcuyogOVjcJwknVctlmTLFPkSrLH7o9ozCIr0rumk6dXYXIwZGC/R
         jR1APIVnDY47Xe7gNjmp/bc1blDh0eIc7l7wJGbC69+bwekdBPdTdhImJldKljixIo
         htZZAW8UxheopLqRcg9l8TtPYp5dsIGmO5apt9u1HYChi8bt8BVEwXGGXPas2QXXLn
         CH+PB5aICjg+Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Glenn Washburn <development@efficientek.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>,
        anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
        linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 3/8] um: port_user: Improve error handling when port-helper is not found
Date:   Wed,  6 Apr 2022 21:16:40 -0400
Message-Id: <20220407011645.115412-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011645.115412-1-sashal@kernel.org>
References: <20220407011645.115412-1-sashal@kernel.org>
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

From: Glenn Washburn <development@efficientek.com>

[ Upstream commit 3cb5a7f167c620a8b0e38b0446df2e024d2243dc ]

Check if port-helper exists and is executable. If not, write an error
message to the kernel log with information to help the user diagnose the
issue and exit with an error. If UML_PORT_HELPER was not set, write a
message suggesting that the user set it. This makes it easier to understand
why telneting to the UML instance is failing and what can be done to fix it.

Signed-off-by: Glenn Washburn <development@efficientek.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/port_user.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/um/drivers/port_user.c b/arch/um/drivers/port_user.c
index 9a8e1b64c22e..d3cf5db1350a 100644
--- a/arch/um/drivers/port_user.c
+++ b/arch/um/drivers/port_user.c
@@ -5,6 +5,7 @@
 
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
 #include <errno.h>
 #include <termios.h>
 #include <unistd.h>
@@ -175,6 +176,17 @@ int port_connection(int fd, int *socket, int *pid_out)
 	if (new < 0)
 		return -errno;
 
+	err = os_access(argv[2], X_OK);
+	if (err < 0) {
+		printk(UM_KERN_ERR "port_connection : error accessing port-helper "
+		       "executable at %s: %s\n", argv[2], strerror(-err));
+		if (env == NULL)
+			printk(UM_KERN_ERR "Set UML_PORT_HELPER environment "
+				"variable to path to uml-utilities port-helper "
+				"binary\n");
+		goto out_close;
+	}
+
 	err = os_pipe(socket, 0, 0);
 	if (err < 0)
 		goto out_close;
-- 
2.35.1

