Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CB4431EAB
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbhJROFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233271AbhJROCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:02:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2FFD76103D;
        Mon, 18 Oct 2021 13:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564581;
        bh=8T5tzKoxcRi2/Mgoz3xkE7pPt8swmep6grCBvCsKd5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZ1+7mPc0QlmpL0pua1tWm0OSOLOHdMH6mDQ87t+TDVTmfwA4DZC+t/hVUW1ir2Da
         OCnuV0tbcjUIqfxBHrj8l+MZPZ64ebrHO8UQImuwicH13cL+X+Y+FRBhrVifB4gHsn
         4RZyH3sgSlpX72A9sKoj+RqfPIjcvGj2cU6mVFg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.14 111/151] net: dsa: fix spurious error message when unoffloaded port leaves bridge
Date:   Mon, 18 Oct 2021 15:24:50 +0200
Message-Id: <20211018132344.279511989@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

commit 43a4b4dbd48c9006ef64df3a12acf33bdfe11c61 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dsa/switch.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -148,7 +148,7 @@ static int dsa_switch_bridge_leave(struc
 		if (extack._msg)
 			dev_err(ds->dev, "port %d: %s\n", info->port,
 				extack._msg);
-		if (err && err != EOPNOTSUPP)
+		if (err && err != -EOPNOTSUPP)
 			return err;
 	}
 	return 0;


