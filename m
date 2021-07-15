Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551363CAADD
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243580AbhGOTPs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244436AbhGOTOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A05D613FC;
        Thu, 15 Jul 2021 19:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376229;
        bh=vyj3stJ8GDoobQWKF9oJ1Xi5HvGchXFYvMePAOqiv6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BvoZX0hxQwbkkMfY7oghif8SgMgYSMxLB3Khv+ROTNngi8OZ1ffdhP/iUSHGHtDIn
         S5lcLcmiC4WFQoVU1zIZHUdiFlBKHhb4uEoFfXY6v4Gy51XDSSn6ohHzj4U4fgyYBp
         AHJq1d8DHuEQ+Wmv+uU+z6ntKrqrdWNgTSqe6egE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.13 182/266] powerpc/xive: Fix error handling when allocating an IPI
Date:   Thu, 15 Jul 2021 20:38:57 +0200
Message-Id: <20210715182643.664089292@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cédric Le Goater <clg@kaod.org>

commit 3f601608b71c3ca1e199898cd16f09d707fedb56 upstream.

This is a smatch warning:

  arch/powerpc/sysdev/xive/common.c:1161 xive_request_ipi() warn: unsigned 'xid->irq' is never less than zero.

Fixes: fd6db2892eba ("powerpc/xive: Modernize XIVE-IPI domain with an 'alloc' handler")
Cc: stable@vger.kernel.org # v5.13
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210701152412.1507612-1-clg@kaod.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/sysdev/xive/common.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1153,11 +1153,10 @@ static int __init xive_request_ipi(void)
 		 * Since the HW interrupt number doesn't have any meaning,
 		 * simply use the node number.
 		 */
-		xid->irq = irq_domain_alloc_irqs(ipi_domain, 1, node, &info);
-		if (xid->irq < 0) {
-			ret = xid->irq;
+		ret = irq_domain_alloc_irqs(ipi_domain, 1, node, &info);
+		if (ret < 0)
 			goto out_free_xive_ipis;
-		}
+		xid->irq = ret;
 
 		snprintf(xid->name, sizeof(xid->name), "IPI-%d", node);
 


