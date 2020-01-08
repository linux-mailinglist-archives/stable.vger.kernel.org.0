Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEAC134BAE
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 20:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730494AbgAHTqF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 14:46:05 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43694 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730456AbgAHTqE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 14:46:04 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHD-0006p7-In; Wed, 08 Jan 2020 19:45:59 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ipHHC-007dnu-Nr; Wed, 08 Jan 2020 19:45:58 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Arnd Bergmann" <arnd@arndb.de>
Date:   Wed, 08 Jan 2020 19:43:41 +0000
Message-ID: <lsq.1578512578.874297448@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 43/63] cfg80211: size various nl80211 messages correctly
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.81-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 4ef8c1c93f848e360754f10eb2e7134c872b6597 upstream.

Ilan reported that sometimes nl80211 messages weren't working if
the frames being transported got very large, which was really a
problem for userspace-to-kernel messages, but prompted me to look
at the code.

Upon review, I found various places where variable-length data is
transported in an nl80211 message but the message isn't allocated
taking that into account. This shouldn't cause any problems since
the frames aren't really that long, apart in one place where two
(possibly very long frames) might not fit.

Fix all the places (that I found) that get variable length data
from the driver and put it into a message to take the length of
the variable data into account. The 100 there is just a safe
constant for the remaining message overhead (it's usually around
50 for most messages.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/nl80211.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10463,7 +10463,7 @@ static void nl80211_send_mlme_event(stru
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg = nlmsg_new(100 + len, gfp);
 	if (!msg)
 		return;
 
@@ -10602,7 +10602,7 @@ void nl80211_send_connect_result(struct
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg = nlmsg_new(100 + req_ie_len + resp_ie_len, gfp);
 	if (!msg)
 		return;
 
@@ -10642,7 +10642,7 @@ void nl80211_send_roamed(struct cfg80211
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg = nlmsg_new(100 + req_ie_len + resp_ie_len, gfp);
 	if (!msg)
 		return;
 
@@ -10680,7 +10680,7 @@ void nl80211_send_disconnected(struct cf
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	msg = nlmsg_new(100 + ie_len, GFP_KERNEL);
 	if (!msg)
 		return;
 
@@ -10757,7 +10757,7 @@ void cfg80211_notify_new_peer_candidate(
 
 	trace_cfg80211_notify_new_peer_candidate(dev, addr);
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg = nlmsg_new(100 + ie_len, gfp);
 	if (!msg)
 		return;
 
@@ -11133,7 +11133,7 @@ int nl80211_send_mgmt(struct cfg80211_re
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg = nlmsg_new(100 + len, gfp);
 	if (!msg)
 		return -ENOMEM;
 
@@ -11176,7 +11176,7 @@ void cfg80211_mgmt_tx_status(struct wire
 
 	trace_cfg80211_mgmt_tx_status(wdev, cookie, ack);
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	msg = nlmsg_new(100 + len, gfp);
 	if (!msg)
 		return;
 
@@ -11886,7 +11886,7 @@ void cfg80211_ft_event(struct net_device
 	if (!ft_event->target_ap)
 		return;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	msg = nlmsg_new(100 + ft_event->ric_ies_len, GFP_KERNEL);
 	if (!msg)
 		return;
 

