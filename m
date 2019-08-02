Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 830827F219
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405367AbfHBJpG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:45:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391427AbfHBJpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:45:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96C16206A2;
        Fri,  2 Aug 2019 09:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739106;
        bh=vKf32q65zRrUqXjgTIshNmaH5u4Af8xf9cCTJw1iZ6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FRzZyLne6G5HedSRtuIf8U9645h2Nmc5cynPrnUFwdRMX5boysROvFksm+vDNlRQs
         tWTHS41I/UUNUDnf8QJG2Lk7inuWMIU1jPU3X+wFXVrbv/njNeuv6cAwah1xa5ZnEF
         rskqKlSA9UTI92teu91eXM+sxInxRLZdn+WKGgOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 4.9 101/223] Btrfs: add missing inode version, ctime and mtime updates when punching hole
Date:   Fri,  2 Aug 2019 11:35:26 +0200
Message-Id: <20190802092245.727999924@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 179006688a7e888cbff39577189f2e034786d06a upstream.

If the range for which we are punching a hole covers only part of a page,
we end up updating the inode item but we skip the update of the inode's
iversion, mtime and ctime. Fix that by ensuring we update those properties
of the inode.

A patch for fstests test case generic/059 that tests this as been sent
along with this fix.

Fixes: 2aaa66558172b0 ("Btrfs: add hole punching")
Fixes: e8c1c76e804b18 ("Btrfs: add missing inode update when punching hole")
CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/file.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -2646,6 +2646,11 @@ out_only_mutex:
 		 * for detecting, at fsync time, if the inode isn't yet in the
 		 * log tree or it's there but not up to date.
 		 */
+		struct timespec now = current_time(inode);
+
+		inode_inc_iversion(inode);
+		inode->i_mtime = now;
+		inode->i_ctime = now;
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
 			err = PTR_ERR(trans);


