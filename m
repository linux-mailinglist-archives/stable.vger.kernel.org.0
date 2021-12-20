Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862EC47AB88
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbhLTOh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234092AbhLTOhL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:37:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368B6C06173F;
        Mon, 20 Dec 2021 06:37:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 87719CE10C2;
        Mon, 20 Dec 2021 14:37:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56697C36AE9;
        Mon, 20 Dec 2021 14:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011027;
        bh=OBqR1XEnRcNrzGcY/nxPAHYuBxxzV8Ik7lI797WSh4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hd3i56IAEto6WTmwUSWLkZffRveiUrz/Ft+iQQi+FAY5OFLX5MJ4CNAL9U+ETwpjS
         7Vh/sM4ly6IqazP8CJlgVNS48Z/Xs3pNyLOh9u2EUXYrxzRYBoMB4eJk12m8pRxQaZ
         /amWiC1EPoWgcnz1IH1MlRGda1WuK6pl79XBY5qA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.9 10/31] dm btree remove: fix use after free in rebalance_children()
Date:   Mon, 20 Dec 2021 15:34:10 +0100
Message-Id: <20211220143020.318642651@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143019.974513085@linuxfoundation.org>
References: <20211220143019.974513085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Thornber <ejt@redhat.com>

commit 1b8d2789dad0005fd5e7d35dab26a8e1203fb6da upstream.

Move dm_tm_unlock() after dm_tm_dec().

Cc: stable@vger.kernel.org
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-btree-remove.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -423,9 +423,9 @@ static int rebalance_children(struct sha
 
 		memcpy(n, dm_block_data(child),
 		       dm_bm_block_size(dm_tm_get_bm(info->tm)));
-		dm_tm_unlock(info->tm, child);
 
 		dm_tm_dec(info->tm, dm_block_location(child));
+		dm_tm_unlock(info->tm, child);
 		return 0;
 	}
 


