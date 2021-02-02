Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 941C830CC0C
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239809AbhBBTmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:42:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:41110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232905AbhBBNx4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:53:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C80F64FD1;
        Tue,  2 Feb 2021 13:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273460;
        bh=gI51k9d9SiKr8vQwrXcNwrN8V9AwpkdttioFwXxF9OE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHE8BKXuLbHjHyST9W44aQwpcUGKmhhatxBeDqsHAa/WbPDubCy/MVeAPM2s+Vf/n
         2eNgE1ThAGCl6Flh+KC7jcn5Gup1GXsKzy9jrxE7hIyUdOD1IfwhooPQ9/vq8WG+iF
         CEssQgE4WeiHW/5NQGWy4KimrbCkDrxdTpNfrv84=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Max Krummenacher <max.krummenacher@toradex.com>,
        Oleksandr Suvorov <oleksandr.suvorov@toradex.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.10 073/142] ARM: imx: build suspend-imx6.S with arm instruction set
Date:   Tue,  2 Feb 2021 14:37:16 +0100
Message-Id: <20210202133000.731230684@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
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
@@ -67,6 +67,7 @@
 #define MX6Q_CCM_CCR	0x0
 
 	.align 3
+	.arm
 
 	.macro  sync_l2_cache
 


