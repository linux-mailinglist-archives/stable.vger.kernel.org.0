Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D550B1BC956
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730794AbgD1Skl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:40:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730953AbgD1Skk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:40:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F39B720575;
        Tue, 28 Apr 2020 18:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099239;
        bh=C4T+9qNnW8xUkfV4aUIrKOLkJ/rwfdF2rXxGPscAWbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtHS7idhUpg+ypLWABEoh0jBfs3YPyqnsnFJ5TV7Klbm9tPHKRthWjOMY1+2p7h6m
         jx1gcktWGgYgNkaSrRnzymTb8sEarOYk6TMlZsvKWOCxCv+dLUXpQsPprl5d3NpB2q
         1/fkrLdtI8zYe3bLWgs9xLTy/3eKE9UigXTWKpSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sabrina Dubroca <sd@queasysnail.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 079/168] vxlan: use the correct nlattr array in NL_SET_ERR_MSG_ATTR
Date:   Tue, 28 Apr 2020 20:24:13 +0200
Message-Id: <20200428182242.170282676@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit cc8e7c69db4dcc565ed3020f97ddd6debab6cbe8 ]

IFLA_VXLAN_* attributes are in the data array, which is correctly
used when fetching the value, but not when setting the extended
ack. Because IFLA_VXLAN_MAX < IFLA_MAX, we avoid out of bounds
array accesses, but we don't provide a pointer to the invalid
attribute to userspace.

Fixes: 653ef6a3e4af ("vxlan: change vxlan_[config_]validate() to use netlink_ext_ack for error reporting")
Fixes: b4d3069783bc ("vxlan: Allow configuration of DF behaviour")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3144,7 +3144,7 @@ static int vxlan_validate(struct nlattr
 		u32 id = nla_get_u32(data[IFLA_VXLAN_ID]);
 
 		if (id >= VXLAN_N_VID) {
-			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_ID],
+			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_VXLAN_ID],
 					    "VXLAN ID must be lower than 16777216");
 			return -ERANGE;
 		}
@@ -3155,7 +3155,7 @@ static int vxlan_validate(struct nlattr
 			= nla_data(data[IFLA_VXLAN_PORT_RANGE]);
 
 		if (ntohs(p->high) < ntohs(p->low)) {
-			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_PORT_RANGE],
+			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_VXLAN_PORT_RANGE],
 					    "Invalid source port range");
 			return -EINVAL;
 		}
@@ -3165,7 +3165,7 @@ static int vxlan_validate(struct nlattr
 		enum ifla_vxlan_df df = nla_get_u8(data[IFLA_VXLAN_DF]);
 
 		if (df < 0 || df > VXLAN_DF_MAX) {
-			NL_SET_ERR_MSG_ATTR(extack, tb[IFLA_VXLAN_DF],
+			NL_SET_ERR_MSG_ATTR(extack, data[IFLA_VXLAN_DF],
 					    "Invalid DF attribute");
 			return -EINVAL;
 		}


