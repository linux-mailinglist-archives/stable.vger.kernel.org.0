Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B20247ACC0
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbhLTOqi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:46:38 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:36400 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236252AbhLTOo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:44:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B42F611B0;
        Mon, 20 Dec 2021 14:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE49AC36AE8;
        Mon, 20 Dec 2021 14:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011465;
        bh=OBqR1XEnRcNrzGcY/nxPAHYuBxxzV8Ik7lI797WSh4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k11cMD6tdbUN5oOmcC+LFlYsMacYkyctu0zkJ8tKyjlcGfiGvOBqJujxsjyyEuT6/
         k4XApF+iInHOir1z2MyXDosd6QaOYTAlNaEAiP42CE1tycS/zbLut01RzdSu/3fCng
         fYCSrH4OIFaaP4PXNQV/0ylXdskfhpN86Skz5MSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.4 07/71] dm btree remove: fix use after free in rebalance_children()
Date:   Mon, 20 Dec 2021 15:33:56 +0100
Message-Id: <20211220143025.927709379@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
 


