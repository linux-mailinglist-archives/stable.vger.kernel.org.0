Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E2B49994C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1453971AbiAXVbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1450885AbiAXVVm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:21:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 871D8C0617AB;
        Mon, 24 Jan 2022 12:16:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25865611CD;
        Mon, 24 Jan 2022 20:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0822EC340E5;
        Mon, 24 Jan 2022 20:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055389;
        bh=lvp0Le3VVEXhImapXju5LURgBY2c/1oUn9iXm9ZTrnQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wX9tjvi4ij94AxpEV8naTsfQ1Q1q8+W4yiTGA+gCVA9rOBBwuXbL1/UPZmPYPqzIs
         hZh7zPgLDIrdQj0AJ/U6sOlyIjIlW/yaTL5fz6+kIEyyra9O3DXPSUo7NtGyNSgD5/
         FlIFYGj+KMh2BeYhCXL1mvXA1RM9l5teMmTFkBlc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Biju Das <biju.das.jz@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/846] arm64: dts: renesas: cat875: Add rx/tx delays
Date:   Mon, 24 Jan 2022 19:34:12 +0100
Message-Id: <20220124184105.654897363@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit e1a9faddffe7e555304dc2e3284c84fbee0679ee ]

The CAT875 sub board from Silicon Linux uses a Realtek PHY.

The phy driver commit bbc4d71d63549bcd003 ("net: phy: realtek: fix
rtl8211e rx/tx delay config") introduced NFS mount failures.  Now it
needs both rx/tx delays for the NFS mount to work.

This patch fixes the NFS mount failure issue by adding "rgmii-id" mode
to the avb device node.

Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Fixes: bbc4d71d63549bcd ("net: phy: realtek: fix rtl8211e rx/tx delay config")
Link: https://lore.kernel.org/r/20211115142830.12651-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/cat875.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/renesas/cat875.dtsi b/arch/arm64/boot/dts/renesas/cat875.dtsi
index 801ea54b027c4..20f8adc635e72 100644
--- a/arch/arm64/boot/dts/renesas/cat875.dtsi
+++ b/arch/arm64/boot/dts/renesas/cat875.dtsi
@@ -18,6 +18,7 @@
 	pinctrl-names = "default";
 	renesas,no-ether-link;
 	phy-handle = <&phy0>;
+	phy-mode = "rgmii-id";
 	status = "okay";
 
 	phy0: ethernet-phy@0 {
-- 
2.34.1



