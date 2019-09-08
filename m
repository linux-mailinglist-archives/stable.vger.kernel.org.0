Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABF7ACDF3
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbfIHMsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:38164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731174AbfIHMss (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:48:48 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7646A218AF;
        Sun,  8 Sep 2019 12:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946928;
        bh=lFnABTanQs6IkhrV1YIcC5mhDXDuSQ4tMUwczAbIc5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yvhUQrhB1hrkDtcfUnExTC21utB7fC0+juXMqmN/SXgl6bBKw9zmXNLWsxB8gz6Ew
         9Yhqw0DLId6NYB58GXrjYaRht8ab2CEOWntZsWcQ50BvJfsaz66hD27dKwPG8M+imT
         mn6O8aDreH4FtyWBCVgq+DTdPYytjB/v2Hww6zs4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/57] afs: Fix leak in afs_lookup_cell_rcu()
Date:   Sun,  8 Sep 2019 13:42:17 +0100
Message-Id: <20190908121146.244098641@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a5fb8e6c02d6a518fb2b1a2b8c2471fa77b69436 ]

Fix a leak on the cell refcount in afs_lookup_cell_rcu() due to
non-clearance of the default error in the case a NULL cell name is passed
and the workstation default cell is used.

Also put a bit at the end to make sure we don't leak a cell ref if we're
going to be returning an error.

This leak results in an assertion like the following when the kafs module is
unloaded:

	AFS: Assertion failed
	2 == 1 is false
	0x2 == 0x1 is false
	------------[ cut here ]------------
	kernel BUG at fs/afs/cell.c:770!
	...
	RIP: 0010:afs_manage_cells+0x220/0x42f [kafs]
	...
	 process_one_work+0x4c2/0x82c
	 ? pool_mayday_timeout+0x1e1/0x1e1
	 ? do_raw_spin_lock+0x134/0x175
	 worker_thread+0x336/0x4a6
	 ? rescuer_thread+0x4af/0x4af
	 kthread+0x1de/0x1ee
	 ? kthread_park+0xd4/0xd4
	 ret_from_fork+0x24/0x30

Fixes: 989782dcdc91 ("afs: Overhaul cell database management")
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/cell.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/afs/cell.c b/fs/afs/cell.c
index 6127f0fcd62c4..ee07162d35c7a 100644
--- a/fs/afs/cell.c
+++ b/fs/afs/cell.c
@@ -76,6 +76,7 @@ struct afs_cell *afs_lookup_cell_rcu(struct afs_net *net,
 			cell = rcu_dereference_raw(net->ws_cell);
 			if (cell) {
 				afs_get_cell(cell);
+				ret = 0;
 				break;
 			}
 			ret = -EDESTADDRREQ;
@@ -110,6 +111,9 @@ struct afs_cell *afs_lookup_cell_rcu(struct afs_net *net,
 
 	done_seqretry(&net->cells_lock, seq);
 
+	if (ret != 0 && cell)
+		afs_put_cell(net, cell);
+
 	return ret == 0 ? cell : ERR_PTR(ret);
 }
 
-- 
2.20.1



