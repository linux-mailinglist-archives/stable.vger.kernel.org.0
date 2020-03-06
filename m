Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7119117B745
	for <lists+stable@lfdr.de>; Fri,  6 Mar 2020 08:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgCFHVw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Mar 2020 02:21:52 -0500
Received: from forward104o.mail.yandex.net ([37.140.190.179]:49002 "EHLO
        forward104o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725829AbgCFHVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Mar 2020 02:21:52 -0500
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Mar 2020 02:21:50 EST
Received: from mxback7g.mail.yandex.net (mxback7g.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b7:168])
        by forward104o.mail.yandex.net (Yandex) with ESMTP id EB4DB9424EE;
        Fri,  6 Mar 2020 10:15:41 +0300 (MSK)
Received: from iva3-dd2bb2ff2b5f.qloud-c.yandex.net (iva3-dd2bb2ff2b5f.qloud-c.yandex.net [2a02:6b8:c0c:7611:0:640:dd2b:b2ff])
        by mxback7g.mail.yandex.net (mxback/Yandex) with ESMTP id 4QcmWVIbaF-Ffd0Ohkn;
        Fri, 06 Mar 2020 10:15:41 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maquefel.me; s=mail; t=1583478941;
        bh=dFOJ8HxcJHuVEanjCBZpIwYRShDEHi2Qbibs/FbE4bs=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=mihW1Tmq1N5c3RD1C2q1WMfdqBP/6lQmzukxiIy0Ffen0zJ9LTkziBcIUnX+G/suw
         LC7YUP9goExtyVRjKL0618yWfvJx4sH9hGstU7rsIhiSmU+/ATOMvjUWeCzf8cngEl
         KOy11Y3bOMg0EL0aJJfr78Bu51osyHK7cugbXvHA=
Authentication-Results: mxback7g.mail.yandex.net; dkim=pass header.i=@maquefel.me
Received: by iva3-dd2bb2ff2b5f.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id WFGP46aMDd-FeWi6ntj;
        Fri, 06 Mar 2020 10:15:40 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Nikita Shubin <NShubin@topcon.com>
Cc:     Nikita Shubin <NShubin@topcon.com>, stable@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4] remoteproc: Fix NULL pointer dereference in rproc_virtio_notify
Date:   Fri,  6 Mar 2020 10:03:25 +0300
Message-Id: <20200306070325.15232-1-NShubin@topcon.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305110218.8799-2-NShubin@topcon.com>
References: <20200305110218.8799-2-NShubin@topcon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Undefined rproc_ops .kick method in remoteproc driver will result in
"Unable to handle kernel NULL pointer dereference" in rproc_virtio_notify, 
after firmware loading if:

 1) .kick method wasn't defined in driver
 2) resource_table exists in firmware and has "Virtio device entry" defined

Let's refuse to register an rproc-induced virtio device if no kick method was
defined for rproc.

Signed-off-by: Nikita Shubin <NShubin@topcon.com>
Fixes: 7a186941626d ("remoteproc: remove the single rpmsg vdev limitation")
Cc: stable@vger.kernel.org
---
 drivers/remoteproc/remoteproc_virtio.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/remoteproc_virtio.c
index 8c07cb2ca8ba..31a62a0b470e 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -334,6 +334,13 @@ int rproc_add_virtio_dev(struct rproc_vdev *rvdev, int id)
 	struct rproc_mem_entry *mem;
 	int ret;
 
+	if (rproc->ops->kick == NULL) {
+		ret = -EINVAL;
+		dev_err(dev, ".kick method not defined for %s",
+				rproc->name);
+		goto out;
+	}
+
 	/* Try to find dedicated vdev buffer carveout */
 	mem = rproc_find_carveout_by_name(rproc, "vdev%dbuffer", rvdev->index);
 	if (mem) {
-- 
2.24.1

