Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C463A328CAC
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbhCAS45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:56:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:57718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240395AbhCASvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:51:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBFD865166;
        Mon,  1 Mar 2021 17:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618417;
        bh=0hy/Litt/zTFvA1HJE9o6wOGall1zdTH4sHAIwi4Wjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=af4zszYDrOzQkrdqoUSH7mQg0Q/6EHZcRY+M7Z90sASSNS+xdKu2JPjgcDbKlUvMb
         1rM/C4LrdVvqcORI9fdveWlJhh30kJPt1pUBi8XSmmrCt9mrMAbPgtoAhA4le/d4vz
         04UdvJGV2muZSygi7X4cicbkow+/85pWhhMPDVik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jorge Ramirez-Ortiz <jorge@foundries.io>,
        Arnd Bergmann <arnd@arndb.de>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/663] optee: simplify i2c access
Date:   Mon,  1 Mar 2021 17:05:28 +0100
Message-Id: <20210301161145.693534566@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 67bc809752796acb2641ca343cad5b45eef31d7c ]

Storing a bogus i2c_client structure on the stack adds overhead and
causes a compile-time warning:

drivers/tee/optee/rpc.c:493:6: error: stack frame size of 1056 bytes in function 'optee_handle_rpc' [-Werror,-Wframe-larger-than=]
void optee_handle_rpc(struct tee_context *ctx, struct optee_rpc_param *param,

Change the implementation of handle_rpc_func_cmd_i2c_transfer() to
open-code the i2c_transfer() call, which makes it easier to read
and avoids the warning.

Fixes: c05210ab9757 ("drivers: optee: allow op-tee to access devices on the i2c bus")
Tested-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/rpc.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/tee/optee/rpc.c b/drivers/tee/optee/rpc.c
index 1e3614e4798f0..6cbb3643c6c48 100644
--- a/drivers/tee/optee/rpc.c
+++ b/drivers/tee/optee/rpc.c
@@ -54,8 +54,9 @@ bad:
 static void handle_rpc_func_cmd_i2c_transfer(struct tee_context *ctx,
 					     struct optee_msg_arg *arg)
 {
-	struct i2c_client client = { 0 };
 	struct tee_param *params;
+	struct i2c_adapter *adapter;
+	struct i2c_msg msg = { };
 	size_t i;
 	int ret = -EOPNOTSUPP;
 	u8 attr[] = {
@@ -85,48 +86,48 @@ static void handle_rpc_func_cmd_i2c_transfer(struct tee_context *ctx,
 			goto bad;
 	}
 
-	client.adapter = i2c_get_adapter(params[0].u.value.b);
-	if (!client.adapter)
+	adapter = i2c_get_adapter(params[0].u.value.b);
+	if (!adapter)
 		goto bad;
 
 	if (params[1].u.value.a & OPTEE_MSG_RPC_CMD_I2C_FLAGS_TEN_BIT) {
-		if (!i2c_check_functionality(client.adapter,
+		if (!i2c_check_functionality(adapter,
 					     I2C_FUNC_10BIT_ADDR)) {
-			i2c_put_adapter(client.adapter);
+			i2c_put_adapter(adapter);
 			goto bad;
 		}
 
-		client.flags = I2C_CLIENT_TEN;
+		msg.flags = I2C_M_TEN;
 	}
 
-	client.addr = params[0].u.value.c;
-	snprintf(client.name, I2C_NAME_SIZE, "i2c%d", client.adapter->nr);
+	msg.addr = params[0].u.value.c;
+	msg.buf  = params[2].u.memref.shm->kaddr;
+	msg.len  = params[2].u.memref.size;
 
 	switch (params[0].u.value.a) {
 	case OPTEE_MSG_RPC_CMD_I2C_TRANSFER_RD:
-		ret = i2c_master_recv(&client, params[2].u.memref.shm->kaddr,
-				      params[2].u.memref.size);
+		msg.flags |= I2C_M_RD;
 		break;
 	case OPTEE_MSG_RPC_CMD_I2C_TRANSFER_WR:
-		ret = i2c_master_send(&client, params[2].u.memref.shm->kaddr,
-				      params[2].u.memref.size);
 		break;
 	default:
-		i2c_put_adapter(client.adapter);
+		i2c_put_adapter(adapter);
 		goto bad;
 	}
 
+	ret = i2c_transfer(adapter, &msg, 1);
+
 	if (ret < 0) {
 		arg->ret = TEEC_ERROR_COMMUNICATION;
 	} else {
-		params[3].u.value.a = ret;
+		params[3].u.value.a = msg.len;
 		if (optee_to_msg_param(arg->params, arg->num_params, params))
 			arg->ret = TEEC_ERROR_BAD_PARAMETERS;
 		else
 			arg->ret = TEEC_SUCCESS;
 	}
 
-	i2c_put_adapter(client.adapter);
+	i2c_put_adapter(adapter);
 	kfree(params);
 	return;
 bad:
-- 
2.27.0



