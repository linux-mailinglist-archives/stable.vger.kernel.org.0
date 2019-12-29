Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D84A12C769
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbfL2R26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:28:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:52820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbfL2R2z (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:28:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7D66207FD;
        Sun, 29 Dec 2019 17:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640535;
        bh=VLyF6Gay6F2xSaGHRXndj5ryoeCGDqbkQqQAhMhrE5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mje6BozxtBJIRx1eXi1CGsrJkek3KTFd20GpfeiFcjp5o22xofIzXqgaM/h9v5y8i
         kyuGz5xCqXbyDebHBuLAT14yRNPEYj3D8ijr4ZAB/M1kQQ79Lb8Gl/mngbZpwPJ9+U
         9Cquyu2r4wT3zErBBYyxOHR5MYn0ZWkLiu9y3Egg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Connor Kuehl <connor.kuehl@canonical.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 034/219] staging: rtl8188eu: fix possible null dereference
Date:   Sun, 29 Dec 2019 18:17:16 +0100
Message-Id: <20191229162513.575448657@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Connor Kuehl <connor.kuehl@canonical.com>

[ Upstream commit 228241944a48113470d3c3b46c88ba7fbe0a274b ]

Inside a nested 'else' block at the beginning of this function is a
call that assigns 'psta' to the return value of 'rtw_get_stainfo()'.
If 'rtw_get_stainfo()' returns NULL and the flow of control reaches
the 'else if' where 'psta' is dereferenced, then we will dereference
a NULL pointer.

Fix this by checking if 'psta' is not NULL before reading its
'psta->qos_option' data member.

Addresses-Coverity: ("Dereference null return value")

Signed-off-by: Connor Kuehl <connor.kuehl@canonical.com>
Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
Link: https://lore.kernel.org/r/20190926150317.5894-1-connor.kuehl@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8188eu/core/rtw_xmit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_xmit.c b/drivers/staging/rtl8188eu/core/rtw_xmit.c
index dd9b02d316f3..c6a5b62cb363 100644
--- a/drivers/staging/rtl8188eu/core/rtw_xmit.c
+++ b/drivers/staging/rtl8188eu/core/rtw_xmit.c
@@ -778,7 +778,7 @@ s32 rtw_make_wlanhdr(struct adapter *padapter, u8 *hdr, struct pkt_attrib *pattr
 			memcpy(pwlanhdr->addr2, get_bssid(pmlmepriv), ETH_ALEN);
 			memcpy(pwlanhdr->addr3, pattrib->src, ETH_ALEN);
 
-			if (psta->qos_option)
+			if (psta && psta->qos_option)
 				qos_option = true;
 		} else if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE) ||
 			   check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE)) {
@@ -786,7 +786,7 @@ s32 rtw_make_wlanhdr(struct adapter *padapter, u8 *hdr, struct pkt_attrib *pattr
 			memcpy(pwlanhdr->addr2, pattrib->src, ETH_ALEN);
 			memcpy(pwlanhdr->addr3, get_bssid(pmlmepriv), ETH_ALEN);
 
-			if (psta->qos_option)
+			if (psta && psta->qos_option)
 				qos_option = true;
 		} else {
 			RT_TRACE(_module_rtl871x_xmit_c_, _drv_err_, ("fw_state:%x is not allowed to xmit frame\n", get_fwstate(pmlmepriv)));
-- 
2.20.1



