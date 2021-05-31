Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777FB395D59
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbhEaNow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:44:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232842AbhEaNmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEE066147F;
        Mon, 31 May 2021 13:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467708;
        bh=d31Yhnkyy17E4yy6rXixvQwo0TFmxk7sTDaVwYUlXLg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAdDPCdH/v9Ocv4o3zeJZM8aq1qMIJQqA1q1u5WOYxuLA3Lz+7hc4ZGgLsGYbcMGP
         +pxn1rDcvIsDpjf59nyK2zqDazPWInQ6C+DT0gyV0qeAOAtld0naMSmlCW6dUWnCnl
         wUD94/jpdQBkrnOnAFQxAuszTY7c+GiyOxrBqVfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Phillip Potter <phil@philpotter.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 51/79] isdn: mISDNinfineon: check/cleanup ioremap failure correctly in setup_io
Date:   Mon, 31 May 2021 15:14:36 +0200
Message-Id: <20210531130637.642460789@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130636.002722319@linuxfoundation.org>
References: <20210531130636.002722319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

[ Upstream commit c446f0d4702d316e1c6bf621f70e79678d28830a ]

Move hw->cfg.mode and hw->addr.mode assignments from hw->ci->cfg_mode
and hw->ci->addr_mode respectively, to be before the subsequent checks
for memory IO mode (and possible ioremap calls in this case).

Also introduce ioremap error checks at both locations. This allows
resources to be properly freed on ioremap failure, as when the caller
of setup_io then subsequently calls release_io via its error path,
release_io can now correctly determine the mode as it has been set
before the ioremap call.

Finally, refactor release_io function so that it will call
release_mem_region in the memory IO case, regardless of whether or not
hw->cfg.p/hw->addr.p are NULL. This means resources are then properly
released on failure.

This properly implements the original reverted commit (d721fe99f6ad)
from the University of Minnesota, whilst also implementing the ioremap
check for the hw->ci->cfg_mode if block as well.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20210503115736.2104747-42-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/hardware/mISDN/mISDNinfineon.c | 24 ++++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/mISDNinfineon.c b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
index d5bdbaf93a1a..d0b6377b9834 100644
--- a/drivers/isdn/hardware/mISDN/mISDNinfineon.c
+++ b/drivers/isdn/hardware/mISDN/mISDNinfineon.c
@@ -645,17 +645,19 @@ static void
 release_io(struct inf_hw *hw)
 {
 	if (hw->cfg.mode) {
-		if (hw->cfg.p) {
+		if (hw->cfg.mode == AM_MEMIO) {
 			release_mem_region(hw->cfg.start, hw->cfg.size);
-			iounmap(hw->cfg.p);
+			if (hw->cfg.p)
+				iounmap(hw->cfg.p);
 		} else
 			release_region(hw->cfg.start, hw->cfg.size);
 		hw->cfg.mode = AM_NONE;
 	}
 	if (hw->addr.mode) {
-		if (hw->addr.p) {
+		if (hw->addr.mode == AM_MEMIO) {
 			release_mem_region(hw->addr.start, hw->addr.size);
-			iounmap(hw->addr.p);
+			if (hw->addr.p)
+				iounmap(hw->addr.p);
 		} else
 			release_region(hw->addr.start, hw->addr.size);
 		hw->addr.mode = AM_NONE;
@@ -685,9 +687,12 @@ setup_io(struct inf_hw *hw)
 				(ulong)hw->cfg.start, (ulong)hw->cfg.size);
 			return err;
 		}
-		if (hw->ci->cfg_mode == AM_MEMIO)
-			hw->cfg.p = ioremap(hw->cfg.start, hw->cfg.size);
 		hw->cfg.mode = hw->ci->cfg_mode;
+		if (hw->ci->cfg_mode == AM_MEMIO) {
+			hw->cfg.p = ioremap(hw->cfg.start, hw->cfg.size);
+			if (!hw->cfg.p)
+				return -ENOMEM;
+		}
 		if (debug & DEBUG_HW)
 			pr_notice("%s: IO cfg %lx (%lu bytes) mode%d\n",
 				  hw->name, (ulong)hw->cfg.start,
@@ -712,9 +717,12 @@ setup_io(struct inf_hw *hw)
 				(ulong)hw->addr.start, (ulong)hw->addr.size);
 			return err;
 		}
-		if (hw->ci->addr_mode == AM_MEMIO)
-			hw->addr.p = ioremap(hw->addr.start, hw->addr.size);
 		hw->addr.mode = hw->ci->addr_mode;
+		if (hw->ci->addr_mode == AM_MEMIO) {
+			hw->addr.p = ioremap(hw->addr.start, hw->addr.size);
+			if (!hw->addr.p)
+				return -ENOMEM;
+		}
 		if (debug & DEBUG_HW)
 			pr_notice("%s: IO addr %lx (%lu bytes) mode%d\n",
 				  hw->name, (ulong)hw->addr.start,
-- 
2.30.2



