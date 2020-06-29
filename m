Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E44820E7FD
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgF2WCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:02:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgF2SfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6994E24147;
        Mon, 29 Jun 2020 15:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443939;
        bh=Juh4M+SC6Sr7mXiYuUHa6Dn1LDw5fGTbK0JF67n+rkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DCmXGfIOWqaG5tPEwZQ1AEPhiJgKG0ezUKivgR68oOqRR/zNbmUypGI4un7yrwHRj
         6XmFmLUYo6rc2mgtBChu3mHO7skKOcK6cCgzbxfWe3+w0K1WuENA+yRNLbPq0fSIsC
         GgfZVTWAy/C88H4BYe2n3eBhLFvc3ZdCwzZqLC/o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Aaron Ma <mapengyu@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 040/265] r8169: fix firmware not resetting tp->ocp_base
Date:   Mon, 29 Jun 2020 11:14:33 -0400
Message-Id: <20200629151818.2493727-41-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 89fbd26cca7ec9e82ec4787a4b6e95939b57d073 ]

Typically the firmware takes care that tp->ocp_base is reset to its
default value. That's not the case (at least) for RTL8117.
As a result subsequent PHY access reads/writes the wrong page and
the link is broken. Fix this be resetting tp->ocp_base explicitly.

Fixes: 229c1e0dfd3d ("r8169: load firmware for RTL8168fp/RTL8117")
Reported-by: Aaron Ma <mapengyu@gmail.com>
Tested-by: Aaron Ma <mapengyu@gmail.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c51b48dc36397..7bda2671bd5b6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2192,8 +2192,11 @@ static void rtl_release_firmware(struct rtl8169_private *tp)
 void r8169_apply_firmware(struct rtl8169_private *tp)
 {
 	/* TODO: release firmware if rtl_fw_write_firmware signals failure. */
-	if (tp->rtl_fw)
+	if (tp->rtl_fw) {
 		rtl_fw_write_firmware(tp, tp->rtl_fw);
+		/* At least one firmware doesn't reset tp->ocp_base. */
+		tp->ocp_base = OCP_STD_PHY_BASE;
+	}
 }
 
 static void rtl8168_config_eee_mac(struct rtl8169_private *tp)
-- 
2.25.1

