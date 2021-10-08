Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2CBF4269A1
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241897AbhJHLjj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:39:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242892AbhJHLiT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:38:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80C9661529;
        Fri,  8 Oct 2021 11:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692793;
        bh=GDAu1TC/3OS3hX7fN6c3ObQAgzdo6yxE4yCplAQBVXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TeKEonYdxXwbykp/lRxjj0DK+U0EEVPHv4hw0Og87JNrvo0rQFa3D9M9b7iqIBQK8
         3dbQMyKkVB51/8TUgI1337jFeBiBAnCgJQTYJ64oXAlg27X3H+LNhuHDdtaCNWAiqB
         irSlyIqEsRxeruI7MqCEuercDPsEQp1f6piqXT6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.14 48/48] Revert "ARM: imx6q: drop of_platform_default_populate() from init_machine"
Date:   Fri,  8 Oct 2021 13:28:24 +0200
Message-Id: <20211008112721.659976094@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
References: <20211008112720.008415452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

commit 4497b40ca8217fce9f33c9886f5a1b0408661e03 upstream.

This reverts commit cc8870bf4c3ab0af385538460500a9d342ed945f.

Since commit cc8870bf4c3a ("ARM: imx6q: drop of_platform_default_populate()
from init_machine") the following errors are seen on boot:

[    0.123372] imx6q_suspend_init: failed to find ocram device!
[    0.123537] imx6_pm_common_init: No DDR LPM support with suspend -19!

, which break suspend/resume on imx6q/dl.

Revert the offeding commit to avoid the regression.

Thanks to Tim Harvey for bisecting this problem.

Cc: stable@vger.kernel.org
Fixes: cc8870bf4c3a ("ARM: imx6q: drop of_platform_default_populate() from  init_machine")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/mach-imx/mach-imx6q.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/mach-imx/mach-imx6q.c
+++ b/arch/arm/mach-imx/mach-imx6q.c
@@ -172,6 +172,9 @@ static void __init imx6q_init_machine(vo
 				imx_get_soc_revision());
 
 	imx6q_enet_phy_init();
+
+	of_platform_default_populate(NULL, NULL, NULL);
+
 	imx_anatop_init();
 	cpu_is_imx6q() ?  imx6q_pm_init() : imx6dl_pm_init();
 	imx6q_1588_init();


