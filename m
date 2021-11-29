Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 056D04626D4
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:54:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235287AbhK2W5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:57:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235442AbhK2W5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:57:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A02C12533D;
        Mon, 29 Nov 2021 10:27:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CEC4B815CF;
        Mon, 29 Nov 2021 18:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345E3C53FC7;
        Mon, 29 Nov 2021 18:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210457;
        bh=1bJXgMPjotzg4shCd/vFtSiQm9PWDHgzlsTJ28Iny8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ha+MN+/dp9CJiziiG82c0fmZhu+ere17FgKOgUwoqdsaL3IQzj0gwGIRbRkDYVwYO
         iWKd5/dMfgO6NzLWX3oNoGh2+pUTMPmxNph8JranF9y85Up/g8RucAQaPD+tOjcEud
         140GF6S80wQ9Lg4/kckc7QkwUTgaDvq4HudWY6u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Weichao Guo <guoweichao@oppo.com>,
        Chao Yu <chao@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 76/92] f2fs: set SBI_NEED_FSCK flag when inconsistent node block found
Date:   Mon, 29 Nov 2021 19:18:45 +0100
Message-Id: <20211129181709.942185946@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181707.392764191@linuxfoundation.org>
References: <20211129181707.392764191@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weichao Guo <guoweichao@oppo.com>

[ Upstream commit 6663b138ded1a59e630c9e605e42aa7fde490cdc ]

Inconsistent node block will cause a file fail to open or read,
which could make the user process crashes or stucks. Let's mark
SBI_NEED_FSCK flag to trigger a fix at next fsck time. After
unlinking the corrupted file, the user process could regenerate
a new one and work correctly.

Signed-off-by: Weichao Guo <guoweichao@oppo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 4cb182c20eedd..0cd1d51dde06d 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1385,6 +1385,7 @@ static struct page *__get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid,
 			  nid, nid_of_node(page), ino_of_node(page),
 			  ofs_of_node(page), cpver_of_node(page),
 			  next_blkaddr_of_node(page));
+		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		err = -EINVAL;
 out_err:
 		ClearPageUptodate(page);
-- 
2.33.0



