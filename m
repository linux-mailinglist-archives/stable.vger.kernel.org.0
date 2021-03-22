Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513773441C6
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhCVMfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:35:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231574AbhCVMee (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:34:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE33F619AE;
        Mon, 22 Mar 2021 12:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416474;
        bh=wE3n+IR1vhmM+m6NJuHoxgemHOou6C5HiMro205IsxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pCqloe9bnngxvcA/RhQZKI9v1JydfQDFxwbS6MKrg1R5PBXls8KM3wm6wANARMXF6
         8aK4sghC0cH8DlUuopNXdqsvRmUW+OJ3s31ljlwqmbtTrmXq0xZmEMTTx5fQxvYqYz
         p/jBpBcKePU8uySCq/DAeAnwcTJuqqqkW8/Wj0lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        stable@kernel.org,
        Harshad Shirwadkar <harshadshirwadkar@gmail.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.11 109/120] ext4: stop inode update before return
Date:   Mon, 22 Mar 2021 13:28:12 +0100
Message-Id: <20210322121933.297319814@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit 512c15ef05d73a04f1aef18a3bc61a8bb516f323 upstream.

The inode update should be stopped before returing the error code.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210117085732.93788-1-bianpan2016@163.com
Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Cc: stable@kernel.org
Reviewed-by: Harshad Shirwadkar <harshadshirwadkar@gmail.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5389,8 +5389,10 @@ int ext4_setattr(struct dentry *dentry,
 			inode->i_gid = attr->ia_gid;
 		error = ext4_mark_inode_dirty(handle, inode);
 		ext4_journal_stop(handle);
-		if (unlikely(error))
+		if (unlikely(error)) {
+			ext4_fc_stop_update(inode);
 			return error;
+		}
 	}
 
 	if (attr->ia_valid & ATTR_SIZE) {


