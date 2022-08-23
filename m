Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECF959E026
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348628AbiHWLdY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357317AbiHWLbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFC58F956;
        Tue, 23 Aug 2022 02:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C3D9612B5;
        Tue, 23 Aug 2022 09:25:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330BDC433C1;
        Tue, 23 Aug 2022 09:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246734;
        bh=YcBMqvhV+F0IBf4JpO7+0HnjAx/i8V8xOh8U7HuEtzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1CWgHwdHRwdDUpKRqdvVNJCdotxws6wnR3cpZe6GjYbLaT2j4R826ZIUj31/7Dqtw
         pEwvAJiWOIOyoZAMJHmODimk3P8f6k6ycbHn92zGBlHiEPoJ6Ta+270IAjSJyIQTHF
         x/q5+s089P/OTUSPki8AJAcixn9l3mB4NznDNc8E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 195/389] platform/olpc: Fix uninitialized data in debugfs write
Date:   Tue, 23 Aug 2022 10:24:33 +0200
Message-Id: <20220823080123.780375921@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 40ec787e1adf302c11668d4cc69838f4d584187d ]

The call to:

	size = simple_write_to_buffer(cmdbuf, sizeof(cmdbuf), ppos, buf, size);

will succeed if at least one byte is written to the "cmdbuf" buffer.
The "*ppos" value controls which byte is written.  Another problem is
that this code does not check for errors so it's possible for the entire
buffer to be uninitialized.

Inintialize the struct to zero to prevent reading uninitialized stack
data.

Debugfs is normally only writable by root so the impact of this bug is
very minimal.

Fixes: 6cca83d498bd ("Platform: OLPC: move debugfs support from x86 EC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/YthIKn+TfZSZMEcM@kili
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/olpc/olpc-ec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/olpc/olpc-ec.c b/drivers/platform/olpc/olpc-ec.c
index 2db7113383fd..89d9fca02fe9 100644
--- a/drivers/platform/olpc/olpc-ec.c
+++ b/drivers/platform/olpc/olpc-ec.c
@@ -265,7 +265,7 @@ static ssize_t ec_dbgfs_cmd_write(struct file *file, const char __user *buf,
 	int i, m;
 	unsigned char ec_cmd[EC_MAX_CMD_ARGS];
 	unsigned int ec_cmd_int[EC_MAX_CMD_ARGS];
-	char cmdbuf[64];
+	char cmdbuf[64] = "";
 	int ec_cmd_bytes;
 
 	mutex_lock(&ec_dbgfs_lock);
-- 
2.35.1



