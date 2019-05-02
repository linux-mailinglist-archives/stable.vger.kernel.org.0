Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8932711E2D
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbfEBP0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:26:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727833AbfEBP0v (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:26:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1654920449;
        Thu,  2 May 2019 15:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556810810;
        bh=ZXWQolyZBCzpMAOOBxkzSyS8XoCRuncSuRNee1yozXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m1SS/xfUhppew0tDvqlfQixNHJ5hVqVynnPRondIXNX860ebITmYdUAE1vkggAKo+
         H5/TeXrFlUNC24ajJZAaGRNnmpCuX2Zs/TYHRCnzprs1q9w/oX1zamKVo1fwhctQ1A
         x8xMskdDN/M7a06aHdvrtK4qRJ98wauqKYHRiI+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Mukesh Ojha <mojha@codeaurora.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 4.19 37/72] staging: rtl8188eu: Fix potential NULL pointer dereference of kcalloc
Date:   Thu,  2 May 2019 17:20:59 +0200
Message-Id: <20190502143336.472991277@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
References: <20190502143333.437607839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7671ce0d92933762f469266daf43bd34d422d58c ]

hwxmits is allocated via kcalloc and not checked for failure before its
dereference. The patch fixes this problem by returning error upstream
in rtl8723bs, rtl8188eu.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Acked-by: Mukesh Ojha <mojha@codeaurora.org>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/staging/rtl8188eu/core/rtw_xmit.c    |  9 +++++++--
 drivers/staging/rtl8188eu/include/rtw_xmit.h |  2 +-
 drivers/staging/rtl8723bs/core/rtw_xmit.c    | 14 +++++++-------
 drivers/staging/rtl8723bs/include/rtw_xmit.h |  2 +-
 4 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index 2130d78e0d9f..dd9b02d316f3 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -178,7 +178,9 @@ s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 
 	pxmitpriv->free_xmit_extbuf_cnt = num_xmit_extbuf;
 
-	rtw_alloc_hwxmits(padapter);
+	res = rtw_alloc_hwxmits(padapter);
+	if (res == _FAIL)
+		goto exit;
 	rtw_init_hwxmits(pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);
 
 	for (i = 0; i < 4; i++)
@@ -1502,7 +1504,7 @@ s32 rtw_xmit_classifier(struct adapter *padapter, struct xmit_frame *pxmitframe)
 	return res;
 }
 
-void rtw_alloc_hwxmits(struct adapter *padapter)
+s32 rtw_alloc_hwxmits(struct adapter *padapter)
 {
 	struct hw_xmit *hwxmits;
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
@@ -1511,6 +1513,8 @@ void rtw_alloc_hwxmits(struct adapter *padapter)
 
 	pxmitpriv->hwxmits = kcalloc(pxmitpriv->hwxmit_entry,
 				     sizeof(struct hw_xmit), GFP_KERNEL);
+	if (!pxmitpriv->hwxmits)
+		return _FAIL;
 
 	hwxmits = pxmitpriv->hwxmits;
 
@@ -1518,6 +1522,7 @@ void rtw_alloc_hwxmits(struct adapter *padapter)
 	hwxmits[1] .sta_queue = &pxmitpriv->vi_pending;
 	hwxmits[2] .sta_queue = &pxmitpriv->be_pending;
 	hwxmits[3] .sta_queue = &pxmitpriv->bk_pending;
+	return _SUCCESS;
 }
 
 void rtw_free_hwxmits(struct adapter *padapter)
diff --git a/drivers/staging/rtl8188eu/include/rtw_xmit.h b/drivers/staging/rtl8188eu/include/rtw_xmit.h
index 788f59c74ea1..ba7e15fbde72 100644
--- a/drivers/staging/rtl8188eu/include/rtw_xmit.h
+++ b/drivers/staging/rtl8188eu/include/rtw_xmit.h
@@ -336,7 +336,7 @@ s32 rtw_txframes_sta_ac_pending(struct adapter *padapter,
 void rtw_init_hwxmits(struct hw_xmit *phwxmit, int entry);
 s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter);
 void _rtw_free_xmit_priv(struct xmit_priv *pxmitpriv);
-void rtw_alloc_hwxmits(struct adapter *padapter);
+s32 rtw_alloc_hwxmits(struct adapter *padapter);
 void rtw_free_hwxmits(struct adapter *padapter);
 s32 rtw_xmit(struct adapter *padapter, struct sk_buff **pkt);
 
diff --git a/drivers/staging/rtl8723bs/core/rtw_xmit.c b/drivers/staging/rtl8723bs/core/rtw_xmit.c
index edb678190b4b..16291de5c0d9 100644
--- a/drivers/staging/rtl8723bs/core/rtw_xmit.c
+++ b/drivers/staging/rtl8723bs/core/rtw_xmit.c
@@ -260,7 +260,9 @@ s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 		}
 	}
 
-	rtw_alloc_hwxmits(padapter);
+	res = rtw_alloc_hwxmits(padapter);
+	if (res == _FAIL)
+		goto exit;
 	rtw_init_hwxmits(pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);
 
 	for (i = 0; i < 4; i++) {
@@ -2144,7 +2146,7 @@ s32 rtw_xmit_classifier(struct adapter *padapter, struct xmit_frame *pxmitframe)
 	return res;
 }
 
-void rtw_alloc_hwxmits(struct adapter *padapter)
+s32 rtw_alloc_hwxmits(struct adapter *padapter)
 {
 	struct hw_xmit *hwxmits;
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
@@ -2155,10 +2157,8 @@ void rtw_alloc_hwxmits(struct adapter *padapter)
 
 	pxmitpriv->hwxmits = rtw_zmalloc(sizeof(struct hw_xmit) * pxmitpriv->hwxmit_entry);
 
-	if (pxmitpriv->hwxmits == NULL) {
-		DBG_871X("alloc hwxmits fail!...\n");
-		return;
-	}
+	if (!pxmitpriv->hwxmits)
+		return _FAIL;
 
 	hwxmits = pxmitpriv->hwxmits;
 
@@ -2204,7 +2204,7 @@ void rtw_alloc_hwxmits(struct adapter *padapter)
 
 	}
 
-
+	return _SUCCESS;
 }
 
 void rtw_free_hwxmits(struct adapter *padapter)
diff --git a/drivers/staging/rtl8723bs/include/rtw_xmit.h b/drivers/staging/rtl8723bs/include/rtw_xmit.h
index a75b668d09a6..021c72361fbb 100644
--- a/drivers/staging/rtl8723bs/include/rtw_xmit.h
+++ b/drivers/staging/rtl8723bs/include/rtw_xmit.h
@@ -486,7 +486,7 @@ s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter);
 void _rtw_free_xmit_priv (struct xmit_priv *pxmitpriv);
 
 
-void rtw_alloc_hwxmits(struct adapter *padapter);
+s32 rtw_alloc_hwxmits(struct adapter *padapter);
 void rtw_free_hwxmits(struct adapter *padapter);
 
 
-- 
2.19.1



