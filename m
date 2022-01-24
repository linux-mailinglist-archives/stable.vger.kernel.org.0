Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99763497E72
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238087AbiAXMFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238097AbiAXMFw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:05:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E79C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 04:05:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0AFC60E2C
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 12:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B72CC340E1;
        Mon, 24 Jan 2022 12:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643025951;
        bh=eUym4rHjy8COo+KlrcigvW+T+ujurMRlQ+hAT8Cq6/A=;
        h=Subject:To:Cc:From:Date:From;
        b=zdbV+rgkA5lSEdS2WaFlAoU3WNml8C+T5VwlpQiTQS7ixQuC9nnq3qbbtwrVGyTTQ
         Y78Z7fmco9xUlmlsiRL3BsBoMqmsKXx2GhyjK+GXrlVn8xz9ZUvGcjOeJuBKNEXXDo
         aIyAnu3RL2vInZAaCipL369/H1+ACYSGfzQTFmjo=
Subject: FAILED: patch "[PATCH] net: dsa: mv88e6xxx: Add tx fwd offload PVT on intermediate" failed to apply to 5.15-stable tree
To:     tobias@waldekranz.com, davem@davemloft.net, vladimir.oltean@nxp.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 13:05:48 +0100
Message-ID: <16430259482449@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e0068620e5e1779b3d5bb5649cd196e1cbf277a9 Mon Sep 17 00:00:00 2001
From: Tobias Waldekranz <tobias@waldekranz.com>
Date: Thu, 9 Dec 2021 23:24:24 +0100
Subject: [PATCH] net: dsa: mv88e6xxx: Add tx fwd offload PVT on intermediate
 devices

In a typical mv88e6xxx switch tree like this:

  CPU
   |    .----.
.--0--. | .--0--.
| sw0 | | | sw1 |
'-1-2-' | '-1-2-'
    '---'

If sw1p{1,2} are added to a bridge that sw0p1 is not a part of, sw0
still needs to add a crosschip PVT entry for the virtual DSA device
assigned to represent the bridge.

Fixes: ce5df6894a57 ("net: dsa: mv88e6xxx: map virtual bridges with forwarding offload in the PVT")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 45aaa7333fb8..dced1505e6bf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2531,6 +2531,7 @@ static int mv88e6xxx_crosschip_bridge_join(struct dsa_switch *ds,
 
 	mv88e6xxx_reg_lock(chip);
 	err = mv88e6xxx_pvt_map(chip, sw_index, port);
+	err = err ? : mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num);
 	mv88e6xxx_reg_unlock(chip);
 
 	return err;
@@ -2546,7 +2547,8 @@ static void mv88e6xxx_crosschip_bridge_leave(struct dsa_switch *ds,
 		return;
 
 	mv88e6xxx_reg_lock(chip);
-	if (mv88e6xxx_pvt_map(chip, sw_index, port))
+	if (mv88e6xxx_pvt_map(chip, sw_index, port) ||
+	    mv88e6xxx_map_virtual_bridge_to_pvt(ds, bridge.num))
 		dev_err(ds->dev, "failed to remap cross-chip Port VLAN\n");
 	mv88e6xxx_reg_unlock(chip);
 }

