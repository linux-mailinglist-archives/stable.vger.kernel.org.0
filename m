Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD189491B1C
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 04:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349166AbiARDD4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 22:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352817AbiARDAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 22:00:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADD0C02982F;
        Mon, 17 Jan 2022 18:46:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05766B81262;
        Tue, 18 Jan 2022 02:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE90C36AF2;
        Tue, 18 Jan 2022 02:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474007;
        bh=Bf2KpLKl42cxGt39Tk6pcrnnOXoTk3V933L/qa6WQzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnLR6STlwFN2rb1AXGCZGTQCWyuTkKm/d4GOu02evq011zz5DYe2iS28rdn8GPiIg
         tlg8xQeymeEqmqZmbHv+6l5VvgZzOkx8LKIYPpkOGgKc8ATrAYZ2guSONBitaa8JJg
         rdU1ShWMXWp7obCbae7mYXfNjTvVr0OnB4xGzdG8BJkMg2IeyEcVoAlhYce0hqdAeY
         HJrNcJP0cwKUY8I/0CuID1wgqhW+3nGWpKIfaMXtb9aIlvPoz7s4Di2HAxGjQjay1g
         BAYnHW53BI5xQtlGJtIhawrARCo3jFXoucqJbGouZRfkXT5L32Ueik1cjG7yZ81KFT
         kMeizLGf+Lefg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Joe Thornber <ejt@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>, agk@redhat.com,
        dm-devel@redhat.com
Subject: [PATCH AUTOSEL 5.4 66/73] dm space map common: add bounds check to sm_ll_lookup_bitmap()
Date:   Mon, 17 Jan 2022 21:44:25 -0500
Message-Id: <20220118024432.1952028-66-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a213bf11738fb..85853ab629717 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -281,6 +281,11 @@ int sm_ll_lookup_bitmap(struct ll_disk *ll, dm_block_t b, uint32_t *result)
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

