Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BB622644C
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730343AbgGTPn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730342AbgGTPn7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:43:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91A902065E;
        Mon, 20 Jul 2020 15:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259839;
        bh=cGe61lbOqkSpfEAcXd4jQngPZQxa5uwJDyeySxi7nX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kysi8oz72S4TND8kwQqqJi31/TPlHkWhimdPzBn5B2MpdAT16xzhDCaRorZFfiju
         DKWcygVoZgYtjLnjGMwvmyUpMXkSqmUDwFGQ1BLUHIPi7saaCXkERSpfjsPWr2DLKZ
         cIOBrFGuhS5Oj+j4RvVzZ+VvsiqA2Odz2euOohLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhang Xiaoxu <zhangxiaoxu5@huawei.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 012/125] cifs: update ctime and mtime during truncate
Date:   Mon, 20 Jul 2020 17:35:51 +0200
Message-Id: <20200720152803.556229771@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>

[ Upstream commit 5618303d8516f8ac5ecfe53ee8e8bc9a40eaf066 ]

As the man description of the truncate, if the size changed,
then the st_ctime and st_mtime fields should be updated. But
in cifs, we doesn't do it.

It lead the xfstests generic/313 failed.

So, add the ATTR_MTIME|ATTR_CTIME flags on attrs when change
the file size

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 528fe225b65a9..d0d295a28b6e4 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2216,6 +2216,15 @@ set_size_out:
 	if (rc == 0) {
 		cifsInode->server_eof = attrs->ia_size;
 		cifs_setsize(inode, attrs->ia_size);
+
+		/*
+		 * The man page of truncate says if the size changed,
+		 * then the st_ctime and st_mtime fields for the file
+		 * are updated.
+		 */
+		attrs->ia_ctime = attrs->ia_mtime = current_time(inode);
+		attrs->ia_valid |= ATTR_CTIME | ATTR_MTIME;
+
 		cifs_truncate_page(inode->i_mapping, inode->i_size);
 	}
 
-- 
2.25.1



