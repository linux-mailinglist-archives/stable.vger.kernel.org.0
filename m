Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FABA200D3B
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389889AbgFSOyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389886AbgFSOys (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:54:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53BB121556;
        Fri, 19 Jun 2020 14:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578488;
        bh=MavuaE6RpHO1pjmAVmuBsMf1W73U+3iUQqhX42rPWaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZ/+bV0s42CS5DDoJHSKn4ynmAhdVvAS3k9tfp+V3u6AQUWeRvFuv/F0r9ofbAV9D
         ZHBTzX/ErWaA+ciOsFTuCkjR/SIb5qJGGhXnklTDMBFjFRtYxPNGGsMRBMhjnmmXzm
         bv6ZSxvH+hoV4cD0axuu8+D0q8wkRAqA4apFwMzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 041/267] cgroup, blkcg: Prepare some symbols for module and !CONFIG_CGROUP usages
Date:   Fri, 19 Jun 2020 16:30:26 +0200
Message-Id: <20200619141650.826228685@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
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


