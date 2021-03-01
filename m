Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7BFA328957
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238673AbhCARzR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:55:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238973AbhCARtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:49:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C842650E3;
        Mon,  1 Mar 2021 16:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617987;
        bh=rs87uBFd5nCZoo/axef7avaywMygx+U0J16HvEfWy9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Da4MZf4bFE3bru2YC7OhpsM1gqnfH/2S4ClU2vGQOfC7QaAw3r2/2/jz9dk303MVO
         h3iqBBsOqRTZmu0crnOKP75SrkFovyGjXxTzpH+mOVpHYI/qeQpaQzIJiYcC6WzmiG
         jxdfNPc6egS9NNJr86KFwpn9vmMd9XWc0UEjLsSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.4 268/340] btrfs: fix extent buffer leak on failure to copy root
Date:   Mon,  1 Mar 2021 17:13:32 +0100
Message-Id: <20210301161101.481313004@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 72c9925f87c8b74f36f8e75a4cd93d964538d3ca upstream.

At btrfs_copy_root(), if the call to btrfs_inc_ref() fails we end up
returning without unlocking and releasing our reference on the extent
buffer named "cow" we previously allocated with btrfs_alloc_tree_block().

So fix that by unlocking the extent buffer and dropping our reference on
it before returning.

Fixes: be20aa9dbadc8c ("Btrfs: Add mount option to turn off data cow")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/ctree.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/ctree.c
+++ b/fs/btrfs/ctree.c
@@ -261,6 +261,8 @@ int btrfs_copy_root(struct btrfs_trans_h
 	else
 		ret = btrfs_inc_ref(trans, root, cow, 0);
 	if (ret) {
+		btrfs_tree_unlock(cow);
+		free_extent_buffer(cow);
 		btrfs_abort_transaction(trans, ret);
 		return ret;
 	}


