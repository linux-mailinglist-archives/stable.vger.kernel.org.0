Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F273EB894
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242706AbhHMPOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:14:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241779AbhHMPNR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:13:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C93260E9B;
        Fri, 13 Aug 2021 15:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867570;
        bh=iB7/2Bnh4HriCnWOa6F6mVAhXTtUh82kAFsJ2sU2ee4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qB3KrAf94e7HaDrOjAwm7ZegDAOJAhOuLXtpZjGbpBhblbW7LWQvcfc+qKOCWe3S4
         oKONvK5gKBBAg8amsPN17X6B6eTjo1ffbwcId1liZvKAxE17mDMTRYGgIWj2nCd1ur
         bf0AQM5gTx33L3JgpVMcQu4wTKcZqO+pKpAscug0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 09/11] ppp: Fix generating ppp unit id when ifname is not specified
Date:   Fri, 13 Aug 2021 17:07:16 +0200
Message-Id: <20210813150520.369066620@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.072304554@linuxfoundation.org>
References: <20210813150520.072304554@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 3125f26c514826077f2a4490b75e9b1c7a644c42 upstream.

When registering new ppp interface via PPPIOCNEWUNIT ioctl then kernel has
to choose interface name as this ioctl API does not support specifying it.

Kernel in this case register new interface with name "ppp<id>" where <id>
is the ppp unit id, which can be obtained via PPPIOCGUNIT ioctl. This
applies also in the case when registering new ppp interface via rtnl
without supplying IFLA_IFNAME.

PPPIOCNEWUNIT ioctl allows to specify own ppp unit id which will kernel
assign to ppp interface, in case this ppp id is not already used by other
ppp interface.

In case user does not specify ppp unit id then kernel choose the first free
ppp unit id. This applies also for case when creating ppp interface via
rtnl method as it does not provide a way for specifying own ppp unit id.

If some network interface (does not have to be ppp) has name "ppp<id>"
with this first free ppp id then PPPIOCNEWUNIT ioctl or rtnl call fails.

And registering new ppp interface is not possible anymore, until interface
which holds conflicting name is renamed. Or when using rtnl method with
custom interface name in IFLA_IFNAME.

As list of allocated / used ppp unit ids is not possible to retrieve from
kernel to userspace, userspace has no idea what happens nor which interface
is doing this conflict.

So change the algorithm how ppp unit id is generated. And choose the first
number which is not neither used as ppp unit id nor in some network
interface with pattern "ppp<id>".

This issue can be simply reproduced by following pppd call when there is no
ppp interface registered and also no interface with name pattern "ppp<id>":

    pppd ifname ppp1 +ipv6 noip noauth nolock local nodetach pty "pppd +ipv6 noip noauth nolock local nodetach notty"

Or by creating the one ppp interface (which gets assigned ppp unit id 0),
renaming it to "ppp1" and then trying to create a new ppp interface (which
will always fails as next free ppp unit id is 1, but network interface with
name "ppp1" exists).

This patch fixes above described issue by generating new and new ppp unit
id until some non-conflicting id with network interfaces is generated.

Signed-off-by: Pali Rohár <pali@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ppp/ppp_generic.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -287,7 +287,7 @@ static struct channel *ppp_find_channel(
 static int ppp_connect_channel(struct channel *pch, int unit);
 static int ppp_disconnect_channel(struct channel *pch);
 static void ppp_destroy_channel(struct channel *pch);
-static int unit_get(struct idr *p, void *ptr);
+static int unit_get(struct idr *p, void *ptr, int min);
 static int unit_set(struct idr *p, void *ptr, int n);
 static void unit_put(struct idr *p, int n);
 static void *unit_find(struct idr *p, int n);
@@ -963,9 +963,20 @@ static int ppp_unit_register(struct ppp
 	mutex_lock(&pn->all_ppp_mutex);
 
 	if (unit < 0) {
-		ret = unit_get(&pn->units_idr, ppp);
+		ret = unit_get(&pn->units_idr, ppp, 0);
 		if (ret < 0)
 			goto err;
+		if (!ifname_is_set) {
+			while (1) {
+				snprintf(ppp->dev->name, IFNAMSIZ, "ppp%i", ret);
+				if (!__dev_get_by_name(ppp->ppp_net, ppp->dev->name))
+					break;
+				unit_put(&pn->units_idr, ret);
+				ret = unit_get(&pn->units_idr, ppp, ret + 1);
+				if (ret < 0)
+					goto err;
+			}
+		}
 	} else {
 		/* Caller asked for a specific unit number. Fail with -EEXIST
 		 * if unavailable. For backward compatibility, return -EEXIST
@@ -3252,9 +3263,9 @@ static int unit_set(struct idr *p, void
 }
 
 /* get new free unit number and associate pointer with it */
-static int unit_get(struct idr *p, void *ptr)
+static int unit_get(struct idr *p, void *ptr, int min)
 {
-	return idr_alloc(p, ptr, 0, 0, GFP_KERNEL);
+	return idr_alloc(p, ptr, min, 0, GFP_KERNEL);
 }
 
 /* put unit number back to a pool */


