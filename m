Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7889FFA439
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfKMCPM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:15:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:49814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728043AbfKMB47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:59 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8EAC22470;
        Wed, 13 Nov 2019 01:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610218;
        bh=65esZw1aId9cAb4fmPQLAQBAEwuFCvYbnG/uf8OmSco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nYIRSaKaeVXCYTmMwl1gQg+c2z8vv6sJHDFv5DOBVS/9y8mL11ccSeDToJn5R1aYj
         XwPveki0BP2Nl6+qq/XrUjR5WMDTO/LL8Re18d1vuF7Un/8LbJ8yqBXDKiJdKFJGt8
         5TKx/E1wm6kjXZXfpgMoU+0+z/ciKlW0EP4R1mMg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        Theodore Ts'o <tytso@mit.edu>,
        Lukas Czerner <lczerner@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 025/115] ext4: fix build error when DX_DEBUG is defined
Date:   Tue, 12 Nov 2019 20:54:52 -0500
Message-Id: <20191113015622.11592-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.co.uk>

[ Upstream commit 799578ab16e86b074c184ec5abbda0bc698c7b0b ]

Enabling DX_DEBUG triggers the build error below.  info is an attribute
of  the dxroot structure.

linux/fs/ext4/namei.c:2264:12: error: ‘info’
undeclared (first use in this function); did you mean ‘insl’?
	   	  info->indirect_levels));

Fixes: e08ac99fa2a2 ("ext4: add largedir feature")
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.co.uk>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 162e853dc5d65..212b01861d941 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2293,7 +2293,7 @@ static int ext4_dx_add_entry(handle_t *handle, struct ext4_filename *fname,
 			dxroot->info.indirect_levels += 1;
 			dxtrace(printk(KERN_DEBUG
 				       "Creating %d level index...\n",
-				       info->indirect_levels));
+				       dxroot->info.indirect_levels));
 			err = ext4_handle_dirty_dx_node(handle, dir, frame->bh);
 			if (err)
 				goto journal_error;
-- 
2.20.1

