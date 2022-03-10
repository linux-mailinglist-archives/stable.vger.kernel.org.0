Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612A14D4A59
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244011AbiCJOcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343907AbiCJOb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4350C24A6;
        Thu, 10 Mar 2022 06:27:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61FF161B63;
        Thu, 10 Mar 2022 14:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA7CC340E8;
        Thu, 10 Mar 2022 14:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922476;
        bh=Rf8d3UZKqR31JRCPZ7eaY38GzuetOV+dpywHxUuB33c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TtUyMhMUgkWHKwZbyG8V56jIN5lNl4ctieXU/8sB37e1smnsuH20HoXfnuL0tHD57
         gsxFkG/bT8Oe3leyWOEJEvb6uPb7KI/h3+vcJKIwqSC8VNLg7BAsjskTK2dMD4ybzZ
         VuiRGeJbNa6O1K8TaRw14Y98+wy+Xi8n87g2nSSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Simon Gaiser <simon@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.4 29/33] xen/9p: use alloc/free_pages_exact()
Date:   Thu, 10 Mar 2022 15:19:30 +0100
Message-Id: <20220310140809.597489051@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
References: <20220310140808.741682643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

Commit 5cadd4bb1d7fc9ab201ac14620d1a478357e4ebd upstream.

Instead of __get_free_pages() and free_pages() use alloc_pages_exact()
and free_pages_exact(). This is in preparation of a change of
gnttab_end_foreign_access() which will prohibit use of high-order
pages.

By using the local variable "order" instead of ring->intf->ring_order
in the error path of xen_9pfs_front_alloc_dataring() another bug is
fixed, as the error path can be entered before ring->intf->ring_order
is being set.

By using alloc_pages_exact() the size in bytes is specified for the
allocation, which fixes another bug for the case of
order < (PAGE_SHIFT - XEN_PAGE_SHIFT).

This is part of CVE-2022-23041 / XSA-396.

Reported-by: Simon Gaiser <simon@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/9p/trans_xen.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -301,9 +301,9 @@ static void xen_9pfs_front_free(struct x
 				ref = priv->rings[i].intf->ref[j];
 				gnttab_end_foreign_access(ref, 0, 0);
 			}
-			free_pages((unsigned long)priv->rings[i].data.in,
-				   XEN_9PFS_RING_ORDER -
-				   (PAGE_SHIFT - XEN_PAGE_SHIFT));
+			free_pages_exact(priv->rings[i].data.in,
+				   1UL << (XEN_9PFS_RING_ORDER +
+					   XEN_PAGE_SHIFT));
 		}
 		gnttab_end_foreign_access(priv->rings[i].ref, 0, 0);
 		free_page((unsigned long)priv->rings[i].intf);
@@ -341,8 +341,8 @@ static int xen_9pfs_front_alloc_dataring
 	if (ret < 0)
 		goto out;
 	ring->ref = ret;
-	bytes = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-			XEN_9PFS_RING_ORDER - (PAGE_SHIFT - XEN_PAGE_SHIFT));
+	bytes = alloc_pages_exact(1UL << (XEN_9PFS_RING_ORDER + XEN_PAGE_SHIFT),
+				  GFP_KERNEL | __GFP_ZERO);
 	if (!bytes) {
 		ret = -ENOMEM;
 		goto out;
@@ -373,9 +373,7 @@ out:
 	if (bytes) {
 		for (i--; i >= 0; i--)
 			gnttab_end_foreign_access(ring->intf->ref[i], 0, 0);
-		free_pages((unsigned long)bytes,
-			   XEN_9PFS_RING_ORDER -
-			   (PAGE_SHIFT - XEN_PAGE_SHIFT));
+		free_pages_exact(bytes, 1UL << (XEN_9PFS_RING_ORDER + XEN_PAGE_SHIFT));
 	}
 	gnttab_end_foreign_access(ring->ref, 0, 0);
 	free_page((unsigned long)ring->intf);


