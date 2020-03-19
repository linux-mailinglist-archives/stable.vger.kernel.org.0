Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5775C18B698
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbgCSN1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:55454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730737AbgCSN1P (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:27:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 738AB207FC;
        Thu, 19 Mar 2020 13:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624434;
        bh=Ga1wbWDQiSyIK3IRl0E8Lde9WoZlLk82AH/T4G6Jpn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcBnD+ieuP1H31iRH+xJKBr0FPt6P0tVuUddTUJo1DV0f6MHmsgQyk9J8bKbxJOJ+
         OZsyy1ub0F8kL+S2AewITPzcUdvm8KFqm/djnnPOBMtH6UTSdlSWulv2ABdyOTzaYe
         /Qu5hYu5eDI3uDv6JLG7Eu9t2+2FDHFgEMLfVkro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.5 59/65] ARM: 8957/1: VDSO: Match ARMv8 timer in cntvct_functional()
Date:   Thu, 19 Mar 2020 14:04:41 +0100
Message-Id: <20200319123944.904257080@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 45939ce292b4b11159719faaf60aba7d58d5fe33 upstream.

It is possible for a system with an ARMv8 timer to run a 32-bit kernel.
When this happens we will unconditionally have the vDSO code remove the
__vdso_gettimeofday and __vdso_clock_gettime symbols because
cntvct_functional() returns false since it does not match that
compatibility string.

Fixes: ecf99a439105 ("ARM: 8331/1: VDSO initialization, mapping, and synchronization")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/vdso.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -95,6 +95,8 @@ static bool __init cntvct_functional(voi
 	 */
 	np = of_find_compatible_node(NULL, NULL, "arm,armv7-timer");
 	if (!np)
+		np = of_find_compatible_node(NULL, NULL, "arm,armv8-timer");
+	if (!np)
 		goto out_put;
 
 	if (of_property_read_bool(np, "arm,cpu-registers-not-fw-configured"))


