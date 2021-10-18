Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F90A4316D3
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 13:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhJRLIK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 07:08:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229491AbhJRLIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 07:08:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EFAE261212;
        Mon, 18 Oct 2021 11:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634555158;
        bh=BtZyDe9EkihfnCI1xvNTLHbKQX3QeSLq5XAKe9O5Szc=;
        h=Subject:To:Cc:From:Date:From;
        b=LyQ3I7jrwi8/7MF4uFOISg5uuCENiW30TAIq0bQ5Q1caMiskxKrmG7Nc5jpCmmlYJ
         xlackGic9+f7BbvkuUkcyTLQ3qzgdIh0uxJyF0yAOCI53BSKNuB1Cv49ucDLBwWJqG
         A3pYPlzqACLNMTI89lVUx85YiQnlWFy/jOsKHTkA=
Subject: FAILED: patch "[PATCH] net: dsa: fix spurious error message when unoffloaded port" failed to apply to 5.4-stable tree
To:     alsi@bang-olufsen.dk, f.fainelli@gmail.com, kuba@kernel.org,
        olteanv@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 Oct 2021 13:05:55 +0200
Message-ID: <1634555155249157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 43a4b4dbd48c9006ef64df3a12acf33bdfe11c61 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Date: Tue, 12 Oct 2021 13:27:31 +0200
Subject: [PATCH] net: dsa: fix spurious error message when unoffloaded port
 leaves bridge
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Flip the sign of a return value check, thereby suppressing the following
spurious error:

  port 2 failed to notify DSA_NOTIFIER_BRIDGE_LEAVE: -EOPNOTSUPP

... which is emitted when removing an unoffloaded DSA switch port from a
bridge.

Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20211012112730.3429157-1-alvin@pqrs.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 1c797ec8e2c2..6466d0539af9 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -168,7 +168,7 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 		if (extack._msg)
 			dev_err(ds->dev, "port %d: %s\n", info->port,
 				extack._msg);
-		if (err && err != EOPNOTSUPP)
+		if (err && err != -EOPNOTSUPP)
 			return err;
 	}
 

