Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8422E6555
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387829AbgL1NdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:33:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:59260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390640AbgL1NbN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:31:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C29A820719;
        Mon, 28 Dec 2020 13:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162258;
        bh=b01FG28bAqW0npP4iYMhAJICKnRlez/iQqlnBe5jC1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g1LfeG6xyuQydtVkkZxokaDl3+F8P3POc+PmagfoKoSB00nASFihY8YBwAei0PVRw
         R7b5j/iq83LD2MVc5uirBmaxddt2iL7flfz+5c8CjfK5jmTAZDApBTOlcFj0W7EqG7
         qumb/NEiRDT0dxMbiGy/EGDCh/uBDv7CZYJWim5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 241/346] libnvdimm/label: Return -ENXIO for no slot in __blk_label_update
Date:   Mon, 28 Dec 2020 13:49:20 +0100
Message-Id: <20201228124931.417433128@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 4c46764733c85b82c07e9559b39da4d00a7dd659 ]

Forget to set error code when nd_label_alloc_slot failed, and we
add it to avoid overwritten error code.

Fixes: 0ba1c634892b ("libnvdimm: write blk label set")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201205115056.2076523-1-zhangqilong3@huawei.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/label.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 9f1b7e3153f99..df9ca82f459ba 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -880,8 +880,10 @@ static int __blk_label_update(struct nd_region *nd_region,
 		if (is_old_resource(res, old_res_list, old_num_resources))
 			continue; /* carry-over */
 		slot = nd_label_alloc_slot(ndd);
-		if (slot == UINT_MAX)
+		if (slot == UINT_MAX) {
+			rc = -ENXIO;
 			goto abort;
+		}
 		dev_dbg(ndd->dev, "allocated: %d\n", slot);
 
 		nd_label = to_label(ndd, slot);
-- 
2.27.0



