Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C544D4BBC
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 16:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240022AbiCJORg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:17:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243104AbiCJORT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:17:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D3F156940;
        Thu, 10 Mar 2022 06:13:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E24EB825F3;
        Thu, 10 Mar 2022 14:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41F9C340E8;
        Thu, 10 Mar 2022 14:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646921593;
        bh=MfHU0Kwo0xA5jQW28E3BI2IOIWOZWlLewPFWs+uMccc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=upms8jnFI1n/74chLa+OhSi+qcYpnb7hnGDv6fLa9hJqKuJGXrukXT0Q7SRDBEwZ4
         gTR1Ivtfg5SfNd2njiCXXUV112sOzWOIkoFbG5b0m/NH5YZlKHLZl7CAZzT4cl8iqq
         H6B8vAUYw+yGRtofzxwPVQcVULp+WfpVNKqfYJ4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Simon Gaiser <simon@invisiblethingslab.com>,
        Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.16 50/53] xen/pvcalls: use alloc/free_pages_exact()
Date:   Thu, 10 Mar 2022 15:09:55 +0100
Message-Id: <20220310140813.271374697@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140811.832630727@linuxfoundation.org>
References: <20220310140811.832630727@linuxfoundation.org>
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

Commit b0576cc9c6b843d99c6982888d59a56209341888 upstream.

Instead of __get_free_pages() and free_pages() use alloc_pages_exact()
and free_pages_exact(). This is in preparation of a change of
gnttab_end_foreign_access() which will prohibit use of high-order
pages.

This is part of CVE-2022-23041 / XSA-396.

Reported-by: Simon Gaiser <simon@invisiblethingslab.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/pvcalls-front.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/xen/pvcalls-front.c
+++ b/drivers/xen/pvcalls-front.c
@@ -337,8 +337,8 @@ static void free_active_ring(struct sock
 	if (!map->active.ring)
 		return;
 
-	free_pages((unsigned long)map->active.data.in,
-			map->active.ring->ring_order);
+	free_pages_exact(map->active.data.in,
+			 PAGE_SIZE << map->active.ring->ring_order);
 	free_page((unsigned long)map->active.ring);
 }
 
@@ -352,8 +352,8 @@ static int alloc_active_ring(struct sock
 		goto out;
 
 	map->active.ring->ring_order = PVCALLS_RING_ORDER;
-	bytes = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
-					PVCALLS_RING_ORDER);
+	bytes = alloc_pages_exact(PAGE_SIZE << PVCALLS_RING_ORDER,
+				  GFP_KERNEL | __GFP_ZERO);
 	if (!bytes)
 		goto out;
 


