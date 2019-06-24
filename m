Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AABA5073A
	for <lists+stable@lfdr.de>; Mon, 24 Jun 2019 12:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbfFXKFn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jun 2019 06:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729970AbfFXKFm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jun 2019 06:05:42 -0400
Received: from localhost (f4.8f.5177.ip4.static.sl-reverse.com [119.81.143.244])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14D45212F5;
        Mon, 24 Jun 2019 10:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561370741;
        bh=CRSruYZNYZEsKMB0PpnlbwDxJmP7qjeeKQInSfEmv5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E5gtfy2EixQQzeeEoGw0X/30ViI+m1ojJ9aOY8GpQoZcbo2fkMm5BbS8VpxiNUqF0
         aUomvxv4UQw1qeMCGwcd+hfge/SkQ1k58g/Uo+DtFgHglYsBXcFrilLccL+eBs4Vdl
         v8FHt9NWB1OU6BWDfFx5+7m6Lk8AG1RlSh7qkTAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Fabio Estevam <festevam@gmail.com>,
        =?UTF-8?q?S=C3=A9bastien=20Szymanski?= 
        <sebastien.szymanski@armadeus.com>, Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.19 74/90] ARM: imx: cpuidle-imx6sx: Restrict the SW2ISO increase to i.MX6SX
Date:   Mon, 24 Jun 2019 17:57:04 +0800
Message-Id: <20190624092318.839626230@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190624092313.788773607@linuxfoundation.org>
References: <20190624092313.788773607@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit b25af2ff7c07bd19af74e3f64ff82e2880d13d81 upstream.

Since commit 1e434b703248 ("ARM: imx: update the cpu power up timing
setting on i.mx6sx") some characters loss is noticed on i.MX6ULL UART
as reported by Christoph Niedermaier.

The intention of such commit was to increase the SW2ISO field for i.MX6SX
only, but since cpuidle-imx6sx is also used on i.MX6UL/i.MX6ULL this caused
unintended side effects on other SoCs.

Fix this problem by keeping the original SW2ISO value for i.MX6UL/i.MX6ULL
and only increase SW2ISO in the i.MX6SX case.

Cc: stable@vger.kernel.org
Fixes: 1e434b703248 ("ARM: imx: update the cpu power up timing setting on i.mx6sx")
Reported-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Tested-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Tested-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/cpuidle-imx6sx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-imx/cpuidle-imx6sx.c
+++ b/arch/arm/mach-imx/cpuidle-imx6sx.c
@@ -15,6 +15,7 @@
 
 #include "common.h"
 #include "cpuidle.h"
+#include "hardware.h"
 
 static int imx6sx_idle_finish(unsigned long val)
 {
@@ -110,7 +111,7 @@ int __init imx6sx_cpuidle_init(void)
 	 * except for power up sw2iso which need to be
 	 * larger than LDO ramp up time.
 	 */
-	imx_gpc_set_arm_power_up_timing(0xf, 1);
+	imx_gpc_set_arm_power_up_timing(cpu_is_imx6sx() ? 0xf : 0x2, 1);
 	imx_gpc_set_arm_power_down_timing(1, 1);
 
 	return cpuidle_register(&imx6sx_cpuidle_driver, NULL);


