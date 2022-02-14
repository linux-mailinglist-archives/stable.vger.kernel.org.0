Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77C544B4A37
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345549AbiBNK3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:29:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347288AbiBNK1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:27:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82FA9680F;
        Mon, 14 Feb 2022 01:58:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B969B60909;
        Mon, 14 Feb 2022 09:58:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FE1C340E9;
        Mon, 14 Feb 2022 09:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832705;
        bh=EUxFAa0UKKcWMvF6DQFzzmdf+4g4HZ2M/fu4aqrh+Nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AaAnS09L4FNCAcVAzK8WujCouUHr7465fgiN6thBMQsjl2IIIUaG86pfBGQszWjYc
         uN5YC3WKEIZmtMO7MH+R3ZA+s9OnjuXX9glq810aCOFPLbWbYpgUDF8twd5ixvBnSf
         2rTmUrd6Gm1eLW/Y365r0JPLF8AmOeQde/qonUXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Forissier <jerome@forissier.org>,
        Sumit Garg <sumit.garg@linaro.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 098/203] tee: optee: do not check memref size on return from Secure World
Date:   Mon, 14 Feb 2022 10:25:42 +0100
Message-Id: <20220214092513.587308135@linuxfoundation.org>
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

From: Jerome Forissier <jerome@forissier.org>

[ Upstream commit abc8dc34d1f6e34ed346c6e3fc554127e421b769 ]

Commit c650b8dc7a79 ("tee: optee: do not check memref size on return
from Secure World") was mistakenly lost in commit 4602c5842f64 ("optee:
refactor driver with internal callbacks"). Remove the unwanted code
again.

Fixes: 4602c5842f64 ("optee: refactor driver with internal callbacks")
Signed-off-by: Jerome Forissier <jerome@forissier.org>
Reviewed-by: Sumit Garg <sumit.garg@linaro.org>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/optee/smc_abi.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/tee/optee/smc_abi.c b/drivers/tee/optee/smc_abi.c
index cf2e3293567d9..09e7ec673bb6b 100644
--- a/drivers/tee/optee/smc_abi.c
+++ b/drivers/tee/optee/smc_abi.c
@@ -71,16 +71,6 @@ static int from_msg_param_tmp_mem(struct tee_param *p, u32 attr,
 	p->u.memref.shm_offs = mp->u.tmem.buf_ptr - pa;
 	p->u.memref.shm = shm;
 
-	/* Check that the memref is covered by the shm object */
-	if (p->u.memref.size) {
-		size_t o = p->u.memref.shm_offs +
-			   p->u.memref.size - 1;
-
-		rc = tee_shm_get_pa(shm, o, NULL);
-		if (rc)
-			return rc;
-	}
-
 	return 0;
 }
 
-- 
2.34.1



