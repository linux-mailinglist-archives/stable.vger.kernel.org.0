Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C13C32E42EE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406980AbgL1Nvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:51:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406976AbgL1Nvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:51:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90BDD2072C;
        Mon, 28 Dec 2020 13:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163465;
        bh=ZnULBoh5qmZPHWWE9q2VxdVQt5TjHmDwwe8aLxDIELM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=njH5qYtdr/c+siwHn9LXpuALzstHUkAketjwse7aRsU1i++o16z029WbeXMwqv9ng
         Jl2m8NBFEa/O1YNowflgI6JhBSctv7M2EqOap+nTcxKTk4fNWcIhLOvUFwU0z2qNhX
         kkc3U7TF1CVkswdHgegGOPC8fLTuNBWKhzXM50Dk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 295/453] libnvdimm/label: Return -ENXIO for no slot in __blk_label_update
Date:   Mon, 28 Dec 2020 13:48:51 +0100
Message-Id: <20201228124951.399694435@linuxfoundation.org>
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
index 47a4828b8b310..05c1f186a6be8 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -999,8 +999,10 @@ static int __blk_label_update(struct nd_region *nd_region,
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



