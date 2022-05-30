Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D78B537EB5
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238395AbiE3NxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239288AbiE3NvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:51:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE1C84A04;
        Mon, 30 May 2022 06:35:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3879D60F2A;
        Mon, 30 May 2022 13:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7769C3411A;
        Mon, 30 May 2022 13:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917754;
        bh=ANvR0+X6vi8dluHkHYvQMoS88/nWD+GMOygl+QCxWBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwgylZ1lajL2sq8le71q15RZ4NcJ/grNQBQ3D5IRyAYM9l/t4WTQZo4AOYfAn9mFZ
         CgqEwH6eU8trCs286HR+w/AMdSR67K1jd7PMUjJWg5dgQI7xLxX9PYevGUSlr+3EuA
         W21zNlZr3Lf+3hAGScVPNJV5WbgeZePgobpjzXjCrGYZyQqnLux5z57A173jZ4yBUT
         ZM3U5p1cIJeRiLNE3CW/iOPOqlWa2BqRb1xUrZVDl511KkbgkEwEb1iqH2LISJEXBE
         T9nDwH5501nTFcgiCWh3E85MEV/zflEg9Q7OPuJ0ftyvpUW5+90RArwiQIFU33kACi
         yB/uN0MR3C+qw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Corey Minyard <cminyard@mvista.com>,
        Joe Wiese <jwiese@rackspace.com>,
        Sasha Levin <sashal@kernel.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.17 087/135] ipmi: Add an intializer for ipmi_smi_msg struct
Date:   Mon, 30 May 2022 09:30:45 -0400
Message-Id: <20220530133133.1931716-87-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
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

[ Upstream commit 9824117dd964ecebf5d81990dbf21dfb56445049 ]

There was a "type" element added to this structure, but some static
values were missed.  The default value will be zero, which is correct,
but create an initializer for the type and initialize the type properly
in the initializer to avoid future issues.

Reported-by: Joe Wiese <jwiese@rackspace.com>
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ipmi/ipmi_poweroff.c |  4 +---
 drivers/char/ipmi/ipmi_watchdog.c | 14 +++++---------
 include/linux/ipmi_smi.h          |  6 ++++++
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
index bc3a18daf97a..62e71c46ac5f 100644
--- a/drivers/char/ipmi/ipmi_poweroff.c
+++ b/drivers/char/ipmi/ipmi_poweroff.c
@@ -94,9 +94,7 @@ static void dummy_recv_free(struct ipmi_recv_msg *msg)
 {
 	atomic_dec(&dummy_count);
 }
-static struct ipmi_smi_msg halt_smi_msg = {
-	.done = dummy_smi_free
-};
+static struct ipmi_smi_msg halt_smi_msg = INIT_IPMI_SMI_MSG(dummy_smi_free);
 static struct ipmi_recv_msg halt_recv_msg = {
 	.done = dummy_recv_free
 };
diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
index 883b4a341012..8e536ce0a5d2 100644
--- a/drivers/char/ipmi/ipmi_watchdog.c
+++ b/drivers/char/ipmi/ipmi_watchdog.c
@@ -354,9 +354,7 @@ static void msg_free_recv(struct ipmi_recv_msg *msg)
 			complete(&msg_wait);
 	}
 }
-static struct ipmi_smi_msg smi_msg = {
-	.done = msg_free_smi
-};
+static struct ipmi_smi_msg smi_msg = INIT_IPMI_SMI_MSG(msg_free_smi);
 static struct ipmi_recv_msg recv_msg = {
 	.done = msg_free_recv
 };
@@ -475,9 +473,8 @@ static void panic_recv_free(struct ipmi_recv_msg *msg)
 	atomic_dec(&panic_done_count);
 }
 
-static struct ipmi_smi_msg panic_halt_heartbeat_smi_msg = {
-	.done = panic_smi_free
-};
+static struct ipmi_smi_msg panic_halt_heartbeat_smi_msg =
+	INIT_IPMI_SMI_MSG(panic_smi_free);
 static struct ipmi_recv_msg panic_halt_heartbeat_recv_msg = {
 	.done = panic_recv_free
 };
@@ -516,9 +513,8 @@ static void panic_halt_ipmi_heartbeat(void)
 		atomic_sub(2, &panic_done_count);
 }
 
-static struct ipmi_smi_msg panic_halt_smi_msg = {
-	.done = panic_smi_free
-};
+static struct ipmi_smi_msg panic_halt_smi_msg =
+	INIT_IPMI_SMI_MSG(panic_smi_free);
 static struct ipmi_recv_msg panic_halt_recv_msg = {
 	.done = panic_recv_free
 };
diff --git a/include/linux/ipmi_smi.h b/include/linux/ipmi_smi.h
index 9277d21c2690..5d69820d8b02 100644
--- a/include/linux/ipmi_smi.h
+++ b/include/linux/ipmi_smi.h
@@ -125,6 +125,12 @@ struct ipmi_smi_msg {
 	void (*done)(struct ipmi_smi_msg *msg);
 };
 
+#define INIT_IPMI_SMI_MSG(done_handler) \
+{						\
+	.done = done_handler,			\
+	.type = IPMI_SMI_MSG_TYPE_NORMAL	\
+}
+
 struct ipmi_smi_handlers {
 	struct module *owner;
 
-- 
2.35.1

