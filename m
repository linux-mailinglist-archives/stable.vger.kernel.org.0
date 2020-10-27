Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61AE29B506
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793686AbgJ0PHs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:07:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1789186AbgJ0PBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:01:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6219E22281;
        Tue, 27 Oct 2020 15:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810897;
        bh=+fnJmlbKwQgjeC3i6/O6fcOo0H5LdC8bzoB8enCmuiw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elvQoqNcehEMA/tn5wwdWZemYUx8/0/aVRIJW0ToLZN5LMpQ3+xpPinzgSAOMM0YM
         9rb7pDVNGswtI0HYXpguwYiFC3YF8P04QhEfhyQVQjiAnC8VZTc3Tfk1J68usH8unT
         rDgfljJOZJqkvBpxPJr4OI2M/QCKeOiBQwrN/9CM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frederic Barrat <fbarrat@linux.ibm.com>,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 301/633] ocxl: fix kconfig dependency warning for OCXL
Date:   Tue, 27 Oct 2020 14:50:44 +0100
Message-Id: <20201027135536.782719450@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit 4b53a3c72116118d86fab4112277e1dc4edf273c ]

When OCXL is enabled and HOTPLUG_PCI is disabled, it results in the
following Kbuild warning:

WARNING: unmet direct dependencies detected for HOTPLUG_PCI_POWERNV
  Depends on [n]: PCI [=y] && HOTPLUG_PCI [=n] && PPC_POWERNV [=y] && EEH [=y]
  Selected by [y]:
  - OCXL [=y] && PPC_POWERNV [=y] && PCI [=y] && EEH [=y]

The reason is that OCXL selects HOTPLUG_PCI_POWERNV without depending on
or selecting HOTPLUG_PCI while HOTPLUG_PCI_POWERNV is subordinate to
HOTPLUG_PCI.

HOTPLUG_PCI_POWERNV is a visible symbol with a set of dependencies.
Selecting it will lead to overlooking its other dependencies as well.

Let OCXL depend on HOTPLUG_PCI_POWERNV instead to avoid Kbuild issues.

Fixes: 49ce94b8677c ("ocxl: Add PCI hotplug dependency to Kconfig")
Acked-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Link: https://lore.kernel.org/r/20200918094148.20525-1-fazilyildiran@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/ocxl/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/ocxl/Kconfig b/drivers/misc/ocxl/Kconfig
index 2d2266c1439ef..51b51f3774701 100644
--- a/drivers/misc/ocxl/Kconfig
+++ b/drivers/misc/ocxl/Kconfig
@@ -9,9 +9,8 @@ config OCXL_BASE
 
 config OCXL
 	tristate "OpenCAPI coherent accelerator support"
-	depends on PPC_POWERNV && PCI && EEH
+	depends on PPC_POWERNV && PCI && EEH && HOTPLUG_PCI_POWERNV
 	select OCXL_BASE
-	select HOTPLUG_PCI_POWERNV
 	default m
 	help
 	  Select this option to enable the ocxl driver for Open
-- 
2.25.1



