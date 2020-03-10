Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD71C17FD72
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgCJMyi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:54:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728592AbgCJMyi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:54:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAFBA20674;
        Tue, 10 Mar 2020 12:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844876;
        bh=gIJfk8IWJAFC8UyqBhu4d6Moz8REygtxs5NtIhfu6r4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jew00Jr6ocXMcyr2wfGo9HqDQpXEYHj72AfY9cvtC6dBLNXdzxhkOOUQbkDEM3Ab9
         iP4Kv1fOSnIRULlUa7a970fj/iLGVcyJhFRJrFwvceNy2aju72vTWnqhlC7LhB56eB
         eXRSwvzgUj4nuyzUY4Xwb4eOOjgGrKMZYIpu4ATo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.4 113/168] ARM: dts: ls1021a: Restore MDIO compatible to gianfar
Date:   Tue, 10 Mar 2020 13:39:19 +0100
Message-Id: <20200310123646.838599358@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

commit 7155c44624d061692b4c13aa8343f119c67d4fc0 upstream.

The difference between "fsl,etsec2-mdio" and "gianfar" has to do with
the .get_tbipa function, which calculates the address of the TBIPA
register automatically, if not explicitly specified. [ see
drivers/net/ethernet/freescale/fsl_pq_mdio.c ]. On LS1021A, the TBIPA
register is at offset 0x30 within the port register block, which is what
the "gianfar" method of calculating addresses actually does.

Luckily, the bad "compatible" is inconsequential for ls1021a.dtsi,
because the TBIPA register is explicitly specified via the second "reg"
(<0x0 0x2d10030 0x0 0x4>), so the "get_tbipa" function is dead code.
Nonetheless it's good to restore it to its correct value.

Background discussion:
https://www.spinics.net/lists/stable/msg361156.html

Fixes: c7861adbe37f ("ARM: dts: ls1021: Fix SGMII PCS link remaining down after PHY disconnect")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/ls1021a.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -728,7 +728,7 @@
 		};
 
 		mdio0: mdio@2d24000 {
-			compatible = "fsl,etsec2-mdio";
+			compatible = "gianfar";
 			device_type = "mdio";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -737,7 +737,7 @@
 		};
 
 		mdio1: mdio@2d64000 {
-			compatible = "fsl,etsec2-mdio";
+			compatible = "gianfar";
 			device_type = "mdio";
 			#address-cells = <1>;
 			#size-cells = <0>;


