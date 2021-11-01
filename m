Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7CEB44165E
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhKAJYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232424AbhKAJXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:23:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA9C0611C0;
        Mon,  1 Nov 2021 09:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758441;
        bh=vxivwbN3xrLwL9Qii4HTlbOip8RqM4fbnXdudPk2uv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTBP+Hac09Ummt65UwwdyWPO3chm0VpVv43PQWqNdX/mKRkIrWPKE5NSZy0u/olPW
         pyJGnQyvScYUJZ8BrIvfndhWwAuLjm8nN5sMnzPf6z09FEgrPsyGifpXTxhGwzmh4u
         DpMQRDPEJmb9y3rzPDuzXNevgjBdS8t4q2Tk1UYk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.14 03/25] ARM: 9139/1: kprobes: fix arch_init_kprobes() prototype
Date:   Mon,  1 Nov 2021 10:17:15 +0100
Message-Id: <20211101082447.810400404@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082447.070493993@linuxfoundation.org>
References: <20211101082447.070493993@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 1f323127cab086e4fd618981b1e5edc396eaf0f4 upstream.

With extra warnings enabled, gcc complains about this function
definition:

arch/arm/probes/kprobes/core.c: In function 'arch_init_kprobes':
arch/arm/probes/kprobes/core.c:465:12: warning: old-style function definition [-Wold-style-definition]
  465 | int __init arch_init_kprobes()

Link: https://lore.kernel.org/all/20201027093057.c685a14b386acacb3c449e3d@kernel.org/

Fixes: 24ba613c9d6c ("ARM kprobes: core code")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/probes/kprobes/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/probes/kprobes/core.c
+++ b/arch/arm/probes/kprobes/core.c
@@ -669,7 +669,7 @@ static struct undef_hook kprobes_arm_bre
 
 #endif /* !CONFIG_THUMB2_KERNEL */
 
-int __init arch_init_kprobes()
+int __init arch_init_kprobes(void)
 {
 	arm_probes_decode_init();
 #ifdef CONFIG_THUMB2_KERNEL


