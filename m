Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5200714D95
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 16:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbfEFOrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:47:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:46988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728440AbfEFOrj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:47:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1A0020578;
        Mon,  6 May 2019 14:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557154057;
        bh=p4k4VEEcg6/JvNjILCfPYUNlLZeYKtbYzZxS21BDptg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NpkBMauJk5ZaiNT21vvUyp7jSFLCiv0tCDhkAvY/CNLshhOWaY9EDbFwWa6r6raJU
         3pZkky4poX8oVxiXWBkrVZTFDhdo3HvSz3HxK2aHVmpBFc4h770Al1AdyjrnOg8cIn
         Pz2ZZT/O6iy4KS/ED6LHGdXrgoOt9JMSTPESKRLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Konovalov <andreyknvl@google.com>
Subject: [PATCH 4.9 21/62] caif: reduce stack size with KASAN
Date:   Mon,  6 May 2019 16:32:52 +0200
Message-Id: <20190506143052.887801316@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143051.102535767@linuxfoundation.org>
References: <20190506143051.102535767@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit ce6289661b14a8b391d90db918c91b6d6da6540a upstream.

When CONFIG_KASAN is set, we can use relatively large amounts of kernel
stack space:

net/caif/cfctrl.c:555:1: warning: the frame size of 1600 bytes is larger than 1280 bytes [-Wframe-larger-than=]

This adds convenience wrappers around cfpkt_extr_head(), which is responsible
for most of the stack growth. With those wrapper functions, gcc apparently
starts reusing the stack slots for each instance, thus avoiding the
problem.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/caif/cfpkt.h |   27 +++++++++++++++++++++++++
 net/caif/cfctrl.c        |   50 ++++++++++++++++++++---------------------------
 2 files changed, 49 insertions(+), 28 deletions(-)

--- a/include/net/caif/cfpkt.h
+++ b/include/net/caif/cfpkt.h
@@ -32,6 +32,33 @@ void cfpkt_destroy(struct cfpkt *pkt);
  */
 int cfpkt_extr_head(struct cfpkt *pkt, void *data, u16 len);
 
+static inline u8 cfpkt_extr_head_u8(struct cfpkt *pkt)
+{
+	u8 tmp;
+
+	cfpkt_extr_head(pkt, &tmp, 1);
+
+	return tmp;
+}
+
+static inline u16 cfpkt_extr_head_u16(struct cfpkt *pkt)
+{
+	__le16 tmp;
+
+	cfpkt_extr_head(pkt, &tmp, 2);
+
+	return le16_to_cpu(tmp);
+}
+
+static inline u32 cfpkt_extr_head_u32(struct cfpkt *pkt)
+{
+	__le32 tmp;
+
+	cfpkt_extr_head(pkt, &tmp, 4);
+
+	return le32_to_cpu(tmp);
+}
+
 /*
  * Peek header from packet.
  * Reads data from packet without changing packet.
--- a/net/caif/cfctrl.c
+++ b/net/caif/cfctrl.c
@@ -352,15 +352,14 @@ static int cfctrl_recv(struct cflayer *l
 	u8 cmdrsp;
 	u8 cmd;
 	int ret = -1;
-	u16 tmp16;
 	u8 len;
 	u8 param[255];
-	u8 linkid;
+	u8 linkid = 0;
 	struct cfctrl *cfctrl = container_obj(layer);
 	struct cfctrl_request_info rsp, *req;
 
 
-	cfpkt_extr_head(pkt, &cmdrsp, 1);
+	cmdrsp = cfpkt_extr_head_u8(pkt);
 	cmd = cmdrsp & CFCTRL_CMD_MASK;
 	if (cmd != CFCTRL_CMD_LINK_ERR
 	    && CFCTRL_RSP_BIT != (CFCTRL_RSP_BIT & cmdrsp)
@@ -378,13 +377,12 @@ static int cfctrl_recv(struct cflayer *l
 			u8 physlinkid;
 			u8 prio;
 			u8 tmp;
-			u32 tmp32;
 			u8 *cp;
 			int i;
 			struct cfctrl_link_param linkparam;
 			memset(&linkparam, 0, sizeof(linkparam));
 
-			cfpkt_extr_head(pkt, &tmp, 1);
+			tmp = cfpkt_extr_head_u8(pkt);
 
 			serv = tmp & CFCTRL_SRV_MASK;
 			linkparam.linktype = serv;
@@ -392,13 +390,13 @@ static int cfctrl_recv(struct cflayer *l
 			servtype = tmp >> 4;
 			linkparam.chtype = servtype;
 
-			cfpkt_extr_head(pkt, &tmp, 1);
+			tmp = cfpkt_extr_head_u8(pkt);
 			physlinkid = tmp & 0x07;
 			prio = tmp >> 3;
 
 			linkparam.priority = prio;
 			linkparam.phyid = physlinkid;
-			cfpkt_extr_head(pkt, &endpoint, 1);
+			endpoint = cfpkt_extr_head_u8(pkt);
 			linkparam.endpoint = endpoint & 0x03;
 
 			switch (serv) {
@@ -407,45 +405,43 @@ static int cfctrl_recv(struct cflayer *l
 				if (CFCTRL_ERR_BIT & cmdrsp)
 					break;
 				/* Link ID */
-				cfpkt_extr_head(pkt, &linkid, 1);
+				linkid = cfpkt_extr_head_u8(pkt);
 				break;
 			case CFCTRL_SRV_VIDEO:
-				cfpkt_extr_head(pkt, &tmp, 1);
+				tmp = cfpkt_extr_head_u8(pkt);
 				linkparam.u.video.connid = tmp;
 				if (CFCTRL_ERR_BIT & cmdrsp)
 					break;
 				/* Link ID */
-				cfpkt_extr_head(pkt, &linkid, 1);
+				linkid = cfpkt_extr_head_u8(pkt);
 				break;
 
 			case CFCTRL_SRV_DATAGRAM:
-				cfpkt_extr_head(pkt, &tmp32, 4);
 				linkparam.u.datagram.connid =
-				    le32_to_cpu(tmp32);
+				    cfpkt_extr_head_u32(pkt);
 				if (CFCTRL_ERR_BIT & cmdrsp)
 					break;
 				/* Link ID */
-				cfpkt_extr_head(pkt, &linkid, 1);
+				linkid = cfpkt_extr_head_u8(pkt);
 				break;
 			case CFCTRL_SRV_RFM:
 				/* Construct a frame, convert
 				 * DatagramConnectionID
 				 * to network format long and copy it out...
 				 */
-				cfpkt_extr_head(pkt, &tmp32, 4);
 				linkparam.u.rfm.connid =
-				  le32_to_cpu(tmp32);
+				    cfpkt_extr_head_u32(pkt);
 				cp = (u8 *) linkparam.u.rfm.volume;
-				for (cfpkt_extr_head(pkt, &tmp, 1);
+				for (tmp = cfpkt_extr_head_u8(pkt);
 				     cfpkt_more(pkt) && tmp != '\0';
-				     cfpkt_extr_head(pkt, &tmp, 1))
+				     tmp = cfpkt_extr_head_u8(pkt))
 					*cp++ = tmp;
 				*cp = '\0';
 
 				if (CFCTRL_ERR_BIT & cmdrsp)
 					break;
 				/* Link ID */
-				cfpkt_extr_head(pkt, &linkid, 1);
+				linkid = cfpkt_extr_head_u8(pkt);
 
 				break;
 			case CFCTRL_SRV_UTIL:
@@ -454,13 +450,11 @@ static int cfctrl_recv(struct cflayer *l
 				 * to network format long and copy it out...
 				 */
 				/* Fifosize KB */
-				cfpkt_extr_head(pkt, &tmp16, 2);
 				linkparam.u.utility.fifosize_kb =
-				    le16_to_cpu(tmp16);
+				    cfpkt_extr_head_u16(pkt);
 				/* Fifosize bufs */
-				cfpkt_extr_head(pkt, &tmp16, 2);
 				linkparam.u.utility.fifosize_bufs =
-				    le16_to_cpu(tmp16);
+				    cfpkt_extr_head_u16(pkt);
 				/* name */
 				cp = (u8 *) linkparam.u.utility.name;
 				caif_assert(sizeof(linkparam.u.utility.name)
@@ -468,24 +462,24 @@ static int cfctrl_recv(struct cflayer *l
 				for (i = 0;
 				     i < UTILITY_NAME_LENGTH
 				     && cfpkt_more(pkt); i++) {
-					cfpkt_extr_head(pkt, &tmp, 1);
+					tmp = cfpkt_extr_head_u8(pkt);
 					*cp++ = tmp;
 				}
 				/* Length */
-				cfpkt_extr_head(pkt, &len, 1);
+				len = cfpkt_extr_head_u8(pkt);
 				linkparam.u.utility.paramlen = len;
 				/* Param Data */
 				cp = linkparam.u.utility.params;
 				while (cfpkt_more(pkt) && len--) {
-					cfpkt_extr_head(pkt, &tmp, 1);
+					tmp = cfpkt_extr_head_u8(pkt);
 					*cp++ = tmp;
 				}
 				if (CFCTRL_ERR_BIT & cmdrsp)
 					break;
 				/* Link ID */
-				cfpkt_extr_head(pkt, &linkid, 1);
+				linkid = cfpkt_extr_head_u8(pkt);
 				/* Length */
-				cfpkt_extr_head(pkt, &len, 1);
+				len = cfpkt_extr_head_u8(pkt);
 				/* Param Data */
 				cfpkt_extr_head(pkt, &param, len);
 				break;
@@ -522,7 +516,7 @@ static int cfctrl_recv(struct cflayer *l
 		}
 		break;
 	case CFCTRL_CMD_LINK_DESTROY:
-		cfpkt_extr_head(pkt, &linkid, 1);
+		linkid = cfpkt_extr_head_u8(pkt);
 		cfctrl->res.linkdestroy_rsp(cfctrl->serv.layer.up, linkid);
 		break;
 	case CFCTRL_CMD_LINK_ERR:


