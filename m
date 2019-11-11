Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67517F7CB7
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbfKKStC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:49:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbfKKStC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:49:02 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B56B21925;
        Mon, 11 Nov 2019 18:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498141;
        bh=j5CCEFjOwFx4QIPsec2MwI1geNv6hrXs7BjEbUEosnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s0NKV+Vmihu5wre5bajD944IDjdbz9hA9uqqb9H0GMoAIHNA+KmTeDkIsEcSOMFsk
         emLVqQs/Plr6OKxH6cefbUIRMrMD3nUx2YDX2QXjdqhwYkWIDAdyjdXAEDBspvzFjJ
         Uz6qP0fckwGYNxr2ODUl0rCLT8VXliQF0lR+dQ/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.3 035/193] btrfs: Consider system chunk array size for new SYSTEM chunks
Date:   Mon, 11 Nov 2019 19:26:57 +0100
Message-Id: <20191111181503.569237542@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit c17add7a1c61a15578e4071ed7bfd460fd041c43 upstream.

For SYSTEM chunks, despite the regular chunk item size limit, there is
another limit due to system chunk array size.

The extra limit was removed in a refactoring, so add it back.

Fixes: e3ecdb3fdecf ("btrfs: factor out devs_max setting in __btrfs_alloc_chunk")
CC: stable@vger.kernel.org # 5.3+
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -4976,6 +4976,7 @@ static int __btrfs_alloc_chunk(struct bt
 	} else if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
 		max_stripe_size = SZ_32M;
 		max_chunk_size = 2 * max_stripe_size;
+		devs_max = min_t(int, devs_max, BTRFS_MAX_DEVS_SYS_CHUNK);
 	} else {
 		btrfs_err(info, "invalid chunk type 0x%llx requested",
 		       type);


