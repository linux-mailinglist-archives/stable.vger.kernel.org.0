Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C083C462597
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233280AbhK2WlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:41:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbhK2WkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:40:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D03C1A25E1;
        Mon, 29 Nov 2021 10:38:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 72E6ECE139A;
        Mon, 29 Nov 2021 18:38:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BCE3C53FCD;
        Mon, 29 Nov 2021 18:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211102;
        bh=HgY0O12w2U3h7fuzpxwZv9PksekHQrre0G5uYfF/Lu4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Trx8eIKaT8SeEluX6uN0OcxI7KWTsWVaB1UZZVcH9Lx6QaC8w3kRwM4ONjLUOA+C+
         3hIWV4em2oxLRoXOlynw6wmhjIC4zauhDwcrzftf9jBBpLNw2uwPglB3B9EjpGu9Vq
         7V7GNY3iPKBKMLdgc6pvGrUf6+7GzdbaXxp9hLCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Volodymyr Mytnyk <vmytnyk@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/179] net: marvell: prestera: fix brige port operation
Date:   Mon, 29 Nov 2021 19:18:07 +0100
Message-Id: <20211129181721.992836247@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Volodymyr Mytnyk <vmytnyk@marvell.com>

[ Upstream commit 253e9b4d11e577bb8cbc77ef68a9ff46438065ca ]

Return NOTIFY_DONE (dont't care) for switchdev notifications
that prestera driver don't know how to handle them.

With introduction of SWITCHDEV_BRPORT_[UN]OFFLOADED switchdev
events, the driver rejects adding swport to bridge operation
which is handled by prestera_bridge_port_join() func. The root
cause of this is that prestera driver returns error (EOPNOTSUPP)
in prestera_switchdev_blk_event() handler for unknown swdev
events. This causes switchdev_bridge_port_offload() to fail
when adding port to bridge in prestera_bridge_port_join().

Fixes: 957e2235e526 ("net: make switchdev_bridge_port_{,unoffload} loosely coupled with the bridge")
Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
index 3ce6ccd0f5394..79f2fca0d412d 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
@@ -1124,7 +1124,7 @@ static int prestera_switchdev_blk_event(struct notifier_block *unused,
 						     prestera_port_obj_attr_set);
 		break;
 	default:
-		err = -EOPNOTSUPP;
+		return NOTIFY_DONE;
 	}
 
 	return notifier_from_errno(err);
-- 
2.33.0



