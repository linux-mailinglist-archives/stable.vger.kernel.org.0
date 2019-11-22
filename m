Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76617106CC9
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbfKVKy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:54:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730394AbfKVKy6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:54:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20CE42071C;
        Fri, 22 Nov 2019 10:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420097;
        bh=GTMVDaXzuzU2Vu00XLlOwXvvEsFSRCcG11kDpNM1lzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rANbdL93v19VceodQY3smlEwk7Yak1rfD4iJTo7+WYAgWTIc/uMv6r5kDnEThrZbO
         Ch9tKxgxbL3UOHJ6wjqDniwLQvxc40KOzIyrCuX5daq7UdLNEStWtog6t6ElBYyIkS
         F5pfKSmtiIegLCI5faTQTfhiFbI6s+afrqezmOz0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Suman Anna <s-anna@ti.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 078/122] remoteproc: Check for NULL firmwares in sysfs interface
Date:   Fri, 22 Nov 2019 11:28:51 +0100
Message-Id: <20191122100818.237329904@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suman Anna <s-anna@ti.com>

[ Upstream commit faeadbb64094757150a8c2a3175ca418dbdd472c ]

The remoteproc framework provides a sysfs file 'firmware'
for modifying the firmware image name from userspace. Add
an additional check to ensure NULL firmwares are errored
out right away, rather than getting a delayed error while
requesting a firmware during the start of a remoteproc
later on.

Tested-by: Arnaud Pouliquen <arnaud.pouliquen@st.com>
Signed-off-by: Suman Anna <s-anna@ti.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/remoteproc_sysfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/remoteproc/remoteproc_sysfs.c b/drivers/remoteproc/remoteproc_sysfs.c
index 47be411400e56..3a4c3d7cafca3 100644
--- a/drivers/remoteproc/remoteproc_sysfs.c
+++ b/drivers/remoteproc/remoteproc_sysfs.c
@@ -48,6 +48,11 @@ static ssize_t firmware_store(struct device *dev,
 	}
 
 	len = strcspn(buf, "\n");
+	if (!len) {
+		dev_err(dev, "can't provide a NULL firmware\n");
+		err = -EINVAL;
+		goto out;
+	}
 
 	p = kstrndup(buf, len, GFP_KERNEL);
 	if (!p) {
-- 
2.20.1



