Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7C117A3A9
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 12:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgCELGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 06:06:53 -0500
Received: from forward104j.mail.yandex.net ([5.45.198.247]:54012 "EHLO
        forward104j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725953AbgCELGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Mar 2020 06:06:52 -0500
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2020 06:06:52 EST
Received: from forward100q.mail.yandex.net (forward100q.mail.yandex.net [IPv6:2a02:6b8:c0e:4b:0:640:4012:bb97])
        by forward104j.mail.yandex.net (Yandex) with ESMTP id 446E84A1583;
        Thu,  5 Mar 2020 14:01:33 +0300 (MSK)
Received: from mxback8q.mail.yandex.net (mxback8q.mail.yandex.net [IPv6:2a02:6b8:c0e:42:0:640:b38f:32ec])
        by forward100q.mail.yandex.net (Yandex) with ESMTP id 417987080006;
        Thu,  5 Mar 2020 14:01:33 +0300 (MSK)
Received: from vla5-445dc1c4c112.qloud-c.yandex.net (vla5-445dc1c4c112.qloud-c.yandex.net [2a02:6b8:c18:3609:0:640:445d:c1c4])
        by mxback8q.mail.yandex.net (mxback/Yandex) with ESMTP id JCH9oiAXUo-1XNSk0sb;
        Thu, 05 Mar 2020 14:01:33 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=maquefel.me; s=mail; t=1583406093;
        bh=/kV4O0qJVZXzwid6BVH7MX/fCuvUiaSY86OITvWYn1A=;
        h=In-Reply-To:Subject:To:From:Cc:References:Date:Message-Id;
        b=TamgzMfWAMa1KOXUnp4dwwC7MfAGwuARc/H+dgdt2VxkKtxHM8Txz/F/TYVMTCLdN
         3SIZPRmzTt8uV+d4wUVEJx6vap6/n5uFUsIS2vmXIDNDA2sIN/flWQuf8+/xm8Wzah
         ButFPaNGxfu7PjNP2KBAzxPttBnasQcqSu8pa2kk=
Authentication-Results: mxback8q.mail.yandex.net; dkim=pass header.i=@maquefel.me
Received: by vla5-445dc1c4c112.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id 8hWJyQQZRL-1WW8nAin;
        Thu, 05 Mar 2020 14:01:32 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
From:   Nikita Shubin <NShubin@topcon.com>
Cc:     Nikita Shubin <NShubin@topcon.com>, stable@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/1] remoteproc: Fix NULL pointer dereference in rproc_virtio_notify
Date:   Thu,  5 Mar 2020 14:02:18 +0300
Message-Id: <20200305110218.8799-2-NShubin@topcon.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305110218.8799-1-NShubin@topcon.com>
References: <20200228110804.25822-1-nikita.shubin@maquefel.me>
 <20200305110218.8799-1-NShubin@topcon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

.kick method not set in rproc_ops will result in:

8<--- cut here ---
Unable to handle kernel NULL pointer dereference

in rproc_virtio_notify, after firmware loading.

refuse to register an rproc-induced virtio device if no kick method was
defined for rproc.

Signed-off-by: Nikita Shubin <NShubin@topcon.com>
Fixes: 7a186941626d19f668b08108db158379b32e6e02 ("remoteproc: remove the single rpmsg vdev limitation")
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

