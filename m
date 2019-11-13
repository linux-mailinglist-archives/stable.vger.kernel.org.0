Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71935FA197
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 02:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbfKMB6V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:58:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730002AbfKMB6T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:58:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B097F222D3;
        Wed, 13 Nov 2019 01:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610299;
        bh=GTMVDaXzuzU2Vu00XLlOwXvvEsFSRCcG11kDpNM1lzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mXEbrKRLyKmPKvhwxHam1yuGW7sb4Pl13GX6og9uLXRUCnERKTU2wKituwTdvg+o6
         IruhyorvC73zEQLUV5h/3jPHyGPfGCWSklCtCPkY2Ky1fteBlA85OlFMjQxR9pBqQ9
         4YZbnisnibtq/h2ZAugqS5V2T4hKDBM/Hwoz/cbY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Suman Anna <s-anna@ti.com>,
        Arnaud Pouliquen <arnaud.pouliquen@st.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-remoteproc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 071/115] remoteproc: Check for NULL firmwares in sysfs interface
Date:   Tue, 12 Nov 2019 20:55:38 -0500
Message-Id: <20191113015622.11592-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

