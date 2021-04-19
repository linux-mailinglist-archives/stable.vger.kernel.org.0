Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F55936427A
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239578AbhDSNJ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:09:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239556AbhDSNJM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:09:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0C5461246;
        Mon, 19 Apr 2021 13:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837721;
        bh=uxISKPsf5oQ1XgBzcVOUTWpfpw8rLhvwxbpybYPmNeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZVa/W4iN6v/j2drIBUwVtBtiKVDsP7vX21ZInsSopTarS7msru4tmKbk99dBGODWr
         M7Kq5dyo19dQE65nzSUzKdPnQi5TE4aQ3mJDjrOFZin3gPwBz08DIM0Ki7EjHLdmi+
         SLF4qHpp9mZUV/3hBfXogz2tq3dRNRkZcf8P1Eg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Van <lucas.van@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 009/122] dmaengine: idxd: fix opcap sysfs attribute output
Date:   Mon, 19 Apr 2021 15:04:49 +0200
Message-Id: <20210419130530.486969222@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit ea6a5735d2a61b938a302eb3629272342a9e7c46 ]

The operation capability register is 256bits. The current output only
prints out the first 64bits. Fix to output the entire 256bits. The current
code omits operation caps from IAX devices.

Fixes: c52ca478233c ("dmaengine: idxd: add configuration component of driver")
Reported-by: Lucas Van <lucas.van@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/161645624963.2003736.829798666998490151.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/sysfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 4dbb03c545e4..c27ca01cf8b2 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1449,8 +1449,14 @@ static ssize_t op_cap_show(struct device *dev,
 {
 	struct idxd_device *idxd =
 		container_of(dev, struct idxd_device, conf_dev);
+	int i, rc = 0;
+
+	for (i = 0; i < 4; i++)
+		rc += sysfs_emit_at(buf, rc, "%#llx ", idxd->hw.opcap.bits[i]);
 
-	return sprintf(buf, "%#llx\n", idxd->hw.opcap.bits[0]);
+	rc--;
+	rc += sysfs_emit_at(buf, rc, "\n");
+	return rc;
 }
 static DEVICE_ATTR_RO(op_cap);
 
-- 
2.30.2



