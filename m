Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D6547ABD7
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:39:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbhLTOj0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:39:26 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:53110 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234590AbhLTOiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:38:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D464ACE1102;
        Mon, 20 Dec 2021 14:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8B4C36AE8;
        Mon, 20 Dec 2021 14:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011123;
        bh=OBqR1XEnRcNrzGcY/nxPAHYuBxxzV8Ik7lI797WSh4w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PPYih6BO9a+NDj1Qn9Sgu7QSo9fJX3rNCaOxPjmTH93mwtQ4Tt3nnONLbg7GcoxuG
         8NtktRrxwKj1Gp0jS3pJw0ApEPB/73RzMngtxtFd1StF0RJnldgZE571BF4fnZu/GK
         +6WkJz0C2GafT+y6hePR6hn8Cri6NP+6iaFAfbPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joe Thornber <ejt@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 12/45] dm btree remove: fix use after free in rebalance_children()
Date:   Mon, 20 Dec 2021 15:34:07 +0100
Message-Id: <20211220143022.678962718@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143022.266532675@linuxfoundation.org>
References: <20211220143022.266532675@linuxfoundation.org>
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
 


