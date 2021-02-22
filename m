Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F923215F1
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:15:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230309AbhBVMO6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:14:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230255AbhBVMOs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:14:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AF2764E83;
        Mon, 22 Feb 2021 12:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996016;
        bh=QLZhJUPlZ5XpW8nAu6Vl/nSqLs2v7n280BWJj4kcnAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4w6B+l41+3ePWESoF6XcwLRHjCUg3WK5pckKGDeOXj257/LuIlB22E7lYZy+ZxYB
         31xNvH4b/ziH90vDPs1y5Z9AS40j9KNRbJ4IjeHTtyX3eIK16z/N3L3jniXHf7VWV7
         zfoQhS0zrzaFFEZw9rRDfIGVm91QrKOeslW3Y1ks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.11 08/12] xen-scsiback: dont "handle" error by BUG()
Date:   Mon, 22 Feb 2021 13:13:00 +0100
Message-Id: <20210222121018.547345140@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.586597942@linuxfoundation.org>
References: <20210222121013.586597942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit 7c77474b2d22176d2bfb592ec74e0f2cb71352c9 upstream.

In particular -ENOMEM may come back here, from set_foreign_p2m_mapping().
Don't make problems worse, the more that handling elsewhere (together
with map's status fields now indicating whether a mapping wasn't even
attempted, and hence has to be considered failed) doesn't require this
odd way of dealing with errors.

This is part of XSA-362.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/xen-scsiback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -386,12 +386,12 @@ static int scsiback_gnttab_data_map_batc
 		return 0;
 
 	err = gnttab_map_refs(map, NULL, pg, cnt);
-	BUG_ON(err);
 	for (i = 0; i < cnt; i++) {
 		if (unlikely(map[i].status != GNTST_okay)) {
 			pr_err("invalid buffer -- could not remap it\n");
 			map[i].handle = SCSIBACK_INVALID_HANDLE;
-			err = -ENOMEM;
+			if (!err)
+				err = -ENOMEM;
 		} else {
 			get_page(pg[i]);
 		}


