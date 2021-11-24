Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305C045C130
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347117AbhKXNP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:15:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348548AbhKXNN0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:13:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 12E5B61250;
        Wed, 24 Nov 2021 12:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757786;
        bh=TA9Dl/ScuqngS+/mEndKBNYaVK/RfUMSBgmF4neBW/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NG0jZdldOC7SQEzcYtNDBJssqcroMW5UMdugGeDIYKEYmdvJCmItOQOL5SN1BWPCt
         KOKW+91fXbBuqALG+PxhiTrESgRTGHd8YWKEYTjmZomqORjJFiUhnnIk/7M0KwLCa8
         kuPmVMuXLrUz8xnnB/3E75ksqRO4wvoj763CfAec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Amit Kumar Mahapatra <amit.kumar-mahapatra@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 259/323] arm64: zynqmp: Do not duplicate flash partition label property
Date:   Wed, 24 Nov 2021 12:57:29 +0100
Message-Id: <20211124115727.630114818@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
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
index 11cc67184fa9f..f1edd7fcef764 100644
--- a/arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts
+++ b/arch/arm64/boot/dts/xilinx/zynqmp-zc1751-xm016-dc2.dts
@@ -130,7 +130,7 @@
 		reg = <0>;
 
 		partition@0 {
-			label = "data";
+			label = "spi0-data";
 			reg = <0x0 0x100000>;
 		};
 	};
@@ -148,7 +148,7 @@
 		reg = <0>;
 
 		partition@0 {
-			label = "data";
+			label = "spi1-data";
 			reg = <0x0 0x84000>;
 		};
 	};
-- 
2.33.0



