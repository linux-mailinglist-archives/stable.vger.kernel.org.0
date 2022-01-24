Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3800949A524
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370682AbiAYAF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1851079AbiAXXbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:31:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B4F3C075D05;
        Mon, 24 Jan 2022 13:35:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFAEA614DA;
        Mon, 24 Jan 2022 21:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F398EC340E4;
        Mon, 24 Jan 2022 21:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060112;
        bh=Ss+KyW9+v4+zPtZvCbZxmRTFAjt5mNV30rcy4WIJht8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yWNekzEQUQtqfBF5fITcfnD2mTnVfsxE84QV8hBwtkOu3Eb9Ej9/1DpOpzmw+aksj
         Nbkm6oyD1O4LwgU//ol81hQmwKtqbLk66WgCL/BawK3vTQJjVdg/Ou1qqfNAugcJOx
         JYE08hIMDtx5J+DcfxD8xO5ltwKE8SXr1AeHrqts=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.16 0844/1039] xen/gntdev: fix unmap notification order
Date:   Mon, 24 Jan 2022 19:43:53 +0100
Message-Id: <20220124184153.659861284@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>

commit ce2f46f3531a03781181b7f4bd1ff9f8c5086e7e upstream.

While working with Xen's libxenvchan library I have faced an issue with
unmap notifications sent in wrong order if both UNMAP_NOTIFY_SEND_EVENT
and UNMAP_NOTIFY_CLEAR_BYTE were requested: first we send an event channel
notification and then clear the notification byte which renders in the below
inconsistency (cli_live is the byte which was requested to be cleared on unmap):

[  444.514243] gntdev_put_map UNMAP_NOTIFY_SEND_EVENT map->notify.event 6
libxenvchan_is_open cli_live 1
[  444.515239] __unmap_grant_pages UNMAP_NOTIFY_CLEAR_BYTE at 14

Thus it is not possible to reliably implement the checks like
- wait for the notification (UNMAP_NOTIFY_SEND_EVENT)
- check the variable (UNMAP_NOTIFY_CLEAR_BYTE)
because it is possible that the variable gets checked before it is cleared
by the kernel.

To fix that we need to re-order the notifications, so the variable is first
gets cleared and then the event channel notification is sent.
With this fix I can see the correct order of execution:

[   54.522611] __unmap_grant_pages UNMAP_NOTIFY_CLEAR_BYTE at 14
[   54.537966] gntdev_put_map UNMAP_NOTIFY_SEND_EVENT map->notify.event 6
libxenvchan_is_open cli_live 0

Cc: stable@vger.kernel.org
Signed-off-by: Oleksandr Andrushchenko <oleksandr_andrushchenko@epam.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20211210092817.580718-1-andr2000@gmail.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/gntdev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -250,13 +250,13 @@ void gntdev_put_map(struct gntdev_priv *
 	if (!refcount_dec_and_test(&map->users))
 		return;
 
+	if (map->pages && !use_ptemod)
+		unmap_grant_pages(map, 0, map->count);
+
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT) {
 		notify_remote_via_evtchn(map->notify.event);
 		evtchn_put(map->notify.event);
 	}
-
-	if (map->pages && !use_ptemod)
-		unmap_grant_pages(map, 0, map->count);
 	gntdev_free_map(map);
 }
 


