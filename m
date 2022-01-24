Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E8F498B3E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:12:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346243AbiAXTM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:12:29 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38610 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345227AbiAXTIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:08:53 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E764F60B7B;
        Mon, 24 Jan 2022 19:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EB2C340E7;
        Mon, 24 Jan 2022 19:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051331;
        bh=3pko/fty3e1jkvDU+lcK2yAE20crUsN5XxWJWc2HQzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNtbOkU5QyDqcdYKNE14UXxfyZluNHUn8TuksO3QeUmbyQNjpHZrXvjlZWesPKCNM
         oZ4TGr20JfQctIMsLBRF+ZM94KabjTdf1dCQlMgVs55EXSVkBcbWVRYESRQh6a/yk1
         dxNyeRC7gqLu8n/vv+rOuRTI2wDWFGO/8p/SzN8g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 127/186] dm space map common: add bounds check to sm_ll_lookup_bitmap()
Date:   Mon, 24 Jan 2022 19:43:22 +0100
Message-Id: <20220124183941.195964703@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
index a2eceb12f01d4..1095b90307aed 100644
--- a/drivers/md/persistent-data/dm-space-map-common.c
+++ b/drivers/md/persistent-data/dm-space-map-common.c
@@ -279,6 +279,11 @@ int sm_ll_lookup_bitmap(struct ll_disk *ll, dm_block_t b, uint32_t *result)
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



