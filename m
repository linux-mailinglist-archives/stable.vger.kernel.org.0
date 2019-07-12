Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB7E066D93
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbfGLMbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:31:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728436AbfGLMba (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:31:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB27D208E4;
        Fri, 12 Jul 2019 12:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934689;
        bh=8Ofvv33rPGmjDL2rDLnBVau085DetjhXDbhPidErydk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vhYmzWZMsdmqtx0VzCpciEJuatd1Br2QCIvYnwGenlkC4owCFlujmq4QR9OjRfo9v
         W4rp6giGGnxG4/qGnGZQ87Y6w/VWBiqXrGVfd0heLVcxNQhs9wWuG94bc4eYzK3gIZ
         xcFJB2+XAedOESW3daEWDSgXDDnLm1O51caV/s5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5.1 138/138] staging: rtl8712: reduce stack usage, again
Date:   Fri, 12 Jul 2019 14:20:02 +0200
Message-Id: <20190712121634.003789371@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121628.731888964@linuxfoundation.org>
References: <20190712121628.731888964@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit fbd6b25009ac76b2034168cd21d5e01f8c2d83d1 upstream.

An earlier patch I sent reduced the stack usage enough to get
below the warning limit, and I could show this was safe, but with
GCC_PLUGIN_STRUCTLEAK_BYREF_ALL, it gets worse again because large stack
variables in the same function no longer overlap:

drivers/staging/rtl8712/rtl871x_ioctl_linux.c: In function 'translate_scan.isra.2':
drivers/staging/rtl8712/rtl871x_ioctl_linux.c:322:1: error: the frame size of 1200 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

Split out the largest two blocks in the affected function into two
separate functions and mark those noinline_for_stack.

Fixes: 8c5af16f7953 ("staging: rtl8712: reduce stack usage")
Fixes: 81a56f6dcd20 ("gcc-plugins: structleak: Generalize to all variable types")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |  159 ++++++++++++++------------
 1 file changed, 89 insertions(+), 70 deletions(-)

--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -124,10 +124,91 @@ static inline void handle_group_key(stru
 	}
 }
 
-static noinline_for_stack char *translate_scan(struct _adapter *padapter,
-				   struct iw_request_info *info,
-				   struct wlan_network *pnetwork,
-				   char *start, char *stop)
+static noinline_for_stack char *translate_scan_wpa(struct iw_request_info *info,
+						   struct wlan_network *pnetwork,
+						   struct iw_event *iwe,
+						   char *start, char *stop)
+{
+	/* parsing WPA/WPA2 IE */
+	u8 buf[MAX_WPA_IE_LEN];
+	u8 wpa_ie[255], rsn_ie[255];
+	u16 wpa_len = 0, rsn_len = 0;
+	int n, i;
+
+	r8712_get_sec_ie(pnetwork->network.IEs,
+			 pnetwork->network.IELength, rsn_ie, &rsn_len,
+			 wpa_ie, &wpa_len);
+	if (wpa_len > 0) {
+		memset(buf, 0, MAX_WPA_IE_LEN);
+		n = sprintf(buf, "wpa_ie=");
+		for (i = 0; i < wpa_len; i++) {
+			n += snprintf(buf + n, MAX_WPA_IE_LEN - n,
+						"%02x", wpa_ie[i]);
+			if (n >= MAX_WPA_IE_LEN)
+				break;
+		}
+		memset(iwe, 0, sizeof(*iwe));
+		iwe->cmd = IWEVCUSTOM;
+		iwe->u.data.length = (u16)strlen(buf);
+		start = iwe_stream_add_point(info, start, stop,
+			iwe, buf);
+		memset(iwe, 0, sizeof(*iwe));
+		iwe->cmd = IWEVGENIE;
+		iwe->u.data.length = (u16)wpa_len;
+		start = iwe_stream_add_point(info, start, stop,
+			iwe, wpa_ie);
+	}
+	if (rsn_len > 0) {
+		memset(buf, 0, MAX_WPA_IE_LEN);
+		n = sprintf(buf, "rsn_ie=");
+		for (i = 0; i < rsn_len; i++) {
+			n += snprintf(buf + n, MAX_WPA_IE_LEN - n,
+						"%02x", rsn_ie[i]);
+			if (n >= MAX_WPA_IE_LEN)
+				break;
+		}
+		memset(iwe, 0, sizeof(*iwe));
+		iwe->cmd = IWEVCUSTOM;
+		iwe->u.data.length = strlen(buf);
+		start = iwe_stream_add_point(info, start, stop,
+			iwe, buf);
+		memset(iwe, 0, sizeof(*iwe));
+		iwe->cmd = IWEVGENIE;
+		iwe->u.data.length = rsn_len;
+		start = iwe_stream_add_point(info, start, stop, iwe,
+			rsn_ie);
+	}
+
+	return start;
+}
+
+static noinline_for_stack char *translate_scan_wps(struct iw_request_info *info,
+						   struct wlan_network *pnetwork,
+						   struct iw_event *iwe,
+						   char *start, char *stop)
+{
+	/* parsing WPS IE */
+	u8 wps_ie[512];
+	uint wps_ielen;
+
+	if (r8712_get_wps_ie(pnetwork->network.IEs,
+	    pnetwork->network.IELength,
+	    wps_ie, &wps_ielen)) {
+		if (wps_ielen > 2) {
+			iwe->cmd = IWEVGENIE;
+			iwe->u.data.length = (u16)wps_ielen;
+			start = iwe_stream_add_point(info, start, stop,
+				iwe, wps_ie);
+		}
+	}
+
+	return start;
+}
+
+static char *translate_scan(struct _adapter *padapter,
+			    struct iw_request_info *info,
+			    struct wlan_network *pnetwork,
+			    char *start, char *stop)
 {
 	struct iw_event iwe;
 	struct ieee80211_ht_cap *pht_capie;
@@ -240,73 +321,11 @@ static noinline_for_stack char *translat
 	/* Check if we added any event */
 	if ((current_val - start) > iwe_stream_lcp_len(info))
 		start = current_val;
-	/* parsing WPA/WPA2 IE */
-	{
-		u8 buf[MAX_WPA_IE_LEN];
-		u8 wpa_ie[255], rsn_ie[255];
-		u16 wpa_len = 0, rsn_len = 0;
-		int n;
-
-		r8712_get_sec_ie(pnetwork->network.IEs,
-				 pnetwork->network.IELength, rsn_ie, &rsn_len,
-				 wpa_ie, &wpa_len);
-		if (wpa_len > 0) {
-			memset(buf, 0, MAX_WPA_IE_LEN);
-			n = sprintf(buf, "wpa_ie=");
-			for (i = 0; i < wpa_len; i++) {
-				n += snprintf(buf + n, MAX_WPA_IE_LEN - n,
-							"%02x", wpa_ie[i]);
-				if (n >= MAX_WPA_IE_LEN)
-					break;
-			}
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVCUSTOM;
-			iwe.u.data.length = (u16)strlen(buf);
-			start = iwe_stream_add_point(info, start, stop,
-				&iwe, buf);
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVGENIE;
-			iwe.u.data.length = (u16)wpa_len;
-			start = iwe_stream_add_point(info, start, stop,
-				&iwe, wpa_ie);
-		}
-		if (rsn_len > 0) {
-			memset(buf, 0, MAX_WPA_IE_LEN);
-			n = sprintf(buf, "rsn_ie=");
-			for (i = 0; i < rsn_len; i++) {
-				n += snprintf(buf + n, MAX_WPA_IE_LEN - n,
-							"%02x", rsn_ie[i]);
-				if (n >= MAX_WPA_IE_LEN)
-					break;
-			}
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVCUSTOM;
-			iwe.u.data.length = strlen(buf);
-			start = iwe_stream_add_point(info, start, stop,
-				&iwe, buf);
-			memset(&iwe, 0, sizeof(iwe));
-			iwe.cmd = IWEVGENIE;
-			iwe.u.data.length = rsn_len;
-			start = iwe_stream_add_point(info, start, stop, &iwe,
-				rsn_ie);
-		}
-	}
 
-	{ /* parsing WPS IE */
-		u8 wps_ie[512];
-		uint wps_ielen;
-
-		if (r8712_get_wps_ie(pnetwork->network.IEs,
-		    pnetwork->network.IELength,
-		    wps_ie, &wps_ielen)) {
-			if (wps_ielen > 2) {
-				iwe.cmd = IWEVGENIE;
-				iwe.u.data.length = (u16)wps_ielen;
-				start = iwe_stream_add_point(info, start, stop,
-					&iwe, wps_ie);
-			}
-		}
-	}
+	start = translate_scan_wpa(info, pnetwork, &iwe, start, stop);
+
+	start = translate_scan_wps(info, pnetwork, &iwe, start, stop);
+
 	/* Add quality statistics */
 	iwe.cmd = IWEVQUAL;
 	rssi = r8712_signal_scale_mapping(pnetwork->network.Rssi);


