Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541CA3C5083
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243082AbhGLHdZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344284AbhGLHbr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:31:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BB2361006;
        Mon, 12 Jul 2021 07:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074939;
        bh=Jg8z/8IEh9vpRBer/W8W+kaPGm0Aa+Mcw8WTt9X+wz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3lukNRSqXAdIUwPgg6iP67FJkJgahZXPCMpm0/Ow7czvwcVoi0i8vIhjACe0B9qp
         LKc/k2WSI24kqKYMRrRq9Tcv/hsaF/0y/vrDDA1Wky5cJfzEJCuizsjzve0t15KeQj
         sIUrLpigNzUeNugDg9O09wQNG22gxyMKPqVrQGoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qu Wenruo <wqu@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 5.13 050/800] btrfs: fix unbalanced unlock in qgroup_account_snapshot()
Date:   Mon, 12 Jul 2021 08:01:13 +0200
Message-Id: <20210712060920.464558278@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naohiro Aota <naohiro.aota@wdc.com>

commit 44365827cccc1441d4187509257e5276af133a49 upstream.

qgroup_account_snapshot() is trying to unlock the not taken
tree_log_mutex in a error path. Since ret != 0 in this case, we can
just return from here.

Fixes: 2a4d84c11a87 ("btrfs: move delayed ref flushing for qgroup into qgroup helper")
CC: stable@vger.kernel.org # 5.12+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1476,7 +1476,7 @@ static int qgroup_account_snapshot(struc
 	ret = btrfs_run_delayed_refs(trans, (unsigned long)-1);
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
-		goto out;
+		return ret;
 	}
 
 	/*


