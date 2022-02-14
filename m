Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD364B4984
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347443AbiBNKaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:30:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347119AbiBNKaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:30:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCD36A387;
        Mon, 14 Feb 2022 01:58:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 485A6B80DC4;
        Mon, 14 Feb 2022 09:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2F3C340F1;
        Mon, 14 Feb 2022 09:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832709;
        bh=etpHd9/WD9Ys2NjYn1EXaPPAzL/S6ZAhPd+Me0wtatU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToFwx3Yd3VELAgJfrIi4XR+x9QUPhY/7Yu+3TeOYcoVcyMaKSnqRddWGe4uOSMpIb
         N3GgRPuwxaFXnAtXUgiFfNLj63dpVs4a6RbXhw7C18xqJvE8uVojXMMHtLDLU9V69q
         PrWiVTP4tTOnkwVq/YzZHMuFrn8yt5c6o2wqVMHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 099/203] optee: add error checks in optee_ffa_do_call_with_arg()
Date:   Mon, 14 Feb 2022 10:25:43 +0100
Message-Id: <20220214092513.620430662@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Wiklander <jens.wiklander@linaro.org>

[ Upstream commit 4064c461148ab129dfe5eaeea129b4af6cf4b9b7 ]

Adds error checking in optee_ffa_do_call_with_arg() for correctness.

Fixes: 4615e5a34b95 ("optee: add FF-A support")
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/ffa_abi.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/tee/optee/ffa_abi.c b/drivers/tee/optee/ffa_abi.c
index d8c8683863aa0..28d7c0eafc025 100644
--- a/drivers/tee/optee/ffa_abi.c
+++ b/drivers/tee/optee/ffa_abi.c
@@ -619,9 +619,18 @@ static int optee_ffa_do_call_with_arg(struct tee_context *ctx,
 		.data2 = (u32)(shm->sec_world_id >> 32),
 		.data3 = shm->offset,
 	};
-	struct optee_msg_arg *arg = tee_shm_get_va(shm, 0);
-	unsigned int rpc_arg_offs = OPTEE_MSG_GET_ARG_SIZE(arg->num_params);
-	struct optee_msg_arg *rpc_arg = tee_shm_get_va(shm, rpc_arg_offs);
+	struct optee_msg_arg *arg;
+	unsigned int rpc_arg_offs;
+	struct optee_msg_arg *rpc_arg;
+
+	arg = tee_shm_get_va(shm, 0);
+	if (IS_ERR(arg))
+		return PTR_ERR(arg);
+
+	rpc_arg_offs = OPTEE_MSG_GET_ARG_SIZE(arg->num_params);
+	rpc_arg = tee_shm_get_va(shm, rpc_arg_offs);
+	if (IS_ERR(rpc_arg))
+		return PTR_ERR(rpc_arg);
 
 	return optee_ffa_yielding_call(ctx, &data, rpc_arg);
 }
-- 
2.34.1



