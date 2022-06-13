Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A05A15489DE
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355786AbiFMM5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354986AbiFMMzM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:55:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374329FFF;
        Mon, 13 Jun 2022 04:15:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E61D1B80D31;
        Mon, 13 Jun 2022 11:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A105C34114;
        Mon, 13 Jun 2022 11:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118923;
        bh=aHzfA6oGqRNurQkGlWsaEsU5EAYtgpsc2v2fGQ8sZv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0pcMr7UMPFDMX7eTGckTCpMolWrRlNg3/PhdyzlEBIBkxlDRAGMc9AjEut2oYg9jg
         s/Fmwk4LNqIb6eG3gMq/tNWH8QFTZKIMmZl3JJbnGBI03PPeEHu9DNYPwU1/wBf9br
         326BrDYp1G3RM41L1PdEE/i6pAP2wSFuzY4SblW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/247] staging: r8188eu: add check for kzalloc
Date:   Mon, 13 Jun 2022 12:09:11 +0200
Message-Id: <20220613094924.439178209@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit f94b47c6bde624d6c07f43054087607c52054a95 ]

As kzalloc() may return null pointer, it should be better to
check the return value and return error if fails in order
to avoid dereference of null pointer.
Moreover, the return value of rtw_alloc_hwxmits() should also
be dealt with.

Fixes: 15865124feed ("staging: r8188eu: introduce new core dir for RTL8188eu driver")
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Link: https://lore.kernel.org/r/20220518075957.514603-1-jiasheng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/r8188eu/core/rtw_xmit.c    | 13 +++++++++++--
 drivers/staging/r8188eu/include/rtw_xmit.h |  2 +-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/r8188eu/core/rtw_xmit.c b/drivers/staging/r8188eu/core/rtw_xmit.c
index 46fe62c7c32c..0ee4f88a60d4 100644
--- a/drivers/staging/r8188eu/core/rtw_xmit.c
+++ b/drivers/staging/r8188eu/core/rtw_xmit.c
@@ -179,7 +179,12 @@ s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 
 	pxmitpriv->free_xmit_extbuf_cnt = num_xmit_extbuf;
 
-	rtw_alloc_hwxmits(padapter);
+	res = rtw_alloc_hwxmits(padapter);
+	if (res) {
+		res = _FAIL;
+		goto exit;
+	}
+
 	rtw_init_hwxmits(pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);
 
 	for (i = 0; i < 4; i++)
@@ -1516,7 +1521,7 @@ s32 rtw_xmit_classifier(struct adapter *padapter, struct xmit_frame *pxmitframe)
 	return res;
 }
 
-void rtw_alloc_hwxmits(struct adapter *padapter)
+int rtw_alloc_hwxmits(struct adapter *padapter)
 {
 	struct hw_xmit *hwxmits;
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
@@ -1524,6 +1529,8 @@ void rtw_alloc_hwxmits(struct adapter *padapter)
 	pxmitpriv->hwxmit_entry = HWXMIT_ENTRY;
 
 	pxmitpriv->hwxmits = kzalloc(sizeof(struct hw_xmit) * pxmitpriv->hwxmit_entry, GFP_KERNEL);
+	if (!pxmitpriv->hwxmits)
+		return -ENOMEM;
 
 	hwxmits = pxmitpriv->hwxmits;
 
@@ -1540,6 +1547,8 @@ void rtw_alloc_hwxmits(struct adapter *padapter)
 		hwxmits[3] .sta_queue = &pxmitpriv->bk_pending;
 	} else {
 	}
+
+	return 0;
 }
 
 void rtw_free_hwxmits(struct adapter *padapter)
diff --git a/drivers/staging/r8188eu/include/rtw_xmit.h b/drivers/staging/r8188eu/include/rtw_xmit.h
index 5f6e2402e5c4..762a2fa3bd17 100644
--- a/drivers/staging/r8188eu/include/rtw_xmit.h
+++ b/drivers/staging/r8188eu/include/rtw_xmit.h
@@ -345,7 +345,7 @@ s32 rtw_txframes_sta_ac_pending(struct adapter *padapter,
 void rtw_init_hwxmits(struct hw_xmit *phwxmit, int entry);
 s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter);
 void _rtw_free_xmit_priv(struct xmit_priv *pxmitpriv);
-void rtw_alloc_hwxmits(struct adapter *padapter);
+int rtw_alloc_hwxmits(struct adapter *padapter);
 void rtw_free_hwxmits(struct adapter *padapter);
 s32 rtw_xmit(struct adapter *padapter, struct sk_buff **pkt);
 
-- 
2.35.1



