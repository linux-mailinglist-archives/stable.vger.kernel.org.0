Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8B72E4180
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632824AbgL1PHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:07:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:42916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438648AbgL1OIW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:08:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BBB1207B2;
        Mon, 28 Dec 2020 14:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164461;
        bh=acT3mKttGcyO3UWU/y7jp1NdbrD1iqSk6HLFTMBJsqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XFe0/uyTnDSJtdLuSM8PQzcVzBoKsfS6lmTmwgMiyncjZmqBXm7dfsu0ybIEbJNgD
         hEfd3JH9H39/VOTL7gba2BRVvp/NeW6LcoBEjarBzIN/mrq83ncri/SCja760/U0eV
         Ry7BR9hoo3KhyA9FOExlZclDTqjE+Soz9JoHXCBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 189/717] soundwire: Fix DEBUG_LOCKS_WARN_ON for uninitialized attribute
Date:   Mon, 28 Dec 2020 13:43:07 +0100
Message-Id: <20201228125030.026635784@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit e6db818a3f51781ba12ac4d52b8773f74d57b06b ]

running kernel with CONFIG_DEBUG_LOCKS_ALLOC enabled will below warning:

BUG: key ffff502e09807098 has not been registered!
DEBUG_LOCKS_WARN_ON(1)
WARNING: CPU: 5 PID: 129 at kernel/locking/lockdep.c:4623
	lockdep_init_map_waits+0xe8/0x250
Modules linked in:
CPU: 5 PID: 129 Comm: kworker/5:1 Tainted: G
       W         5.10.0-rc1-00277-ged49f224ca3f-dirty #1210
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
Workqueue: events deferred_probe_work_func
pstate: 80c00005 (Nzcv daif +PAN +UAO -TCO BTYPE=--)
pc : lockdep_init_map_waits+0xe8/0x250
lr : lockdep_init_map_waits+0xe8/0x250
 [ Trimmed ]

Call trace:
 lockdep_init_map_waits+0xe8/0x250
 __kernfs_create_file+0x78/0x180
 sysfs_add_file_mode_ns+0x94/0x1c8
 internal_create_group+0x110/0x3e0
 sysfs_create_group+0x18/0x28
 devm_device_add_group+0x4c/0xb0
 add_all_attributes+0x438/0x490
 sdw_slave_sysfs_dpn_init+0x128/0x138
 sdw_slave_sysfs_init+0x80/0xa0
 sdw_drv_probe+0x94/0x170
 really_probe+0x118/0x3e0
 driver_probe_device+0x5c/0xc0

 [ Trimmed ]

CPU: 5 PID: 129 Comm: kworker/5:1 Tainted: G
     W         5.10.0-rc1-00277-ged49f224ca3f-dirty #1210
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
Workqueue: events deferred_probe_work_func
Call trace:
 dump_backtrace+0x0/0x1c0
 show_stack+0x18/0x68
 dump_stack+0xd8/0x134
 __warn+0xa0/0x158
 report_bug+0xc8/0x178
 bug_handler+0x20/0x78
 brk_handler+0x70/0xc8

[ Trimmed ]

Fix this by initializing dynamically allocated sysfs attribute to keep lockdep happy!

Fixes: bcac59029955 ("soundwire: add Slave sysfs support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20201104112941.1134-1-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/sysfs_slave_dpn.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soundwire/sysfs_slave_dpn.c b/drivers/soundwire/sysfs_slave_dpn.c
index 05a721ea9830a..c4b6543c09fd6 100644
--- a/drivers/soundwire/sysfs_slave_dpn.c
+++ b/drivers/soundwire/sysfs_slave_dpn.c
@@ -37,6 +37,7 @@ static int field##_attribute_alloc(struct device *dev,			\
 		return -ENOMEM;						\
 	dpn_attr->N = N;						\
 	dpn_attr->dir = dir;						\
+	sysfs_attr_init(&dpn_attr->dev_attr.attr);			\
 	dpn_attr->format_string = format_string;			\
 	dpn_attr->dev_attr.attr.name = __stringify(field);		\
 	dpn_attr->dev_attr.attr.mode = 0444;				\
-- 
2.27.0



