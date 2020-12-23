Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CC12E14B7
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbgLWCmj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:42:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729925AbgLWCXL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DD6B225AC;
        Wed, 23 Dec 2020 02:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690150;
        bh=R6ZeVybNUX6QVZA/bcPPYYJ+ypcizOxxPnfogTVUV7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMpBg2ZSTYboKqMYj1p26DJok0+rPaV9KSSeq/RC0PIWKUrbdw30Tu4Tl6BocZMnm
         uED5B+4bItaGqfgtbupGKSYu+u+OwS5jf8ABMb5NZoGEnCd5QbsuNzXGDM0Nn4vYjg
         NAj1h1eQmWb8G/hB8IDrgWLGI+vB78m6ACzdaDnVnTk1uFjt/5vOXJ8ja/1n/h++Vf
         P3NRGEMN8mshBsaaSbeC3CAKi49IfRgxtwuD54OEjivk/oCKKLbhsAWEbaMkwRBoSP
         tfgKQ296RGgYR/29+tkVPLikUptLiT0WYKFBVt1JxiPv0IfnpXHJQBSjayOUdn5baV
         B0EhGO4XWrHmA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        "Rafael . J . Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 70/87] driver core: Reorder devices on successful probe
Date:   Tue, 22 Dec 2020 21:20:46 -0500
Message-Id: <20201223022103.2792705-70-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022103.2792705-1-sashal@kernel.org>
References: <20201223022103.2792705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit 5b6164d3465fcc13b5679c860c452963443172a7 ]

Device drivers usually depend on the fact that the devices that they
control are suspended in the same order that they were probed in. In
most cases this is already guaranteed via deferred probe.

However, there's one case where this can still break: if a device is
instantiated before a dependency (for example if it appears before the
dependency in device tree) but gets probed only after the dependency is
probed. Instantiation order would cause the dependency to get probed
later, in which case probe of the original device would be deferred and
the suspend/resume queue would get reordered properly. However, if the
dependency is provided by a built-in driver and the device depending on
that driver is controlled by a loadable module, which may only get
loaded after the root filesystem has become available, we can be faced
with a situation where the probe order ends up being different from the
suspend/resume order.

One example where this happens is on Tegra186, where the ACONNECT is
listed very early in device tree (sorted by unit-address) and depends on
BPMP (listed very late because it has no unit-address) for power domains
and clocks/resets. If the ACONNECT driver is built-in, there is no
problem because it will be probed before BPMP, causing a probe deferral
and that in turn reorders the suspend/resume queue. However, if built as
a module, it will end up being probed after BPMP, and therefore not
result in a probe deferral, and therefore the suspend/resume queue will
stay in the instantiation order. This in turn causes problems because
ACONNECT will be resumed before BPMP, which will result in a hang
because the ACONNECT's power domain cannot be powered on as long as the
BPMP is still suspended.

Fix this by always reordering devices on successful probe. This ensures
that the suspend/resume queue is always in probe order and hence meets
the natural expectations of drivers vs. their dependencies.

Reported-by: Jonathan Hunter <jonathanh@nvidia.com>
Acked-by: Rafael. J. Wysocki <rafael@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/20201203175756.1405564-1-thierry.reding@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/dd.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 4ba9231a6be80..bbb2f72819184 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -334,6 +334,13 @@ static void driver_bound(struct device *dev)
 
 	device_pm_check_callbacks(dev);
 
+	/*
+	 * Reorder successfully probed devices to the end of the device list.
+	 * This ensures that suspend/resume order matches probe order, which
+	 * is usually what drivers rely on.
+	 */
+	device_pm_move_to_tail(dev);
+
 	/*
 	 * Make sure the device is no longer in one of the deferred lists and
 	 * kick off retrying all pending devices
-- 
2.27.0

