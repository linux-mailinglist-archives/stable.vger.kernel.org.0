Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD3F428EC1
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237276AbhJKNvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236341AbhJKNvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:51:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A17B36103C;
        Mon, 11 Oct 2021 13:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960135;
        bh=J3sZIVQhNAnsybZFFKKMvQBCw2rLff2RVndDW7ltiFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QcOHt5qfgvk36oo37AhpTxojMHPRiPL4FpIBhMvuG3DRHQYGxmeCcikl/41vO7wZ4
         m6GdhSUm8WUDdUebXYKUT7Q9ZRoLEog5Nv5dv5g5OVTga9h35ycNjSyUIxPcTsQRTQ
         SQYc1h/+oMpbgEl25ap1tQdA+sEbnJ3tOjO4igm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick Ho <Patrick.Ho@netapp.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.4 08/52] nfsd: fix error handling of register_pernet_subsys() in init_nfsd()
Date:   Mon, 11 Oct 2021 15:45:37 +0200
Message-Id: <20211011134504.003354975@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134503.715740503@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Ho <Patrick.Ho@netapp.com>

commit 1d625050c7c2dd877e108e382b8aaf1ae3cfe1f4 upstream.

init_nfsd() should not unregister pernet subsys if the register fails
but should instead unwind from the last successful operation which is
register_filesystem().

Unregistering a failed register_pernet_subsys() call can result in
a kernel GPF as revealed by programmatically injecting an error in
register_pernet_subsys().

Verified the fix handled failure gracefully with no lingering nfsd
entry in /proc/filesystems.  This change was introduced by the commit
bd5ae9288d64 ("nfsd: register pernet ops last, unregister first"),
the original error handling logic was correct.

Fixes: bd5ae9288d64 ("nfsd: register pernet ops last, unregister first")
Cc: stable@vger.kernel.org
Signed-off-by: Patrick Ho <Patrick.Ho@netapp.com>
Acked-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1549,7 +1549,7 @@ static int __init init_nfsd(void)
 		goto out_free_all;
 	return 0;
 out_free_all:
-	unregister_pernet_subsys(&nfsd_net_ops);
+	unregister_filesystem(&nfsd_fs_type);
 out_free_exports:
 	remove_proc_entry("fs/nfs/exports", NULL);
 	remove_proc_entry("fs/nfs", NULL);


