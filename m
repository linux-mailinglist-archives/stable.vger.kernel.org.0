Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48083411B9E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237625AbhITRAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344266AbhITQ6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:58:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19B53613CF;
        Mon, 20 Sep 2021 16:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156730;
        bh=RvpzAIfx70ncc2Iuez7sWEL+p5JVeCTgws+UJ+YvLQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HLu5KBd0eHRls99IaCx4fs9Nb9h1vH7mkZnzYLF5rviGYh4He4uzIIwAoFU6l6IJW
         ISGT8XrI079b6k8uzfRUUhBOFTNP88V0yG5IH0c6fNzH9bsi1BrpPZ1CTRz0WQaft9
         v+QgDlp1b8DHjH+h1Dl+00AvhHIWmtOVFWuEV8eI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Utkarsh H Patel <utkarsh.h.patel@intel.com>,
        Koba Ko <koba.ko@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 059/175] PCI: PM: Enable PME if it can be signaled from D3cold
Date:   Mon, 20 Sep 2021 18:41:48 +0200
Message-Id: <20210920163919.983293155@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 0e00392a895c95c6d12d42158236c8862a2f43f2 ]

PME signaling is only enabled by __pci_enable_wake() if the target
device can signal PME from the given target power state (to avoid
pointless reconfiguration of the device), but if the hierarchy above
the device goes into D3cold, the device itself will end up in D3cold
too, so if it can signal PME from D3cold, it should be enabled to
do so in __pci_enable_wake().

[Note that if the device does not end up in D3cold and it cannot
 signal PME from the original target power state, it will not signal
 PME, so in that case the behavior does not change.]

Link: https://lore.kernel.org/linux-pm/3149540.aeNJFYEL58@kreacher/
Fixes: 5bcc2fb4e815 ("PCI PM: Simplify PCI wake-up code")
Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reported-by: Utkarsh H Patel <utkarsh.h.patel@intel.com>
Reported-by: Koba Ko <koba.ko@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e09653c73ab4..510933ff6a26 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1926,7 +1926,14 @@ int __pci_enable_wake(struct pci_dev *dev, pci_power_t state,
 	if (enable) {
 		int error;
 
-		if (pci_pme_capable(dev, state))
+		/*
+		 * Enable PME signaling if the device can signal PME from
+		 * D3cold regardless of whether or not it can signal PME from
+		 * the current target state, because that will allow it to
+		 * signal PME when the hierarchy above it goes into D3cold and
+		 * the device itself ends up in D3cold as a result of that.
+		 */
+		if (pci_pme_capable(dev, state) || pci_pme_capable(dev, PCI_D3cold))
 			pci_pme_active(dev, true);
 		else
 			ret = 1;
-- 
2.30.2



