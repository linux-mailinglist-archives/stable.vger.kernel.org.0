Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A026F3C547C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346455AbhGLH6p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:58:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:45368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349419AbhGLH4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:56:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07A796141A;
        Mon, 12 Jul 2021 07:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076344;
        bh=jzC0v9JKSF4l/P/WOInLYdSCIDd+LtmQVxFu3bnYGVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLL/8b6nhBzhNaFOhpJsDrauNVKqT9ihYjz3YOdcdpq/EUBVSOrjMRC7nQQJGUXLr
         PVLofN1xqV+EcKpAUBYSKOYzCPAQlKBk/4lBVC7GqsCIewhTjpdiCmY4K/o65ye+nU
         ltReWAUhU6E0+bII7n0lnYO1RQ8P2pcCFepgz2ds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 602/800] staging: rtl8712: Fix some tests against some data subtype frames
Date:   Mon, 12 Jul 2021 08:10:25 +0200
Message-Id: <20210712061031.384894504@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 116138c3bd34f92e550431d495db515f5ea19f13 ]

Commit 6e2baa44c6d1 ("staging: rtl8712: remove enum WIFI_FRAME_SUBTYPE")
was wrong because:
	WIFI_DATA_NULL != IEEE80211_STYPE_NULLFUNC
	WIFI_DATA_CFACK != IEEE80211_STYPE_DATA_CFACK
	WIFI_DATA_CFPOLL != IEEE80211_STYPE_DATA_CFPOLL
	WIFI_DATA_CFACKPOLL != IEEE80211_STYPE_DATA_CFACKPOLL

the WIFI_DATA_xxx definitions include WIFI_DATA_TYPE, which is 'BIT(3)'.
Restore the previous behavior by adding the missing
'IEEE80211_FTYPE_DATA |' (0x0008, that is to say BIT(3)) when these values
are used.

Hopefully, the wrong commit was small enough and hand review is possible.

Fixes: 6e2baa44c6d1 ("staging: rtl8712: remove enum WIFI_FRAME_SUBTYPE")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/44aebfa3c5ce8f45ae05369c73e9ff77c6d271f9.1619939806.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8712/rtl871x_recv.c     |  2 +-
 drivers/staging/rtl8712/rtl871x_security.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_recv.c b/drivers/staging/rtl8712/rtl871x_recv.c
index db2add576418..c23f6b376111 100644
--- a/drivers/staging/rtl8712/rtl871x_recv.c
+++ b/drivers/staging/rtl8712/rtl871x_recv.c
@@ -374,7 +374,7 @@ static sint ap2sta_data_frame(struct _adapter *adapter,
 	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE) &&
 	    check_fwstate(pmlmepriv, _FW_LINKED)) {
 		/* if NULL-frame, drop packet */
-		if ((GetFrameSubType(ptr)) == IEEE80211_STYPE_NULLFUNC)
+		if ((GetFrameSubType(ptr)) == (IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC))
 			return _FAIL;
 		/* drop QoS-SubType Data, including QoS NULL,
 		 * excluding QoS-Data
diff --git a/drivers/staging/rtl8712/rtl871x_security.c b/drivers/staging/rtl8712/rtl871x_security.c
index 63d63f7be481..e0a1c30a8fe6 100644
--- a/drivers/staging/rtl8712/rtl871x_security.c
+++ b/drivers/staging/rtl8712/rtl871x_security.c
@@ -1045,9 +1045,9 @@ static void aes_cipher(u8 *key, uint hdrlen,
 	else
 		a4_exists = 1;
 
-	if ((frtype == IEEE80211_STYPE_DATA_CFACK) ||
-	    (frtype == IEEE80211_STYPE_DATA_CFPOLL) ||
-	    (frtype == IEEE80211_STYPE_DATA_CFACKPOLL)) {
+	if ((frtype == (IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA_CFACK)) ||
+	    (frtype == (IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA_CFPOLL)) ||
+	    (frtype == (IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA_CFACKPOLL))) {
 		qc_exists = 1;
 		if (hdrlen !=  WLAN_HDR_A3_QOS_LEN)
 			hdrlen += 2;
@@ -1225,9 +1225,9 @@ static void aes_decipher(u8 *key, uint hdrlen,
 		a4_exists = 0;
 	else
 		a4_exists = 1;
-	if ((frtype == IEEE80211_STYPE_DATA_CFACK) ||
-	    (frtype == IEEE80211_STYPE_DATA_CFPOLL) ||
-	    (frtype == IEEE80211_STYPE_DATA_CFACKPOLL)) {
+	if ((frtype == (IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA_CFACK)) ||
+	    (frtype == (IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA_CFPOLL)) ||
+	    (frtype == (IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA_CFACKPOLL))) {
 		qc_exists = 1;
 		if (hdrlen != WLAN_HDR_A3_QOS_LEN)
 			hdrlen += 2;
-- 
2.30.2



