Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3D1C3786A2
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbhEJLJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233645AbhEJLBs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:01:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53A9C61C55;
        Mon, 10 May 2021 10:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644025;
        bh=j+yJxaDaNg+0dsAfuh4blpsx95zm7XMjaysqroZ6ZpI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GNyv+DC0WQl5BGw9htDpPozkHPOb13t9NLiXOu+1Duc2L00Jt/q8D7U4d5JIspfJW
         dWL/FWJFE0IDrbrrSa12gKQIIMFH7HFQs7waYEp4Obn47O9AyrJyQlB2cEsQ8NnApm
         6LDu9aQ6M4O0f8WQ+0VqH2nMYkN1wPopVwLLJrGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guochun Mao <guochun.mao@mediatek.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.11 258/342] ubifs: Only check replay with inode type to judge if inode linked
Date:   Mon, 10 May 2021 12:20:48 +0200
Message-Id: <20210510102018.622052163@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guochun Mao <guochun.mao@mediatek.com>

commit 3e903315790baf4a966436e7f32e9c97864570ac upstream.

Conside the following case, it just write a big file into flash,
when complete writing, delete the file, and then power off promptly.
Next time power on, we'll get a replay list like:
...
LEB 1105:211344 len 4144 deletion 0 sqnum 428783 key type 1 inode 80
LEB 15:233544 len 160 deletion 1 sqnum 428785 key type 0 inode 80
LEB 1105:215488 len 4144 deletion 0 sqnum 428787 key type 1 inode 80
...
In the replay list, data nodes' deletion are 0, and the inode node's
deletion is 1. In current logic, the file's dentry will be removed,
but inode and the flash space it occupied will be reserved.
User will see that much free space been disappeared.

We only need to check the deletion value of the following inode type
node of the replay entry.

Fixes: e58725d51fa8 ("ubifs: Handle re-linking of inodes correctly while recovery")
Cc: stable@vger.kernel.org
Signed-off-by: Guochun Mao <guochun.mao@mediatek.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/replay.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ubifs/replay.c
+++ b/fs/ubifs/replay.c
@@ -223,7 +223,8 @@ static bool inode_still_linked(struct ub
 	 */
 	list_for_each_entry_reverse(r, &c->replay_list, list) {
 		ubifs_assert(c, r->sqnum >= rino->sqnum);
-		if (key_inum(c, &r->key) == key_inum(c, &rino->key))
+		if (key_inum(c, &r->key) == key_inum(c, &rino->key) &&
+		    key_type(c, &r->key) == UBIFS_INO_KEY)
 			return r->deletion == 0;
 
 	}


