Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EEB111B494
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732331AbfLKPZC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:25:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:56636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732298AbfLKPZC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:25:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5100A208C3;
        Wed, 11 Dec 2019 15:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077901;
        bh=/Zif4uWKD1RHanMwW7vj4iDoxzD+4l8j/RzYttuP+dU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DPht5qGdjqy446C07mpnXotlwrGr1DODps43M4yhhOSS1K3c+4XXyeMQVdjjGRBfM
         cH/Be2cPOH+e+OUpgehqP8QaAxbAk79+aTL91aqT8D8yrCEpAjprB7TTaxM8tz1Tn1
         oykbJG++YYjmgKQ6wtlHd5e3Kzkn/F3XGeVgH5n4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julien Floret <julien.floret@6wind.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 4.19 214/243] xfrm interface: fix list corruption for x-netns
Date:   Wed, 11 Dec 2019 16:06:16 +0100
Message-Id: <20191211150353.790316307@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>

commit c5d1030f23002430c2a336b2b629b9d6f72b3564 upstream.

dev_net(dev) is the netns of the device and xi->net is the link netns,
where the device has been linked.
changelink() must operate in the link netns to avoid a corruption of
the xfrm lists.

Note that xi->net and dev_net(xi->physdev) are always the same.

Before the patch, the xfrmi lists may be corrupted and can later trigger a
kernel panic.

Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
Reported-by: Julien Floret <julien.floret@6wind.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Julien Floret <julien.floret@6wind.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_interface.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -505,7 +505,7 @@ static int xfrmi_change(struct xfrm_if *
 
 static int xfrmi_update(struct xfrm_if *xi, struct xfrm_if_parms *p)
 {
-	struct net *net = dev_net(xi->dev);
+	struct net *net = xi->net;
 	struct xfrmi_net *xfrmn = net_generic(net, xfrmi_net_id);
 	int err;
 
@@ -674,9 +674,9 @@ static int xfrmi_changelink(struct net_d
 			   struct nlattr *data[],
 			   struct netlink_ext_ack *extack)
 {
-	struct net *net = dev_net(dev);
+	struct xfrm_if *xi = netdev_priv(dev);
+	struct net *net = xi->net;
 	struct xfrm_if_parms p;
-	struct xfrm_if *xi;
 
 	xfrmi_netlink_parms(data, &p);
 	xi = xfrmi_locate(net, &p);
@@ -718,7 +718,7 @@ struct net *xfrmi_get_link_net(const str
 {
 	struct xfrm_if *xi = netdev_priv(dev);
 
-	return dev_net(xi->phydev);
+	return xi->net;
 }
 
 static const struct nla_policy xfrmi_policy[IFLA_XFRM_MAX + 1] = {


