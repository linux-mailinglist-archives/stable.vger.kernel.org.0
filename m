Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112ED3D60E1
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhGZPZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237799AbhGZPYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:24:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BEA560240;
        Mon, 26 Jul 2021 16:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315480;
        bh=/sIjH0jkwG4GR2cVYMRa2esngUBVJDJRKHCiV0B+sF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnPtGlLaa2r/OmU/5QFUDrwG5VDNJiLThFHlMSZlir49ZGVKbQ8ZRY46b9NSR1QDG
         xUjB72r/iaP0nWK17SzyxAjnSYtW+g6tlN7SqfDxNHInbv7h6sZ76Mt2a32c+tEf/f
         rlVJhlteq4riI68qe+xZfutjs9h6rtaTEqo/c3QA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Sujit Kautkar <sujitka@chromium.org>,
        Zubin Mithra <zsm@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 106/167] mmc: core: Dont allocate IDA for OF aliases
Date:   Mon, 26 Jul 2021 17:38:59 +0200
Message-Id: <20210726153842.954553922@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153839.371771838@linuxfoundation.org>
References: <20210726153839.371771838@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit 10252bae863d09b9648bed2e035572d207200ca1 upstream.

There's a chance that the IDA allocated in mmc_alloc_host() is not freed
for some time because it's freed as part of a class' release function
(see mmc_host_classdev_release() where the IDA is freed). If another
thread is holding a reference to the class, then only once all balancing
device_put() calls (in turn calling kobject_put()) have been made will
the IDA be released and usable again.

Normally this isn't a problem because the kobject is released before
anything else that may want to use the same number tries to again, but
with CONFIG_DEBUG_KOBJECT_RELEASE=y and OF aliases it becomes pretty
easy to try to allocate an alias from the IDA twice while the first time
it was allocated is still pending a call to ida_simple_remove(). It's
also possible to trigger it by using CONFIG_DEBUG_KOBJECT_RELEASE and
probe defering a driver at boot that calls mmc_alloc_host() before
trying to get resources that may defer likes clks or regulators.

Instead of allocating from the IDA in this scenario, let's just skip it
if we know this is an OF alias. The number is already "claimed" and
devices that aren't using OF aliases won't try to use the claimed
numbers anyway (see mmc_first_nonreserved_index()). This should avoid
any issues with mmc_alloc_host() returning failures from the
ida_simple_get() in the case that we're using an OF alias.

Cc: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Cc: Sujit Kautkar <sujitka@chromium.org>
Reported-by: Zubin Mithra <zsm@chromium.org>
Fixes: fa2d0aa96941 ("mmc: core: Allow setting slot index via device tree alias")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/20210623075002.1746924-3-swboyd@chromium.org
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/host.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/mmc/core/host.c
+++ b/drivers/mmc/core/host.c
@@ -74,7 +74,8 @@ static void mmc_host_classdev_release(st
 {
 	struct mmc_host *host = cls_dev_to_mmc_host(dev);
 	wakeup_source_unregister(host->ws);
-	ida_simple_remove(&mmc_host_ida, host->index);
+	if (of_alias_get_id(host->parent->of_node, "mmc") < 0)
+		ida_simple_remove(&mmc_host_ida, host->index);
 	kfree(host);
 }
 
@@ -436,7 +437,7 @@ static int mmc_first_nonreserved_index(v
  */
 struct mmc_host *mmc_alloc_host(int extra, struct device *dev)
 {
-	int err;
+	int index;
 	struct mmc_host *host;
 	int alias_id, min_idx, max_idx;
 
@@ -449,20 +450,19 @@ struct mmc_host *mmc_alloc_host(int extr
 
 	alias_id = of_alias_get_id(dev->of_node, "mmc");
 	if (alias_id >= 0) {
-		min_idx = alias_id;
-		max_idx = alias_id + 1;
+		index = alias_id;
 	} else {
 		min_idx = mmc_first_nonreserved_index();
 		max_idx = 0;
-	}
 
-	err = ida_simple_get(&mmc_host_ida, min_idx, max_idx, GFP_KERNEL);
-	if (err < 0) {
-		kfree(host);
-		return NULL;
+		index = ida_simple_get(&mmc_host_ida, min_idx, max_idx, GFP_KERNEL);
+		if (index < 0) {
+			kfree(host);
+			return NULL;
+		}
 	}
 
-	host->index = err;
+	host->index = index;
 
 	dev_set_name(&host->class_dev, "mmc%d", host->index);
 	host->ws = wakeup_source_register(NULL, dev_name(&host->class_dev));


