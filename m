Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A02B20176E
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395216AbgFSQi3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388961AbgFSOrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:47:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B5F322083B;
        Fri, 19 Jun 2020 14:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578045;
        bh=MavuaE6RpHO1pjmAVmuBsMf1W73U+3iUQqhX42rPWaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bbes5PIISWzuNXsS7LEyQG8W3IYCwn2a9fjALS18QCBx2qpB/q2IQU+GyzGJxkLEC
         1FiiuD4eORkZygnQ5CdxNtdDH5jMlXkEWJ8pKWpFXN5HnI+VWI0tZiLEiat3Mq98Na
         4NQGYf2Fx0l3dO/vATCA9dfOYBkH2wRR9xs5r8Z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 030/190] cgroup, blkcg: Prepare some symbols for module and !CONFIG_CGROUP usages
Date:   Fri, 19 Jun 2020 16:31:15 +0200
Message-Id: <20200619141635.040613472@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 9b0eb69b75bccada2d341d7e7ca342f0cb1c9a6a upstream.

btrfs is going to use css_put() and wbc helpers to improve cgroup
writeback support.  Add dummy css_get() definition and export wbc
helpers to prepare for module and !CONFIG_CGROUP builds.

[only backport the export of __inode_attach_wb for stable kernels - gregkh]

Reported-by: kbuild test robot <lkp@intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fs-writeback.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -269,6 +269,7 @@ void __inode_attach_wb(struct inode *ino
 	if (unlikely(cmpxchg(&inode->i_wb, NULL, wb)))
 		wb_put(wb);
 }
+EXPORT_SYMBOL_GPL(__inode_attach_wb);
 
 /**
  * locked_inode_to_wb_and_lock_list - determine a locked inode's wb and lock it


