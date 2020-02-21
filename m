Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB34167466
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388218AbgBUIVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:21:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387997AbgBUIVE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:21:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCA19206ED;
        Fri, 21 Feb 2020 08:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273264;
        bh=sVnxuLXbC0/c7u22TqpsUNlP8xJHaNjnGHR1lfIr40U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S4yC/l54ZA0PQDvLy+UDKu7P6cgFID8QIcdrlJe2uOV8TDpZkShM9gXsd/fujuMOr
         fVAUkqSo1+Aq359E89Sjze2TDDOxClMLlhxoKfTwNG7u6Zz+XikJG2lc7tO2hMtjs3
         FtHYUDfWPaR3QFXeFx/4NNT2FnyqoDMg4WOySGAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/191] staging: rtl8188: avoid excessive stack usage
Date:   Fri, 21 Feb 2020 08:41:19 +0100
Message-Id: <20200221072303.661252801@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c497ae2077c055b85c1bf04f3d182a84bd8f365b ]

The rtl8188 copy of the os_dep support code causes a
warning about a very significant stack usage in the translate_scan()
function:

drivers/staging/rtl8188eu/os_dep/ioctl_linux.c: In function 'translate_scan':
drivers/staging/rtl8188eu/os_dep/ioctl_linux.c:306:1: error: the frame size of 1560 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]

Use the same trick as in the rtl8723bs copy of the same function, and
allocate it dynamically.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20200104214832.558198-1-arnd@arndb.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index bee3c3a7a7a99..2db4444267a74 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -229,18 +229,21 @@ static char *translate_scan(struct adapter *padapter,
 
 	/* parsing WPA/WPA2 IE */
 	{
-		u8 buf[MAX_WPA_IE_LEN];
+		u8 *buf;
 		u8 wpa_ie[255], rsn_ie[255];
 		u16 wpa_len = 0, rsn_len = 0;
 		u8 *p;
 
+		buf = kzalloc(MAX_WPA_IE_LEN, GFP_ATOMIC);
+		if (!buf)
+			return start;
+
 		rtw_get_sec_ie(pnetwork->network.ies, pnetwork->network.ie_length, rsn_ie, &rsn_len, wpa_ie, &wpa_len);
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("rtw_wx_get_scan: ssid =%s\n", pnetwork->network.Ssid.Ssid));
 		RT_TRACE(_module_rtl871x_mlme_c_, _drv_info_, ("rtw_wx_get_scan: wpa_len =%d rsn_len =%d\n", wpa_len, rsn_len));
 
 		if (wpa_len > 0) {
 			p = buf;
-			memset(buf, 0, MAX_WPA_IE_LEN);
 			p += sprintf(p, "wpa_ie=");
 			for (i = 0; i < wpa_len; i++)
 				p += sprintf(p, "%02x", wpa_ie[i]);
@@ -257,7 +260,6 @@ static char *translate_scan(struct adapter *padapter,
 		}
 		if (rsn_len > 0) {
 			p = buf;
-			memset(buf, 0, MAX_WPA_IE_LEN);
 			p += sprintf(p, "rsn_ie=");
 			for (i = 0; i < rsn_len; i++)
 				p += sprintf(p, "%02x", rsn_ie[i]);
@@ -271,6 +273,7 @@ static char *translate_scan(struct adapter *padapter,
 			iwe.u.data.length = rsn_len;
 			start = iwe_stream_add_point(info, start, stop, &iwe, rsn_ie);
 		}
+		kfree(buf);
 	}
 
 	{/* parsing WPS IE */
-- 
2.20.1



