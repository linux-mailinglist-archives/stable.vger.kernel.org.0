Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FA3353F49
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238843AbhDEJK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:10:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:57744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239441AbhDEJKz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:10:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84DCE61002;
        Mon,  5 Apr 2021 09:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613849;
        bh=f96lpbS+FiZfQzIuYcRBdUvjKy6S4yIHpMyBasPY9DM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a+HUNMp8POHlnC4P26J3E2YyzaCMRgCzPvyBV5upmTgddDsazqn+bqXS8X4Z1dHtJ
         ELcg2b3iJTXxXnd3LmLSUS0pxSlHfOxie8wmsksH4JlFxvctLfVYxQ1rhW6PB5+WeZ
         vo7wf6qaofAN/wdYERm2RCMJEwNvW9t0SGqVWcqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Osipenko <digetx@gmail.com>,
        Paul Fertser <fercerpav@gmail.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.10 078/126] drm/tegra: dc: Restore coupling of display controllers
Date:   Mon,  5 Apr 2021 10:54:00 +0200
Message-Id: <20210405085033.649222827@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
References: <20210405085031.040238881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

commit a31500fe7055451ed9043c8fff938dfa6f70ee37 upstream.

Coupling of display controllers used to rely on runtime PM to take the
companion controller out of reset. Commit fd67e9c6ed5a ("drm/tegra: Do
not implement runtime PM") accidentally broke this when runtime PM was
removed.

Restore this functionality by reusing the hierarchical host1x client
suspend/resume infrastructure that's similar to runtime PM and which
perfectly fits this use-case.

Fixes: fd67e9c6ed5a ("drm/tegra: Do not implement runtime PM")
Reported-by: Dmitry Osipenko <digetx@gmail.com>
Reported-by: Paul Fertser <fercerpav@gmail.com>
Tested-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tegra/dc.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/tegra/dc.c
+++ b/drivers/gpu/drm/tegra/dc.c
@@ -2499,22 +2499,18 @@ static int tegra_dc_couple(struct tegra_
 	 * POWER_CONTROL registers during CRTC enabling.
 	 */
 	if (dc->soc->coupled_pm && dc->pipe == 1) {
-		u32 flags = DL_FLAG_PM_RUNTIME | DL_FLAG_AUTOREMOVE_CONSUMER;
-		struct device_link *link;
-		struct device *partner;
+		struct device *companion;
+		struct tegra_dc *parent;
 
-		partner = driver_find_device(dc->dev->driver, NULL, NULL,
-					     tegra_dc_match_by_pipe);
-		if (!partner)
+		companion = driver_find_device(dc->dev->driver, NULL, (const void *)0,
+					       tegra_dc_match_by_pipe);
+		if (!companion)
 			return -EPROBE_DEFER;
 
-		link = device_link_add(dc->dev, partner, flags);
-		if (!link) {
-			dev_err(dc->dev, "failed to link controllers\n");
-			return -EINVAL;
-		}
+		parent = dev_get_drvdata(companion);
+		dc->client.parent = &parent->client;
 
-		dev_dbg(dc->dev, "coupled to %s\n", dev_name(partner));
+		dev_dbg(dc->dev, "coupled to %s\n", dev_name(companion));
 	}
 
 	return 0;


