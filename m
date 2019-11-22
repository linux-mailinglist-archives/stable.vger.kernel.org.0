Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2649106F49
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbfKVKxL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:53:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:37422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729969AbfKVKxJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:53:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FC2620656;
        Fri, 22 Nov 2019 10:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419989;
        bh=65esZw1aId9cAb4fmPQLAQBAEwuFCvYbnG/uf8OmSco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WiBzalm4dvEQ4h/D3wz6/vkbS35fci9RXzdKFKOzeX7Ki//YkRZjnAsgvGFD8oeEA
         YtlokMTfmdekf2E0jhVhuGGUDcP82j8F+qHc1YFgxwHa6CzH9wsORaU9e9I4YNweHH
         YdAOqQvdhcYwGjb3x+oCtPgNbXKqosgwpbuPA+sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.co.uk>,
        Theodore Tso <tytso@mit.edu>,
        Lukas Czerner <lczerner@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 033/122] ext4: fix build error when DX_DEBUG is defined
Date:   Fri, 22 Nov 2019 11:28:06 +0100
Message-Id: <20191122100749.435343080@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



