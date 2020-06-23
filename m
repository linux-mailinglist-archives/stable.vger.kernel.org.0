Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A769420631B
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389297AbgFWURJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:32942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389246AbgFWURH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:17:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5A1920EDD;
        Tue, 23 Jun 2020 20:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943427;
        bh=+ziwtcFcjYY6IwIDJw9/Rf35c4EBPBwQnesZBFk+Gto=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AQLpUmjY6I2DokRCjYZNMIDO6O7OJEPO/cShWz9LNtZ3FIcbxhTGgVz7dO+mhZa2z
         OPDKLK8zIcXBnOhIW3JCjuBh38EOyWgiX/IX/CbWyciGBxZw2JuxEKq/ncRugf6M/K
         RCAa+BzycMpA1kbE9yeH7rfMK/t7fewjgID7827o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, yangerkun <yangerkun@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 387/477] ext4: stop overwrite the errcode in ext4_setup_super
Date:   Tue, 23 Jun 2020 21:56:24 +0200
Message-Id: <20200623195425.821712285@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

[ Upstream commit 5adaccac46ea79008d7b75f47913f1a00f91d0ce ]

Now the errcode from ext4_commit_super will overwrite EROFS exists in
ext4_setup_super. Actually, no need to call ext4_commit_super since we
will return EROFS. Fix it by goto done directly.

Fixes: c89128a00838 ("ext4: handle errors on ext4_commit_super")
Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200601073404.3712492-1-yangerkun@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6135e187e3ed9..8bf6ef1972f4b 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2344,6 +2344,7 @@ static int ext4_setup_super(struct super_block *sb, struct ext4_super_block *es,
 		ext4_msg(sb, KERN_ERR, "revision level too high, "
 			 "forcing read-only mode");
 		err = -EROFS;
+		goto done;
 	}
 	if (read_only)
 		goto done;
-- 
2.25.1



