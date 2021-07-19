Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E06A3CDC5F
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237560AbhGSOwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343777AbhGSOsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:48:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B11776124B;
        Mon, 19 Jul 2021 15:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708296;
        bh=C1ShubNXVTEITTM499ROiCEtSal1Awt21Bbup50aTP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WRkSJQxZIg/Q6jUHwrS8lapCXjz38ASlIc4Rk6F4d72fKf5IVdO9U4fhKd/dCoaQ4
         gb423XsH70vOZzQq9T/JMPVEKUVcSs4QSMjGCwLFUrgjjUyNpwyDXjbzg+ZaEF+LQP
         BwJy4nZ7CGl89/LW5pHhIeCEQdhRFt5asl5hFPZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Tao <houtao1@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.14 222/315] dm btree remove: assign new_root only when removal succeeds
Date:   Mon, 19 Jul 2021 16:51:51 +0200
Message-Id: <20210719144950.728049887@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

commit b6e58b5466b2959f83034bead2e2e1395cca8aeb upstream.

remove_raw() in dm_btree_remove() may fail due to IO read error
(e.g. read the content of origin block fails during shadowing),
and the value of shadow_spine::root is uninitialized, but
the uninitialized value is still assign to new_root in the
end of dm_btree_remove().

For dm-thin, the value of pmd->details_root or pmd->root will become
an uninitialized value, so if trying to read details_info tree again
out-of-bound memory may occur as showed below:

  general protection fault, probably for non-canonical address 0x3fdcb14c8d7520
  CPU: 4 PID: 515 Comm: dmsetup Not tainted 5.13.0-rc6
  Hardware name: QEMU Standard PC
  RIP: 0010:metadata_ll_load_ie+0x14/0x30
  Call Trace:
   sm_metadata_count_is_more_than_one+0xb9/0xe0
   dm_tm_shadow_block+0x52/0x1c0
   shadow_step+0x59/0xf0
   remove_raw+0xb2/0x170
   dm_btree_remove+0xf4/0x1c0
   dm_pool_delete_thin_device+0xc3/0x140
   pool_message+0x218/0x2b0
   target_message+0x251/0x290
   ctl_ioctl+0x1c4/0x4d0
   dm_ctl_ioctl+0xe/0x20
   __x64_sys_ioctl+0x7b/0xb0
   do_syscall_64+0x40/0xb0
   entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixing it by only assign new_root when removal succeeds

Signed-off-by: Hou Tao <houtao1@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/persistent-data/dm-btree-remove.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-btree-remove.c
+++ b/drivers/md/persistent-data/dm-btree-remove.c
@@ -549,7 +549,8 @@ int dm_btree_remove(struct dm_btree_info
 		delete_at(n, index);
 	}
 
-	*new_root = shadow_root(&spine);
+	if (!r)
+		*new_root = shadow_root(&spine);
 	exit_shadow_spine(&spine);
 
 	return r;


