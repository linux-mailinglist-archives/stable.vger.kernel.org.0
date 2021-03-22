Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BF034417D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhCVMdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:55354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231142AbhCVMdD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:33:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F192619A9;
        Mon, 22 Mar 2021 12:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416382;
        bh=LLeOM1RpqA9mOvAYXPpXUzX0CoIVtFrjKnsMUAATMWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vHDVBBBEPpfT/H12eBQxpH8JfcA8VM4lHlOOLJbWV8iR29iLhWVxWWSbAKyQinA0d
         KqdHAoP5Df+Dn7wpW42mmcGLOgP8OOiG+caRrhWDThwwhmSscpR6KhpcSRNP9orbVk
         2BNmH/5B4pB7X4z/MIO0cLbHZOXBnkGwMEM3Mb/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.11 086/120] thunderbolt: Increase runtime PM reference count on DP tunnel discovery
Date:   Mon, 22 Mar 2021 13:27:49 +0100
Message-Id: <20210322121932.559062141@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit c94732bda079ee66b5c3904cbb628d0cb218ab39 upstream.

If the driver is unbound and then bound back it goes over the topology
and figure out the existing tunnels. However, if it finds DP tunnel it
should make sure the domain does not runtime suspend as otherwise it
will tear down the DP tunnel unexpectedly.

Fixes: 6ac6faee5d7d ("thunderbolt: Add runtime PM for Software CM")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/tb.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -138,6 +138,10 @@ static void tb_discover_tunnels(struct t
 				parent->boot = true;
 				parent = tb_switch_parent(parent);
 			}
+		} else if (tb_tunnel_is_dp(tunnel)) {
+			/* Keep the domain from powering down */
+			pm_runtime_get_sync(&tunnel->src_port->sw->dev);
+			pm_runtime_get_sync(&tunnel->dst_port->sw->dev);
 		}
 
 		list_add_tail(&tunnel->list, &tcm->tunnel_list);


