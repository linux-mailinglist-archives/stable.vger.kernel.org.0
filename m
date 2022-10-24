Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFD260AA24
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbiJXNbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbiJXN2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:28:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BEBFABD7A;
        Mon, 24 Oct 2022 05:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D4C361330;
        Mon, 24 Oct 2022 12:32:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B13A4C433D6;
        Mon, 24 Oct 2022 12:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614728;
        bh=AkOcEHZmdaA81I6y7tbCcNTRyBxYzqfv88yAdxAyoJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dI6qICXFkzJKTaSQG0aFj5GUsculEWYO+g6X4mJuShMifMczjFBzfBe4Szb6zl5+Q
         BpEzW3aAc9Pw10Q9Y6UHwmpHRyNJFu53Ag7Yv7B04rFYoSdVZsMkxzOw5+xbQG10ev
         O1Vr75zesvztqhX5HG/p+zBCP36OWC5DLwiM5yDI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 371/390] staging: rtl8723bs: fix a potential memory leak in rtw_init_cmd_priv()
Date:   Mon, 24 Oct 2022 13:32:48 +0200
Message-Id: <20221024113038.819163549@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit 708056fba733a73d926772ea4ce9a42d240345da ]

In rtw_init_cmd_priv(), if `pcmdpriv->rsp_allocated_buf` is allocated
in failure, then `pcmdpriv->cmd_allocated_buf` will be not properly
released. Besides, considering there are only two error paths and the
first one can directly return, so we do not need implicitly jump to the
`exit` tag to execute the error handler.

So this patch added `kfree(pcmdpriv->cmd_allocated_buf);` on the error
path to release the resource and simplified the return logic of
rtw_init_cmd_priv(). As there is no proper device to test with, no runtime
testing was performed.

Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Link: https://lore.kernel.org/r/tencent_2B7931B79BA38E22205C5A09EFDF11E48805@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_cmd.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_cmd.c b/drivers/staging/rtl8723bs/core/rtw_cmd.c
index 2abe205e3453..cee05385f872 100644
--- a/drivers/staging/rtl8723bs/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723bs/core/rtw_cmd.c
@@ -165,8 +165,6 @@ No irqsave is necessary.
 
 int rtw_init_cmd_priv(struct	cmd_priv *pcmdpriv)
 {
-	int res = 0;
-
 	init_completion(&pcmdpriv->cmd_queue_comp);
 	init_completion(&pcmdpriv->terminate_cmdthread_comp);
 
@@ -178,18 +176,16 @@ int rtw_init_cmd_priv(struct	cmd_priv *pcmdpriv)
 
 	pcmdpriv->cmd_allocated_buf = rtw_zmalloc(MAX_CMDSZ + CMDBUFF_ALIGN_SZ);
 
-	if (!pcmdpriv->cmd_allocated_buf) {
-		res = -ENOMEM;
-		goto exit;
-	}
+	if (!pcmdpriv->cmd_allocated_buf)
+		return -ENOMEM;
 
 	pcmdpriv->cmd_buf = pcmdpriv->cmd_allocated_buf  +  CMDBUFF_ALIGN_SZ - ((SIZE_PTR)(pcmdpriv->cmd_allocated_buf) & (CMDBUFF_ALIGN_SZ-1));
 
 	pcmdpriv->rsp_allocated_buf = rtw_zmalloc(MAX_RSPSZ + 4);
 
 	if (!pcmdpriv->rsp_allocated_buf) {
-		res = -ENOMEM;
-		goto exit;
+		kfree(pcmdpriv->cmd_allocated_buf);
+		return -ENOMEM;
 	}
 
 	pcmdpriv->rsp_buf = pcmdpriv->rsp_allocated_buf  +  4 - ((SIZE_PTR)(pcmdpriv->rsp_allocated_buf) & 3);
@@ -199,8 +195,8 @@ int rtw_init_cmd_priv(struct	cmd_priv *pcmdpriv)
 	pcmdpriv->rsp_cnt = 0;
 
 	mutex_init(&pcmdpriv->sctx_mutex);
-exit:
-	return res;
+
+	return 0;
 }
 
 static void c2h_wk_callback(_workitem * work);
-- 
2.35.1



