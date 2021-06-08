Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589EF3A01CC
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbhFHS4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:56:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236493AbhFHSyY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:54:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B68A61438;
        Tue,  8 Jun 2021 18:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177680;
        bh=FTYYrV3cXZVmORehgHmEt8LBqyCBK2QvnCIq38jBZvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xbMnnyfgXlWftK9eg3cZpHNysolAHzwEpp0ilDabG8LVqr1skMo7WNcjWT22sgMns
         JLdO7srijIca41GLFDWlMe4l4l61Zo5Eacpw2/QHJ70B53VnZ3mGI45VUv/6vws5o6
         NMjHr0010u1A/SRzWMnaZd0/Y6kpY24w+/55K4Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/137] optee: use export_uuid() to copy client UUID
Date:   Tue,  8 Jun 2021 20:26:40 +0200
Message-Id: <20210608175944.404659515@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Wiklander <jens.wiklander@linaro.org>

[ Upstream commit 673c7aa2436bfc857b92417f3e590a297c586dde ]

Prior to this patch optee_open_session() was making assumptions about
the internal format of uuid_t by casting a memory location in a
parameter struct to uuid_t *. Fix this using export_uuid() to get a well
defined binary representation and also add an octets field in struct
optee_msg_param in order to avoid casting.

Fixes: c5b4312bea5d ("tee: optee: Add support for session login client UUID generation")
Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/call.c      | 6 ++++--
 drivers/tee/optee/optee_msg.h | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index 780d7c4fd756..0790de29f0ca 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -217,6 +217,7 @@ int optee_open_session(struct tee_context *ctx,
 	struct optee_msg_arg *msg_arg;
 	phys_addr_t msg_parg;
 	struct optee_session *sess = NULL;
+	uuid_t client_uuid;
 
 	/* +2 for the meta parameters added below */
 	shm = get_msg_arg(ctx, arg->num_params + 2, &msg_arg, &msg_parg);
@@ -237,10 +238,11 @@ int optee_open_session(struct tee_context *ctx,
 	memcpy(&msg_arg->params[0].u.value, arg->uuid, sizeof(arg->uuid));
 	msg_arg->params[1].u.value.c = arg->clnt_login;
 
-	rc = tee_session_calc_client_uuid((uuid_t *)&msg_arg->params[1].u.value,
-					  arg->clnt_login, arg->clnt_uuid);
+	rc = tee_session_calc_client_uuid(&client_uuid, arg->clnt_login,
+					  arg->clnt_uuid);
 	if (rc)
 		goto out;
+	export_uuid(msg_arg->params[1].u.octets, &client_uuid);
 
 	rc = optee_to_msg_param(msg_arg->params + 2, arg->num_params, param);
 	if (rc)
diff --git a/drivers/tee/optee/optee_msg.h b/drivers/tee/optee/optee_msg.h
index 7b2d919da2ac..c7ac7d02d6cc 100644
--- a/drivers/tee/optee/optee_msg.h
+++ b/drivers/tee/optee/optee_msg.h
@@ -9,7 +9,7 @@
 #include <linux/types.h>
 
 /*
- * This file defines the OP-TEE message protocol used to communicate
+ * This file defines the OP-TEE message protocol (ABI) used to communicate
  * with an instance of OP-TEE running in secure world.
  *
  * This file is divided into three sections.
@@ -146,9 +146,10 @@ struct optee_msg_param_value {
  * @tmem:	parameter by temporary memory reference
  * @rmem:	parameter by registered memory reference
  * @value:	parameter by opaque value
+ * @octets:	parameter by octet string
  *
  * @attr & OPTEE_MSG_ATTR_TYPE_MASK indicates if tmem, rmem or value is used in
- * the union. OPTEE_MSG_ATTR_TYPE_VALUE_* indicates value,
+ * the union. OPTEE_MSG_ATTR_TYPE_VALUE_* indicates value or octets,
  * OPTEE_MSG_ATTR_TYPE_TMEM_* indicates @tmem and
  * OPTEE_MSG_ATTR_TYPE_RMEM_* indicates @rmem,
  * OPTEE_MSG_ATTR_TYPE_NONE indicates that none of the members are used.
@@ -159,6 +160,7 @@ struct optee_msg_param {
 		struct optee_msg_param_tmem tmem;
 		struct optee_msg_param_rmem rmem;
 		struct optee_msg_param_value value;
+		u8 octets[24];
 	} u;
 };
 
-- 
2.30.2



