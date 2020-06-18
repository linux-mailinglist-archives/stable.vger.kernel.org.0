Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD871FDFDA
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 03:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732391AbgFRBn6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:43:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732196AbgFRB27 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:28:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9F4D22203;
        Thu, 18 Jun 2020 01:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443738;
        bh=FLuoHo70qnMEjz9/GZitB6508Tqlfu8Kpmk1kXIno6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uUOG5PXTq7DtNcwOkczG5ulU7rE2taUrofZt98uLiX9w5RLDEIP0L7faGYaA3P/pV
         OPGjPIFbFqf0WaJO3ZzTaQEIKH/B5OfUwDQfmdblOmtuvISug9baDU10dzcjDnLTUn
         xuPRAWw9aisrPA9osbzKZe64LXoE05WTihpL+UZE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aiman Najjar <aiman.najjar@hurranet.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH AUTOSEL 4.9 29/80] staging: rtl8712: fix multiline derefernce warnings
Date:   Wed, 17 Jun 2020 21:27:28 -0400
Message-Id: <20200618012819.609778-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618012819.609778-1-sashal@kernel.org>
References: <20200618012819.609778-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aiman Najjar <aiman.najjar@hurranet.com>

[ Upstream commit 269da10b1477c31c660288633c8d613e421b131f ]

This patch fixes remaining checkpatch warnings
in rtl871x_xmit.c:

WARNING: Avoid multiple line dereference - prefer 'psecuritypriv->PrivacyKeyIndex'
636: FILE: drivers/staging//rtl8712/rtl871x_xmit.c:636:
+					      (u8)psecuritypriv->
+					      PrivacyKeyIndex);

WARNING: Avoid multiple line dereference - prefer 'psecuritypriv->XGrpKeyid'
643: FILE: drivers/staging//rtl8712/rtl871x_xmit.c:643:
+						   (u8)psecuritypriv->
+						   XGrpKeyid);

WARNING: Avoid multiple line dereference - prefer 'psecuritypriv->XGrpKeyid'
652: FILE: drivers/staging//rtl8712/rtl871x_xmit.c:652:
+						   (u8)psecuritypriv->
+						   XGrpKeyid);

Signed-off-by: Aiman Najjar <aiman.najjar@hurranet.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/98805a72b92e9bbf933e05b827d27944663b7bc1.1585508171.git.aiman.najjar@hurranet.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8712/rtl871x_xmit.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_xmit.c b/drivers/staging/rtl8712/rtl871x_xmit.c
index c47863936858..c6a90251043e 100644
--- a/drivers/staging/rtl8712/rtl871x_xmit.c
+++ b/drivers/staging/rtl8712/rtl871x_xmit.c
@@ -599,7 +599,7 @@ sint r8712_xmitframe_coalesce(struct _adapter *padapter, _pkt *pkt,
 	addr_t addr;
 	u8 *pframe, *mem_start, *ptxdesc;
 	struct sta_info		*psta;
-	struct security_priv	*psecuritypriv = &padapter->securitypriv;
+	struct security_priv	*psecpriv = &padapter->securitypriv;
 	struct mlme_priv	*pmlmepriv = &padapter->mlmepriv;
 	struct xmit_priv	*pxmitpriv = &padapter->xmitpriv;
 	struct pkt_attrib	*pattrib = &pxmitframe->attrib;
@@ -642,15 +642,13 @@ sint r8712_xmitframe_coalesce(struct _adapter *padapter, _pkt *pkt,
 				case _WEP40_:
 				case _WEP104_:
 					WEP_IV(pattrib->iv, psta->txpn,
-					       (u8)psecuritypriv->
-					       PrivacyKeyIndex);
+					       (u8)psecpriv->PrivacyKeyIndex);
 					break;
 				case _TKIP_:
 					if (bmcst)
 						TKIP_IV(pattrib->iv,
 						    psta->txpn,
-						    (u8)psecuritypriv->
-						    XGrpKeyid);
+						    (u8)psecpriv->XGrpKeyid);
 					else
 						TKIP_IV(pattrib->iv, psta->txpn,
 							0);
@@ -658,8 +656,7 @@ sint r8712_xmitframe_coalesce(struct _adapter *padapter, _pkt *pkt,
 				case _AES_:
 					if (bmcst)
 						AES_IV(pattrib->iv, psta->txpn,
-						    (u8)psecuritypriv->
-						    XGrpKeyid);
+						    (u8)psecpriv->XGrpKeyid);
 					else
 						AES_IV(pattrib->iv, psta->txpn,
 						       0);
-- 
2.25.1

