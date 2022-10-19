Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C03B60408D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232492AbiJSKE3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234507AbiJSKEA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:04:00 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22996254;
        Wed, 19 Oct 2022 02:42:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1FC44CE21C5;
        Wed, 19 Oct 2022 09:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF8AC433D6;
        Wed, 19 Oct 2022 09:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170887;
        bh=lDR61PbfI7H5eQX4Ti6CnNOBp3xkPZ74M3x0TE5CuNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wfKpETbz7tWxeZvVao5VF3EXT4YvGD5DbtsMwIpkVLF6Nx5ZOrSxvWc6aVvGpXIF
         T6Of2oIWncFfGr1BjNy33+zFqyMVLtNTgWK5cB9CHPhgQ92X4HZsOCWeB6TSHPOWn4
         WDwUlC1ulf4cKw0GRqR48sZzPtv32J1aw31ru0VQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoke Wang <xkernel.wang@foxmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 825/862] staging: rtl8723bs: fix a potential memory leak in rtw_init_cmd_priv()
Date:   Wed, 19 Oct 2022 10:35:12 +0200
Message-Id: <20221019083326.363842288@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index b4170f64d118..03c2c66dbf66 100644
--- a/drivers/staging/rtl8723bs/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723bs/core/rtw_cmd.c
@@ -161,8 +161,6 @@ static struct cmd_hdl wlancmds[] = {
 
 int rtw_init_cmd_priv(struct	cmd_priv *pcmdpriv)
 {
-	int res = 0;
-
 	init_completion(&pcmdpriv->cmd_queue_comp);
 	init_completion(&pcmdpriv->terminate_cmdthread_comp);
 
@@ -175,18 +173,16 @@ int rtw_init_cmd_priv(struct	cmd_priv *pcmdpriv)
 
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
@@ -196,8 +192,8 @@ int rtw_init_cmd_priv(struct	cmd_priv *pcmdpriv)
 	pcmdpriv->rsp_cnt = 0;
 
 	mutex_init(&pcmdpriv->sctx_mutex);
-exit:
-	return res;
+
+	return 0;
 }
 
 static void c2h_wk_callback(struct work_struct *work);
-- 
2.35.1



