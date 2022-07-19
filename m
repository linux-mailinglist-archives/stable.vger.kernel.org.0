Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B58CA579E70
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242503AbiGSNBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242540AbiGSM6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:58:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DB05C947;
        Tue, 19 Jul 2022 05:23:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 148E7B81A7F;
        Tue, 19 Jul 2022 12:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69239C341C6;
        Tue, 19 Jul 2022 12:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233422;
        bh=MbtqvblcDyxVBgmf+7fz/Bb/HJlp2IV/sr6R4VkWY+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+EtxXa7EYARDOCVBu1fAj/Sr2LRG+k+cdsshGM2vfolxa/zfTpevfzZvTwPdTns/
         FsTLESy638klkYFuJzs6F3VdbPrbGeKppHaUWcbMtGm9HDBWuauKBcNeAuDj9mwFH4
         U4odKkGzm6ROXjFyn+QNy96q1RCAGQBqez2yyLbU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Demi Marie Obenour <demi@invisiblethingslab.com>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 091/231] xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE
Date:   Tue, 19 Jul 2022 13:52:56 +0200
Message-Id: <20220719114722.395824225@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Demi Marie Obenour <demi@invisiblethingslab.com>

[ Upstream commit 166d3863231667c4f64dee72b77d1102cdfad11f ]

The error paths of gntdev_mmap() can call unmap_grant_pages() even
though not all of the pages have been successfully mapped.  This will
trigger the WARN_ON()s in __unmap_grant_pages_done().  The number of
warnings can be very large; I have observed thousands of lines of
warnings in the systemd journal.

Avoid this problem by only warning on unmapping failure if the handle
being unmapped is not INVALID_GRANT_HANDLE.  The handle field of any
page that was not successfully mapped will be INVALID_GRANT_HANDLE, so
this catches all cases where unmapping can legitimately fail.

Fixes: dbe97cff7dd9 ("xen/gntdev: Avoid blocking in unmap_grant_pages()")
Cc: stable@vger.kernel.org
Suggested-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Reviewed-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220710230522.1563-1-demi@invisiblethingslab.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/gntdev.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 4b56c39f766d..84b143eef395 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -396,13 +396,15 @@ static void __unmap_grant_pages_done(int result,
 	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
 	for (i = 0; i < data->count; i++) {
-		WARN_ON(map->unmap_ops[offset+i].status);
+		WARN_ON(map->unmap_ops[offset + i].status != GNTST_okay &&
+			map->unmap_ops[offset + i].handle != INVALID_GRANT_HANDLE);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		if (use_ptemod) {
-			WARN_ON(map->kunmap_ops[offset+i].status);
+			WARN_ON(map->kunmap_ops[offset + i].status != GNTST_okay &&
+				map->kunmap_ops[offset + i].handle != INVALID_GRANT_HANDLE);
 			pr_debug("kunmap handle=%u st=%d\n",
 				 map->kunmap_ops[offset+i].handle,
 				 map->kunmap_ops[offset+i].status);
-- 
2.35.1



