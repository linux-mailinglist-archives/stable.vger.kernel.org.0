Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D274E4F7114
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 03:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbiDGBVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 21:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238571AbiDGBSX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 21:18:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C871834E1;
        Wed,  6 Apr 2022 18:13:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA236B81E79;
        Thu,  7 Apr 2022 01:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C915C385A6;
        Thu,  7 Apr 2022 01:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649293990;
        bh=JGTxfCZOOghgkyjf3BWnR1x9TbNLIoiVYqZlPvou4Fk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzOWhxMLyFvUmbiJTj48idLWMvvcpHQrcosYSwu6+8vuozeXgxVp36Y7z94WLBSH/
         4z9dkeR58BNQgFHhOqaL9izpAxtYfjyQTsos5Qn6VrN7EzwbRxDsIDccuaN5XwGQAc
         kchvCMWiOAVFVHRtMc94Ms6CY0wuirufkBL8qcogpQQU4zPm5G1paOsqZhXUDJBTAR
         GbztCJwhS4XjUB34L+XytqY63nIegvBRpIKzyTHPHSeDr4/g5SakHfuwDLDAqcBkdg
         oklJrYJ3i4V2W2ncbPihUsiNXFSodwA6VoXfMQlB8vckVBPhQbZbqO4Hr49EssY6tZ
         mTaWk1DZWDdrA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Glenn Washburn <development@efficientek.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>,
        anton.ivanov@cambridgegreys.com, johannes@sipsolutions.net,
        linux-um@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 05/27] um: port_user: Improve error handling when port-helper is not found
Date:   Wed,  6 Apr 2022 21:12:35 -0400
Message-Id: <20220407011257.114287-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220407011257.114287-1-sashal@kernel.org>
References: <20220407011257.114287-1-sashal@kernel.org>
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
index 5b5b64cb1071..133ca7bf2d91 100644
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

