Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A42C627FE5
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237633AbiKNNCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237682AbiKNNC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:02:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9F629355
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B346B80EC1
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BDEC433C1;
        Mon, 14 Nov 2022 13:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430943;
        bh=TQn+G9cesH57hJ5I0xGVVi0ZmJEwcJWIU4wwEylNziA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EpdC1zddMHf8wmC9FUUzsafoIulb1MSDQjviLVbDeLg/oL9P/fbpk1TlZLyzhn72S
         qzk/49X/Jkgl+0xeRAiUp4sYvTv0xru0lBLBH/yQ1pfN6E5Q2yNW/qVdug1ChcZbh8
         3uTfaSflEJdatswliEWjt1OoWfZrr6KyUToXAVVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ben Widawsky <bwidawsk@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 013/190] cxl/region: Recycle region ids
Date:   Mon, 14 Nov 2022 13:43:57 +0100
Message-Id: <20221114124459.373873290@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 8f401ec1c8975eabfe4c089de91cbe058deabf71 ]

At region creation time the next region-id is atomically cached so that
there is predictability of region device names. If that region is
destroyed and then a new one is created the region id increments. That
ends up looking like a memory leak, or is otherwise surprising that
identifiers roll forward even after destroying all previously created
regions.

Try to reuse rather than free old region ids at region release time.

While this fixes a cosmetic issue, the needlessly advancing memory
region-id gives the appearance of a memory leak, hence the "Fixes" tag,
but no "Cc: stable" tag.

Cc: Ben Widawsky <bwidawsk@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/166752186062.947915.13200195701224993317.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 6b7fb955a05a..78344e4d4215 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1533,9 +1533,24 @@ static const struct attribute_group *region_groups[] = {
 
 static void cxl_region_release(struct device *dev)
 {
+	struct cxl_root_decoder *cxlrd = to_cxl_root_decoder(dev->parent);
 	struct cxl_region *cxlr = to_cxl_region(dev);
+	int id = atomic_read(&cxlrd->region_id);
+
+	/*
+	 * Try to reuse the recently idled id rather than the cached
+	 * next id to prevent the region id space from increasing
+	 * unnecessarily.
+	 */
+	if (cxlr->id < id)
+		if (atomic_try_cmpxchg(&cxlrd->region_id, &id, cxlr->id)) {
+			memregion_free(id);
+			goto out;
+		}
 
 	memregion_free(cxlr->id);
+out:
+	put_device(dev->parent);
 	kfree(cxlr);
 }
 
@@ -1597,6 +1612,11 @@ static struct cxl_region *cxl_region_alloc(struct cxl_root_decoder *cxlrd, int i
 	device_initialize(dev);
 	lockdep_set_class(&dev->mutex, &cxl_region_key);
 	dev->parent = &cxlrd->cxlsd.cxld.dev;
+	/*
+	 * Keep root decoder pinned through cxl_region_release to fixup
+	 * region id allocations
+	 */
+	get_device(dev->parent);
 	device_set_pm_not_required(dev);
 	dev->bus = &cxl_bus_type;
 	dev->type = &cxl_region_type;
-- 
2.35.1



