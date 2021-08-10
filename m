Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB8E3E80B2
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhHJRv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237173AbhHJRuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:50:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A48B6124A;
        Tue, 10 Aug 2021 17:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617337;
        bh=ovw7sryc7RFY+mrCcUXN29YjIr19p+SaPik0bUhNu0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O3UQbTbaH8PaEQ+PgVbyNpu2XkISREKEvdpUT0qG+0a+dBVUEGvd5fuDh7SPGW4Y8
         t5EXSrD1s/wTIrKbFb/4HGXvRYOE+oYMGx3GLvE+Mb8pY7lUck8U/DZTjbSSJ6QJEC
         tl2V3bL7iwSocK6FAnqeuSKDVh6dKbGD+LUE9jTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 015/175] arm64: dts: ls1028: sl28: fix networking for variant 2
Date:   Tue, 10 Aug 2021 19:28:43 +0200
Message-Id: <20210810173001.447499959@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 29f6a20c21b5bdc7eb623a712bbf7b99612ee746 ]

The PHY configuration for the variant 2 is still missing the flag for
in-band signalling between PHY and MAC. Both sides - MAC and PHY - have
to match the setting. For now, Linux only supports setting the MAC side
and thus it has to match the setting the bootloader is configuring.
Enable in-band signalling to make ethernet work.

Fixes: ab43f0307449 ("arm64: dts: ls1028a: sl28: add support for variant 2")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
index dd764b720fb0..f6a79c8080d1 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts
@@ -54,6 +54,7 @@
 
 &mscc_felix_port0 {
 	label = "swp0";
+	managed = "in-band-status";
 	phy-handle = <&phy0>;
 	phy-mode = "sgmii";
 	status = "okay";
@@ -61,6 +62,7 @@
 
 &mscc_felix_port1 {
 	label = "swp1";
+	managed = "in-band-status";
 	phy-handle = <&phy1>;
 	phy-mode = "sgmii";
 	status = "okay";
-- 
2.30.2



