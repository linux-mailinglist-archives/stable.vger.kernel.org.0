Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1CDE3643A6
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240712AbhDSNVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240702AbhDSNSm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:18:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06845613FB;
        Mon, 19 Apr 2021 13:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838099;
        bh=N0Ugq0o3pQAuduongTIeizdD/oz1VyPo6r7AfmJ3Uho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xfphp8EdUKHoprpxA0MRrZDf+jfLSo7F8jabq/3NrIS8drZKRv3ev8kL7yw+aAq8P
         mMupmGyCnKj5iEJlJdPevAuQpajuVvTz/jBf7vKPP33yhLS4rLw8QFKfEiULu32ZsT
         eKjO4GCzk9X6iku/6EUBenGQZjPkEFpX2HSpZN/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Van <lucas.van@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/103] dmaengine: idxd: fix opcap sysfs attribute output
Date:   Mon, 19 Apr 2021 15:05:18 +0200
Message-Id: <20210419130528.041395384@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
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
index fb97c9f319a5..b3ab86ced355 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -1259,8 +1259,14 @@ static ssize_t op_cap_show(struct device *dev,
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



