Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66E422B6067
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:10:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbgKQNIt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:08:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:37476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbgKQNIs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:08:48 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9BC4238E6;
        Tue, 17 Nov 2020 13:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618528;
        bh=htQs+Zjnuk/vZn7s9XxNdJaGv3PG71BxdwzGEUq8XI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ToAop64pJtO/Vhq31nIJkC4jmWm2aR90jKeWCGjZDyfNukKIoRD7f4HJN78Ek4C5W
         1Ih8qPDN9ug2XJ5RKaAG79u2YWBFZeZ11A6p/dZQEsGbTSz6vAj8yhirW6VwA2SA+i
         BeB3rv8nV86ve7plHuF5m4obobutOOnHOiAehEzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Tao Ma <boyu.mt@taobao.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Theodore Tso <tytso@mit.edu>, stable@kernel.org
Subject: [PATCH 4.4 33/64] ext4: unlock xattr_sem properly in ext4_inline_data_truncate()
Date:   Tue, 17 Nov 2020 14:04:56 +0100
Message-Id: <20201117122107.788461293@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 7067b2619017d51e71686ca9756b454de0e5826a upstream.

It takes xattr_sem to check inline data again but without unlock it
in case not have. So unlock it before return.

Fixes: aef1c8513c1f ("ext4: let ext4_truncate handle inline data correctly")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://lore.kernel.org/r/1604370542-124630-1-git-send-email-joseph.qi@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/inline.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1892,6 +1892,7 @@ void ext4_inline_data_truncate(struct in
 
 	ext4_write_lock_xattr(inode, &no_expand);
 	if (!ext4_has_inline_data(inode)) {
+		ext4_write_unlock_xattr(inode, &no_expand);
 		*has_inline = 0;
 		ext4_journal_stop(handle);
 		return;


