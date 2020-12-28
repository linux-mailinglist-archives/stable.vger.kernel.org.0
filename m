Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A312E6462
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391498AbgL1Niy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:38:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391276AbgL1Nix (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D31E208B3;
        Mon, 28 Dec 2020 13:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162692;
        bh=pVY1LVJRDZatBImIxWJH4xfQ9jiA4rIapbh2xaIrQAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7/ud29W4U8jogJ14vK7nXh0F8hBPegf+Xj4cRi+ZTftSrdQdk+VQguw+V2AOk/KJ
         o/CbWRdzPghHIw+odQwRzP6VuUHW0UGT47loMsIosskc8VBBRQkltOT+dVXT2UZnY5
         BfUUiQw17XvnQ3UNliU+0T4zBeDKLC7U84RiAbN4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 010/453] PM: runtime: Add pm_runtime_resume_and_get to deal with usage counter
Date:   Mon, 28 Dec 2020 13:44:06 +0100
Message-Id: <20201228124937.740353201@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pm_runtime.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index fe61e3b9a9ca2..7145795b4b9da 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -224,6 +224,27 @@ static inline int pm_runtime_get_sync(struct device *dev)
 	return __pm_runtime_resume(dev, RPM_GET_PUT);
 }
 
+/**
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
 static inline int pm_runtime_put(struct device *dev)
 {
 	return __pm_runtime_idle(dev, RPM_GET_PUT | RPM_ASYNC);
-- 
2.27.0



