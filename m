Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FB240E2C2
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242201AbhIPQl1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244564AbhIPQjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:39:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1AFB6140D;
        Thu, 16 Sep 2021 16:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809388;
        bh=SrWbsL2c+wTgUKVBk/2/fr0BKD/MEpUT2ZCFzwO+5tw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mWfO7QxKUvU4RDoLuzHn18tdKzHlfT6tFZklAr8qj4NcpKfUhbwZjhqJz9AnL6NGO
         s3UHMuHP0lf9tyS5Ic1J4YTqVt+qldxchAdTAq+Lvo0JElQe7+ujo4DYraCzzrNGEa
         +oezw4oTeK8aINCd6jbs7kzhnl2OztH2r2DUsJNM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 135/380] f2fs: should put a page beyond EOF when preparing a write
Date:   Thu, 16 Sep 2021 17:58:12 +0200
Message-Id: <20210916155808.633622396@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 9605f75cf36e0bcc0f4ada07b5be712d30107607 ]

The prepare_compress_overwrite() gets/locks a page to prepare a read, and calls
f2fs_read_multi_pages() which checks EOF first. If there's any page beyond EOF,
we unlock the page and set cc->rpages[i] = NULL, which we can't put the page
anymore. This makes page leak, so let's fix by putting that page.

Fixes: a949dc5f2c5c ("f2fs: compress: fix race condition of overwrite vs truncate")
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 3cd509b085f2..198e5ad7c98b 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2151,6 +2151,8 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
 			continue;
 		}
 		unlock_page(page);
+		if (for_write)
+			put_page(page);
 		cc->rpages[i] = NULL;
 		cc->nr_rpages--;
 	}
-- 
2.30.2



