Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C8D32161E
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231132AbhBVMRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:17:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230382AbhBVMPy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8A4864E61;
        Mon, 22 Feb 2021 12:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996127;
        bh=iw37dohlXulVCmlbNQCufXtdzZ9Etj83bfl4M1ZwFRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmlOlCcgaEKD4qkgJGw3PMZleno80vsFs94Ws3GSzD467vCvAqhtwCpZr8kJk9zJ0
         YfTDLjFLkHGM66qTBLQt9McjSNBjD8KWJse2Jvb4XzMfFY1d0Yi+fUQ8RNiLD5Xzju
         ilXIpoApm4JCeP2ZmkgnhG8WTVBIuzFJKsIYp0wI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.4 11/13] xen-scsiback: dont "handle" error by BUG()
Date:   Mon, 22 Feb 2021 13:13:28 +0100
Message-Id: <20210222121018.950250821@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.583922436@linuxfoundation.org>
References: <20210222121013.583922436@linuxfoundation.org>
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
@@ -422,12 +422,12 @@ static int scsiback_gnttab_data_map_batc
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


