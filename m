Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A493E7FC9
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 19:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbhHJRnC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 13:43:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234787AbhHJRky (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 13:40:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8929661102;
        Tue, 10 Aug 2021 17:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617088;
        bh=ovw7sryc7RFY+mrCcUXN29YjIr19p+SaPik0bUhNu0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ih049JWlV1e+22/BRKMfmU7UX1SZhr/Mp0d9eSza08x9iKcwhWUpp6ELagDjxDU0O
         ZM+4D7UvH2e+hhB/4HHZ2wxrye0vFj8XgaFnSDdt0TYKlKkyli/78ahgRJzelS+VYe
         2jvCd/81yav7vNyq+qE3bsTej+3qwDFhu9EhlI1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 009/135] arm64: dts: ls1028: sl28: fix networking for variant 2
Date:   Tue, 10 Aug 2021 19:29:03 +0200
Message-Id: <20210810172955.994694370@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810172955.660225700@linuxfoundation.org>
References: <20210810172955.660225700@linuxfoundation.org>
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



