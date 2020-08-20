Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C95224AB9F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgHTACF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgHTACC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:02:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3192B208C7;
        Thu, 20 Aug 2020 00:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881721;
        bh=WUu1nmeECqgBkkf62NEGmJ1dhLGsP5wMDFpd2EjOBCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGlZ1vJcNQFLIPl+qzrULbv5xC/eBwGefve5kdVy+13dHedkuG3CFFXLQ7/BCpC9N
         RvuxZc+IvfpweCMX20NVlgnAT1J9WHXoCJeGtB/C2y6QRh8peYmT6QXrEyB1MMJh9U
         wjSGW5u9uxlJ59WB1XJV7vEcVrwic0bi+0uzNc80=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 5.7 04/24] f2fs: fix to check page dirty status before writeback
Date:   Wed, 19 Aug 2020 20:01:35 -0400
Message-Id: <20200820000155.215089-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000155.215089-1-sashal@kernel.org>
References: <20200820000155.215089-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit eb1353cfa9c1e9415b03dc117f8399969fa02102 ]

In f2fs_write_raw_pages(), we need to check page dirty status before
writeback, because there could be a racer (e.g. reclaimer) helps
writebacking the dirty page.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index a5b2e72174bb1..a1504a7aecb19 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1207,6 +1207,12 @@ static int f2fs_write_raw_pages(struct compress_ctx *cc,
 				congestion_wait(BLK_RW_ASYNC,
 						DEFAULT_IO_TIMEOUT);
 				lock_page(cc->rpages[i]);
+
+				if (!PageDirty(cc->rpages[i])) {
+					unlock_page(cc->rpages[i]);
+					continue;
+				}
+
 				clear_page_dirty_for_io(cc->rpages[i]);
 				goto retry_write;
 			}
-- 
2.25.1

