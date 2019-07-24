Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E25C74588
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 07:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391079AbfGYFnn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 01:43:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390866AbfGYFnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 01:43:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9880A21850;
        Thu, 25 Jul 2019 05:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564033421;
        bh=GuyYyxGlZV5qXFdPx3dhWr2waZi16TNzGU6lqBc96LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bAsNjvuTtbW75PcUjmsSyD5RxBIYL4llP8Z53heGdbWX8plCaUBWiTy3ui45vr0oY
         UvmpsW14ecvaTwb1z9r3u6KYz0AbW1yIL3sVpIzzT4vFMq57J/Kj27uL2799VSsS5u
         z3kcq9NpfWNmrflEm5ALswLMXWLa9bAXUgzlNjCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anna Schumaker <Anna.Schumaker@Netapp.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 4.19 201/271] pNFS: Fix a typo in pnfs_update_layout
Date:   Wed, 24 Jul 2019 21:21:10 +0200
Message-Id: <20190724191712.329959976@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
References: <20190724191655.268628197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 400417b05f3ec0531544ca5f94e64d838d8b8849 upstream.

We're supposed to wait for the outstanding layout count to go to zero,
but that got lost somehow.

Fixes: d03360aaf5cca ("pNFS: Ensure we return the error if someone...")
Reported-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/pnfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/pnfs.c
+++ b/fs/nfs/pnfs.c
@@ -1866,7 +1866,7 @@ lookup_again:
 	    atomic_read(&lo->plh_outstanding) != 0) {
 		spin_unlock(&ino->i_lock);
 		lseg = ERR_PTR(wait_var_event_killable(&lo->plh_outstanding,
-					atomic_read(&lo->plh_outstanding)));
+					!atomic_read(&lo->plh_outstanding)));
 		if (IS_ERR(lseg) || !list_empty(&lo->plh_segs))
 			goto out_put_layout_hdr;
 		pnfs_put_layout_hdr(lo);


