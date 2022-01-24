Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5919F49A3FC
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369350AbiAYABd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1848236AbiAXXWB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:22:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0388C0219E6;
        Mon, 24 Jan 2022 13:28:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7073E61320;
        Mon, 24 Jan 2022 21:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D476C33E61;
        Mon, 24 Jan 2022 21:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059730;
        bh=+j/hF9KUbkWpVpF0TWD+CJhI+JZR0eec5rq0R+03JEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jm7gwoBSmtArZ6qliUrCFMhWvZ1s7Zd0QK19u/VKyzZHPRYpcBk7I3CORfEBHFISd
         HnEPQPjBKiVRlbPeM5Xb/kh+yzbiM7PNM7knBL/ZwbWmNdBsjoZBmY8huuJpd38veN
         QUZW+lbujX2Z2xZ4m1DLHy8sW4uMAjfOjEMY6YlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0714/1039] dm space map common: add bounds check to sm_ll_lookup_bitmap()
Date:   Mon, 24 Jan 2022 19:41:43 +0100
Message-Id: <20220124184149.335514594@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

[ Upstream commit cba23ac158db7f3cd48a923d6861bee2eb7a2978 ]

Corrupted metadata could warrant returning error from sm_ll_lookup_bitmap().

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/persistent-data/dm-space-map-common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/md/persistent-data/dm-space-map-common.c b/drivers/md/persistent-data/dm-space-map-common.c
index 4a6a2a9b4eb49..bfbfa750e0160 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -283,6 +283,11 @@ int sm_ll_lookup_bitmap(struct ll_disk *ll, dm_block_t b, uint32_t *result)
 	struct disk_index_entry ie_disk;
 	struct dm_block *blk;
 
+	if (b >= ll->nr_blocks) {
+		DMERR_LIMIT("metadata block out of bounds");
+		return -EINVAL;
+	}
+
 	b = do_div(index, ll->entries_per_block);
 	r = ll->load_ie(ll, index, &ie_disk);
 	if (r < 0)
-- 
2.34.1



