Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E38E2E999C
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:02:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbhADQB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:01:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:39260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728670AbhADQB5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EE862250E;
        Mon,  4 Jan 2021 16:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776076;
        bh=5AVGcMQut3ak/z5tayWj5NubN3ZNkOlQLsrwWLRfMbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0uXAA7WAxUOBVaXxhIZi6SA7/rpRQLD2ggAYiaiZ6aNaNJxmoAvfIHGWhcSnITIey
         qVBzRHqYGaHd1FnY6zptbQhksMl4Z1sj9XKyHIwQlO+l8R4dj0o/sGpCOmTIqgE34O
         6w8DMThtUAq4LmKgPkxLUzs74zwJL86Ax0t28kGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Quanyang Wang <quanyang.wang@windriver.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5.10 11/63] opp: fix memory leak in _allocate_opp_table
Date:   Mon,  4 Jan 2021 16:57:04 +0100
Message-Id: <20210104155709.357491870@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Quanyang Wang <quanyang.wang@windriver.com>

commit 976509bb310b913d30577f15b58bdd30effb0542 upstream.

In function _allocate_opp_table, opp_dev is allocated and referenced
by opp_table via _add_opp_dev. But in the case that the subsequent calls
return -EPROBE_DEFER, it will jump to err label and opp_table will be
freed. Then opp_dev becomes an unreferenced object to cause memory leak.
So let's call _remove_opp_dev to do the cleanup.

This fixes the following kmemleak report:

unreferenced object 0xffff000801524a00 (size 128):
  comm "swapper/0", pid 1, jiffies 4294892465 (age 84.616s)
  hex dump (first 32 bytes):
    40 00 56 01 08 00 ff ff 40 00 56 01 08 00 ff ff  @.V.....@.V.....
    b8 52 77 7f 08 00 ff ff 00 3c 4c 00 08 00 ff ff  .Rw......<L.....
  backtrace:
    [<00000000b1289fb1>] kmemleak_alloc+0x30/0x40
    [<0000000056da48f0>] kmem_cache_alloc+0x3d4/0x588
    [<00000000a84b3b0e>] _add_opp_dev+0x2c/0x88
    [<0000000062a380cd>] _add_opp_table_indexed+0x124/0x268
    [<000000008b4c8f1f>] dev_pm_opp_of_add_table+0x20/0x1d8
    [<00000000e5316798>] dev_pm_opp_of_cpumask_add_table+0x48/0xf0
    [<00000000db0a8ec2>] dt_cpufreq_probe+0x20c/0x448
    [<0000000030a3a26c>] platform_probe+0x68/0xd8
    [<00000000c618e78d>] really_probe+0xd0/0x3a0
    [<00000000642e856f>] driver_probe_device+0x58/0xb8
    [<00000000f10f5307>] device_driver_attach+0x74/0x80
    [<0000000004f254b8>] __driver_attach+0x58/0xe0
    [<0000000009d5d19e>] bus_for_each_dev+0x70/0xc8
    [<0000000000d22e1c>] driver_attach+0x24/0x30
    [<0000000001d4e952>] bus_add_driver+0x14c/0x1f0
    [<0000000089928aaa>] driver_register+0x64/0x120

Cc: v5.10 <stable@vger.kernel.org> # v5.10
Fixes: dd461cd9183f ("opp: Allow dev_pm_opp_get_opp_table() to return -EPROBE_DEFER")
Signed-off-by: Quanyang Wang <quanyang.wang@windriver.com>
[ Viresh: Added the stable tag ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/opp/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1102,7 +1102,7 @@ static struct opp_table *_allocate_opp_t
 	if (IS_ERR(opp_table->clk)) {
 		ret = PTR_ERR(opp_table->clk);
 		if (ret == -EPROBE_DEFER)
-			goto err;
+			goto remove_opp_dev;
 
 		dev_dbg(dev, "%s: Couldn't find clock: %d\n", __func__, ret);
 	}
@@ -1111,7 +1111,7 @@ static struct opp_table *_allocate_opp_t
 	ret = dev_pm_opp_of_find_icc_paths(dev, opp_table);
 	if (ret) {
 		if (ret == -EPROBE_DEFER)
-			goto err;
+			goto remove_opp_dev;
 
 		dev_warn(dev, "%s: Error finding interconnect paths: %d\n",
 			 __func__, ret);
@@ -1125,6 +1125,8 @@ static struct opp_table *_allocate_opp_t
 	list_add(&opp_table->node, &opp_tables);
 	return opp_table;
 
+remove_opp_dev:
+	_remove_opp_dev(opp_dev, opp_table);
 err:
 	kfree(opp_table);
 	return ERR_PTR(ret);


