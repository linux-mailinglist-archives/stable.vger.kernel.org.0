Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB522C07BF
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733134AbgKWMnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:43:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733128AbgKWMnr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:43:47 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D69FB20732;
        Mon, 23 Nov 2020 12:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135427;
        bh=Y4vfBpfYdrjebgNNhqYN3GEsKjcIIbpWaetedjvH4I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVL7E6ye48qwmwjH8naaNcepDyXHrTkdCdBLSaOaqFC72cccMbtzCx3Wgl5etj5Qm
         9pxGhpvnHlhKolFikLEftZa06oCzYlxfzFhmeNpI8sgwddz9CpzdWP5et02PFRtsez
         0I+3JiIDh0sC1Uj4vn5Lpni7mNqKv4oo0jJtt4oc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 047/252] PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter
Date:   Mon, 23 Nov 2020 13:19:57 +0100
Message-Id: <20201123121837.857006136@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit dd8088d5a8969dc2b42f71d7bc01c25c61a78066 ]

In many case, we need to check return value of pm_runtime_get_sync, but
it brings a trouble to the usage counter processing. Many callers forget
to decrease the usage counter when it failed, which could resulted in
reference leak. It has been discussed a lot[0][1]. So we add a function
to deal with the usage counter for better coding.

[0]https://lkml.org/lkml/2020/6/14/88
[1]https://patchwork.ozlabs.org/project/linux-tegra/list/?series=178139
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Acked-by: Rafael J. Wysocki  <rafael.j.wysocki@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pm_runtime.h |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -387,6 +387,27 @@ static inline int pm_runtime_get_sync(st
 }
 
 /**
+ * pm_runtime_resume_and_get - Bump up usage counter of a device and resume it.
+ * @dev: Target device.
+ *
+ * Resume @dev synchronously and if that is successful, increment its runtime
+ * PM usage counter. Return 0 if the runtime PM usage counter of @dev has been
+ * incremented or a negative error code otherwise.
+ */
+static inline int pm_runtime_resume_and_get(struct device *dev)
+{
+	int ret;
+
+	ret = __pm_runtime_resume(dev, RPM_GET_PUT);
+	if (ret < 0) {
+		pm_runtime_put_noidle(dev);
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
  * pm_runtime_put - Drop device usage counter and queue up "idle check" if 0.
  * @dev: Target device.
  *


