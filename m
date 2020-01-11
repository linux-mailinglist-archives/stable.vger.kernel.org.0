Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F34FF137E79
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgAKKKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:10:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729346AbgAKKKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:10:23 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C4522064C;
        Sat, 11 Jan 2020 10:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737422;
        bh=6JimFqxy5aH8U83M64b4lV/Il/uPj2PHJLfndhZJCZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XuzjogU+g+bjI/whb+5hNjpzj1m4Jw1YMnrhezv+KAFCM7/EDgImHivPTZI8IIyn4
         GOONNp+LFg9T37zoaFK4eoCIbGd0pjCD4QTHVxR6lYJ1tK0heL8TI6NobmUnnD/GWl
         1SPryV4jDuLY73h9x0sAYCvv6TTc6luv7Ft0opaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Wahren <wahrenst@gmx.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/62] ARM: dts: bcm283x: Fix critical trip point
Date:   Sat, 11 Jan 2020 10:49:59 +0100
Message-Id: <20200111094843.479212698@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094837.425430968@linuxfoundation.org>
References: <20200111094837.425430968@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 30e647a764d446723a7e0fb08d209e0104f16173 ]

During definition of the CPU thermal zone of BCM283x SoC family there
was a misunderstanding of the meaning "criticial trip point" and the
thermal throttling range of the VideoCore firmware. The latter one takes
effect when the core temperature is at least 85 degree celsius or higher

So the current critical trip point doesn't make sense, because the
thermal shutdown appears before the firmware has a chance to throttle
the ARM core(s).

Fix these unwanted shutdowns by increasing the critical trip point
to a value which shouldn't be reached with working thermal throttling.

Fixes: 0fe4d2181cc4 ("ARM: dts: bcm283x: Add CPU thermal zone with 1 trip point")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm283x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/bcm283x.dtsi b/arch/arm/boot/dts/bcm283x.dtsi
index 4745e3c7806b..fdb018e1278f 100644
--- a/arch/arm/boot/dts/bcm283x.dtsi
+++ b/arch/arm/boot/dts/bcm283x.dtsi
@@ -38,7 +38,7 @@
 
 			trips {
 				cpu-crit {
-					temperature	= <80000>;
+					temperature	= <90000>;
 					hysteresis	= <0>;
 					type		= "critical";
 				};
-- 
2.20.1



