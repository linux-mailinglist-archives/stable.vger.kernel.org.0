Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73DA302AC2
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbhAYSv6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:51:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730565AbhAYSvo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 628BA22EBD;
        Mon, 25 Jan 2021 18:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600683;
        bh=FgjfKD7AQhM1oaPnIOP66n285DWl8xk47mn+TxxvEks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QDEbAQFF3QQoOmMeYmTt86tUCEOBcBPjXa3ZDmMrYw0YH1z+FnRl66/Y4F32Hd6jL
         AEGFPZmgMEcb6PivXW5ntkzmMTedXbuBbzgwaYkPx0gDJmFgv4zhXCn+ZeJ7yFdpXG
         +A649zaPQyAWNReMgLYrbdZmB/HdVGo8IrWvAkgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/199] i2c: sprd: depend on COMMON_CLK to fix compile tests
Date:   Mon, 25 Jan 2021 19:38:52 +0100
Message-Id: <20210125183220.900615564@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 9ecd1d2b302b600351fac50779f43fcb680c1a16 ]

The I2C_SPRD uses Common Clock Framework thus it cannot be built on
platforms without it (e.g. compile test on MIPS with LANTIQ):

    /usr/bin/mips-linux-gnu-ld: drivers/i2c/busses/i2c-sprd.o: in function `sprd_i2c_probe':
    i2c-sprd.c:(.text.sprd_i2c_probe+0x254): undefined reference to `clk_set_parent'

Fixes: 4a2d5f663dab ("i2c: Enable compile testing for more drivers")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang7@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index a49e0ed4a599d..7e693dcbdd196 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -1012,6 +1012,7 @@ config I2C_SIRF
 config I2C_SPRD
 	tristate "Spreadtrum I2C interface"
 	depends on I2C=y && (ARCH_SPRD || COMPILE_TEST)
+	depends on COMMON_CLK
 	help
 	  If you say yes to this option, support will be included for the
 	  Spreadtrum I2C interface.
-- 
2.27.0



