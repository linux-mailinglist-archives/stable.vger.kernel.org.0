Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E37B2A52AE
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732027AbgKCUwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:52:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732039AbgKCUwI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:52:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C1D62053B;
        Tue,  3 Nov 2020 20:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436726;
        bh=da8E9zlyOcK/RBh5Vt8g09p0Jickl8KEWZ8hJrxot38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZYhHv/mBVptqphL1ooyEIWSbR/cs4AC5ZFrYI9YS5iwJRgidAbIh+TL/gyxkyA/e
         EtUVI5EGP83Tw7Ni96G4Gif5a2sjB3V1R0oWZSlgXTAC3r01+qFoduQojc7EbwaLdP
         k1rlL4EcysvxkxagIFHJ3dDTisJpcpvmaWKxZmus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Mike Leach <mike.leach@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.9 375/391] coresight: cti: Initialize dynamic sysfs attributes
Date:   Tue,  3 Nov 2020 21:37:06 +0100
Message-Id: <20201103203412.467959246@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suzuki K Poulose <suzuki.poulose@arm.com>

commit 80624263fa289b3416f7ca309491f1b75e579477 upstream.

With LOCKDEP enabled, CTI driver triggers the following splat due
to uninitialized lock class for dynamically allocated attribute
objects.

[    5.372901] coresight etm0: CPU0: ETM v4.0 initialized
[    5.376694] coresight etm1: CPU1: ETM v4.0 initialized
[    5.380785] coresight etm2: CPU2: ETM v4.0 initialized
[    5.385851] coresight etm3: CPU3: ETM v4.0 initialized
[    5.389808] BUG: key ffff00000564a798 has not been registered!
[    5.392456] ------------[ cut here ]------------
[    5.398195] DEBUG_LOCKS_WARN_ON(1)
[    5.398233] WARNING: CPU: 1 PID: 32 at kernel/locking/lockdep.c:4623 lockdep_init_map_waits+0x14c/0x260
[    5.406149] Modules linked in:
[    5.415411] CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 5.9.0-12034-gbbe85027ce80 #51
[    5.418553] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    5.426453] Workqueue: events amba_deferred_retry_func
[    5.433299] pstate: 40000005 (nZcv daif -PAN -UAO -TCO BTYPE=--)
[    5.438252] pc : lockdep_init_map_waits+0x14c/0x260
[    5.444410] lr : lockdep_init_map_waits+0x14c/0x260
[    5.449007] sp : ffff800012bbb720
...

[    5.531561] Call trace:
[    5.536847]  lockdep_init_map_waits+0x14c/0x260
[    5.539027]  __kernfs_create_file+0xa8/0x1c8
[    5.543539]  sysfs_add_file_mode_ns+0xd0/0x208
[    5.548054]  internal_create_group+0x118/0x3c8
[    5.552307]  internal_create_groups+0x58/0xb8
[    5.556733]  sysfs_create_groups+0x2c/0x38
[    5.561160]  device_add+0x2d8/0x768
[    5.565148]  device_register+0x28/0x38
[    5.568537]  coresight_register+0xf8/0x320
[    5.572358]  cti_probe+0x1b0/0x3f0

...

Fix this by initializing the attributes when they are allocated.

Fixes: 3c5597e39812 ("coresight: cti: Add connection information to sysfs")
Reported-by: Leo Yan <leo.yan@linaro.org>
Tested-by: Leo Yan <leo.yan@linaro.org>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Link: https://lore.kernel.org/r/20201029164559.1268531-2-mathieu.poirier@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-cti-sysfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/hwtracing/coresight/coresight-cti-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-cti-sysfs.c
@@ -1065,6 +1065,13 @@ static int cti_create_con_sysfs_attr(str
 	}
 	eattr->var = con;
 	con->con_attrs[attr_idx] = &eattr->attr.attr;
+	/*
+	 * Initialize the dynamically allocated attribute
+	 * to avoid LOCKDEP splat. See include/linux/sysfs.h
+	 * for more details.
+	 */
+	sysfs_attr_init(con->con_attrs[attr_idx]);
+
 	return 0;
 }
 


