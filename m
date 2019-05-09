Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B8719110
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfEISwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728714AbfEISw3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:52:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36FF12183E;
        Thu,  9 May 2019 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427948;
        bh=dzBOdXs1SpdMzjFnP+RGYqtfEUngwD8kCrHTrI4Zbvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YGhXL1qdqfjHx1c9YjzaDVIPiRavmpMQ7F188Exn96JznSZ1kroWggVhibEKLikSl
         aPQNdN4jzvscCbGUFqQxRhOWzad+bAMuoDThuX0lTK+Rex4MDsXGhZcUdCcI8Txqhd
         c4YdwUFZ354TFKbDKbfyVfMdMQ1aA5m75EGKog9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Imre Deak <imre.deak@intel.com>, Takashi Iwai <tiwai@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 63/95] ALSA: hda: Fix racy display power access
Date:   Thu,  9 May 2019 20:42:20 +0200
Message-Id: <20190509181313.889818220@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d7a181da2dfa3190487c446042ba01e07d851c74 ]

snd_hdac_display_power() doesn't handle the concurrent calls carefully
enough, and it may lead to the doubly get_power or put_power calls,
when a runtime PM and an async work get called in racy way.

This patch addresses it by reusing the bus->lock mutex that has been
used for protecting the link state change in ext bus code, so that it
can protect against racy display state changes.  The initialization of
bus->lock was moved from snd_hdac_ext_bus_init() to
snd_hdac_bus_init() as well accordingly.

Testcase: igt/i915_pm_rpm/module-reload #glk-dsi
Reported-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Imre Deak <imre.deak@intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/ext/hdac_ext_bus.c | 1 -
 sound/hda/hdac_bus.c         | 1 +
 sound/hda/hdac_component.c   | 6 +++++-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/hda/ext/hdac_ext_bus.c b/sound/hda/ext/hdac_ext_bus.c
index 9c37d9af3023f..ec7715c6b0c02 100644
--- a/sound/hda/ext/hdac_ext_bus.c
+++ b/sound/hda/ext/hdac_ext_bus.c
@@ -107,7 +107,6 @@ int snd_hdac_ext_bus_init(struct hdac_bus *bus, struct device *dev,
 	INIT_LIST_HEAD(&bus->hlink_list);
 	bus->idx = idx++;
 
-	mutex_init(&bus->lock);
 	bus->cmd_dma_state = true;
 
 	return 0;
diff --git a/sound/hda/hdac_bus.c b/sound/hda/hdac_bus.c
index 012305177f682..ad8eee08013fb 100644
--- a/sound/hda/hdac_bus.c
+++ b/sound/hda/hdac_bus.c
@@ -38,6 +38,7 @@ int snd_hdac_bus_init(struct hdac_bus *bus, struct device *dev,
 	INIT_WORK(&bus->unsol_work, snd_hdac_bus_process_unsol_events);
 	spin_lock_init(&bus->reg_lock);
 	mutex_init(&bus->cmd_mutex);
+	mutex_init(&bus->lock);
 	bus->irq = -1;
 	return 0;
 }
diff --git a/sound/hda/hdac_component.c b/sound/hda/hdac_component.c
index a6d37b9d6413f..6b5caee61c6e0 100644
--- a/sound/hda/hdac_component.c
+++ b/sound/hda/hdac_component.c
@@ -69,13 +69,15 @@ void snd_hdac_display_power(struct hdac_bus *bus, unsigned int idx, bool enable)
 
 	dev_dbg(bus->dev, "display power %s\n",
 		enable ? "enable" : "disable");
+
+	mutex_lock(&bus->lock);
 	if (enable)
 		set_bit(idx, &bus->display_power_status);
 	else
 		clear_bit(idx, &bus->display_power_status);
 
 	if (!acomp || !acomp->ops)
-		return;
+		goto unlock;
 
 	if (bus->display_power_status) {
 		if (!bus->display_power_active) {
@@ -92,6 +94,8 @@ void snd_hdac_display_power(struct hdac_bus *bus, unsigned int idx, bool enable)
 			bus->display_power_active = false;
 		}
 	}
+ unlock:
+	mutex_unlock(&bus->lock);
 }
 EXPORT_SYMBOL_GPL(snd_hdac_display_power);
 
-- 
2.20.1



