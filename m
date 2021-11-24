Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC37145C2E2
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347597AbhKXNeG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:34:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:57668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351440AbhKXNbn (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:31:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFEA761BC1;
        Wed, 24 Nov 2021 12:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758359;
        bh=iTIe+tzwDMl8swDkHkd8BHWOqtn7QkfBKkFbiUzNYLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2aQlyPSOOkx+HM+tPkbLkJRrQqVSyRu803KrlicKS9/GIwnO5rIPDr+0OQOpwbbqP
         wRjRGydX4+JKXEA0RoGirDHQ3gKWYb94yKYeCqdbKRg03JBJ+UpCEBESlpnE1H2sde
         CV0wmubIAV/UHAelAwAg5EOZNzjHidWSAxNSAjoA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/154] arm64: zynqmp: Do not duplicate flash partition label property
Date:   Wed, 24 Nov 2021 12:56:37 +0100
Message-Id: <20211124115702.410048058@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>

[ Upstream commit 167721a5909f867f8c18c8e78ea58e705ad9bbd4 ]

In kernel 5.4, support has been added for reading MTD devices via the nvmem
API.
For this the mtd devices are registered as read-only NVMEM providers under
sysfs with the same name as the flash partition label property.

So if flash partition label property of multiple flash devices are
identical then the second mtd device fails to get registered as a NVMEM
provider.

This patch fixes the issue by having different label property for different
flashes.

Signed-off-by: Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/6c4b9b9232b93d9e316a63c086540fd5bf6b8687.1623684253.git.michal.simek@xilinx.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts b/arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts
index 4a86efa32d687..f7124e15f0ff6 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts
@@ -131,7 +131,7 @@
 		reg = <0>;
 
 		partition@0 {
-			label = "data";
+			label = "spi0-data";
 			reg = <0x0 0x100000>;
 		};
 	};
@@ -149,7 +149,7 @@
 		reg = <0>;
 
 		partition@0 {
-			label = "data";
+			label = "spi1-data";
 			reg = <0x0 0x84000>;
 		};
 	};
-- 
2.33.0



