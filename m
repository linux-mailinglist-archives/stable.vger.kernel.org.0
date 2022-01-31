Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7454A4521
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377561AbiAaLgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:36:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378563AbiAaLeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:34:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEEAC0698FD;
        Mon, 31 Jan 2022 03:23:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C36AB82A64;
        Mon, 31 Jan 2022 11:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3559C340E8;
        Mon, 31 Jan 2022 11:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628193;
        bh=cbobtbtWjowQxXmR99UJcmfS3g7Vir1jTIU17Q3iYDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMH16if/1CwcMDt1ciIZ/r+AuMCxaAy3Zb6O0t974AXvzgQ40zyGeEu+DgCbYOsyO
         weH/lPEWEOvwywi6l3G1iPEkj6ywHfZTTzvsNBhjzFfJRkTU9uPXmgba2GJ8Rb/iwL
         OBvRfHiZ1iuXPsYgjGaqggb3PEWN6ZXTtT/0KXPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 154/200] block: fix memory leak in disk_register_independent_access_ranges
Date:   Mon, 31 Jan 2022 11:56:57 +0100
Message-Id: <20220131105238.739717948@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 83114df32ae779df57e0af99a8ba6c3968b2ba3d ]

kobject_init_and_add() takes reference even when it fails.
According to the doc of kobject_init_and_add()

   If this function returns an error, kobject_put() must be called to
   properly clean up the memory associated with the object.

Fix this issue by adding kobject_put().
Callback function blk_ia_ranges_sysfs_release() in kobject_put()
can handle the pointer "iars" properly.

Fixes: a2247f19ee1c ("block: Add independent access ranges support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Link: https://lore.kernel.org/r/20220120101025.22411-1-linmq006@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-ia-ranges.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-ia-ranges.c b/block/blk-ia-ranges.c
index b925f3db3ab7a..18c68d8b9138e 100644
--- a/block/blk-ia-ranges.c
+++ b/block/blk-ia-ranges.c
@@ -144,7 +144,7 @@ int disk_register_independent_access_ranges(struct gendisk *disk,
 				   &q->kobj, "%s", "independent_access_ranges");
 	if (ret) {
 		q->ia_ranges = NULL;
-		kfree(iars);
+		kobject_put(&iars->kobj);
 		return ret;
 	}
 
-- 
2.34.1



