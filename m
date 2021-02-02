Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C04130C110
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234183AbhBBOMz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 09:12:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234033AbhBBOLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:11:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F01864FA9;
        Tue,  2 Feb 2021 13:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273915;
        bh=ecQa8LHiurxs3y103kI0B0ZtaKy0+Ngq7af/JCuEj4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=joTGJ+rhmIyfm6XBlni5jM6sowUJb0jeLaXadbZ5e8AlIaKDMrTyyNR3hU5kNH4Jv
         4o1PczD09Dpk+0L8uX9ttCKmvbyCaIu/fGvLYc5fErbrF8IxSLHTq8R5oOyhl3pkGs
         0Yzwktlfv96yBjitJXD6hX9s9351IeyD0e3A/yDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Max Krummenacher <max.krummenacher@toradex.com>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.14 15/30] ARM: imx: build suspend-imx6.S with arm instruction set
Date:   Tue,  2 Feb 2021 14:38:56 +0100
Message-Id: <20210202132942.764751292@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132942.138623851@linuxfoundation.org>
References: <20210202132942.138623851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Krummenacher <max.oss.09@gmail.com>

commit a88afa46b86ff461c89cc33fc3a45267fff053e8 upstream.

When the kernel is configured to use the Thumb-2 instruction set
"suspend-to-memory" fails to resume. Observed on a Colibri iMX6ULL
(i.MX 6ULL) and Apalis iMX6 (i.MX 6Q).

It looks like the CPU resumes unconditionally in ARM instruction mode
and then chokes on the presented Thumb-2 code it should execute.

Fix this by using the arm instruction set for all code in
suspend-imx6.S.

Signed-off-by: Max Krummenacher <max.krummenacher@toradex.com>
Fixes: df595746fa69 ("ARM: imx: add suspend in ocram support for i.mx6q")
Acked-by: Oleksandr Suvorov <oleksandr.suvorov@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/suspend-imx6.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/mach-imx/suspend-imx6.S
+++ b/arch/arm/mach-imx/suspend-imx6.S
@@ -73,6 +73,7 @@
 #define MX6Q_CCM_CCR	0x0
 
 	.align 3
+	.arm
 
 	.macro  sync_l2_cache
 


