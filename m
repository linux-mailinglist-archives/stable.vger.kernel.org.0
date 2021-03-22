Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69563442A2
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:44:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhCVMoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:33602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232329AbhCVMmS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A338460C3D;
        Mon, 22 Mar 2021 12:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416794;
        bh=LLeOM1RpqA9mOvAYXPpXUzX0CoIVtFrjKnsMUAATMWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vZbz9Nv6w7nUpj7ioPX14CabxkrtDuLfTSiQDsz0wBYjgYxXBpDhn3hu4frY4Mj9E
         UmgHEYvU0wGQ/9hVe4TVYY06K/NpFe/S1G6/uD3F2aLlAwwsceIaLPBey/RcOzWo5s
         77diBVo/ZRAfldzVzv0BrH6jctCSUHSmjjOXHdpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 124/157] thunderbolt: Increase runtime PM reference count on DP tunnel discovery
Date:   Mon, 22 Mar 2021 13:28:01 +0100
Message-Id: <20210322121937.693163691@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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


