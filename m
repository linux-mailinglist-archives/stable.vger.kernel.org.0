Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC38E4D49AA
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243731AbiCJOZD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243558AbiCJOYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:24:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0241F15AF17;
        Thu, 10 Mar 2022 06:21:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31893B8254A;
        Thu, 10 Mar 2022 14:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8996EC340E8;
        Thu, 10 Mar 2022 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922073;
        bh=homSW79ERgDC4wOvioAVB6uYm3zjRaRoNQR6qFezAr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCvN8tt0HgQ6QLqTMLPC0/TaWWpdNWKPvj/1aQlfTOzjaAAnP2+5B8U1A2/pWAUz7
         MvCR6wN8NG5Nz0YppkCG9TVQad83IjxjDCir+dO6F4OH/3pG0UYoFmjYtxBIXk4prt
         eeBVke3nK4g3AYuHKFHr29h3uaMZcEWmSkUqgHYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.14 28/31] xen: remove gnttab_query_foreign_access()
Date:   Thu, 10 Mar 2022 15:18:41 +0100
Message-Id: <20220310140808.360509359@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220310140807.524313448@linuxfoundation.org>
References: <20220310140807.524313448@linuxfoundation.org>
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

Commit 1dbd11ca75fe664d3e54607547771d021f531f59 upstream.

Remove gnttab_query_foreign_access(), as it is unused and unsafe to
use.

All previous use cases assumed a grant would not be in use after
gnttab_query_foreign_access() returned 0. This information is useless
in best case, as it only refers to a situation in the past, which could
have changed already.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/grant-table.c |   19 -------------------
 include/xen/grant_table.h |    2 --
 2 files changed, 21 deletions(-)

--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -114,13 +114,6 @@ struct gnttab_ops {
 	 * return the frame.
 	 */
 	unsigned long (*end_foreign_transfer_ref)(grant_ref_t ref);
-	/*
-	 * Query the status of a grant entry. Ref parameter is reference of
-	 * queried grant entry, return value is the status of queried entry.
-	 * Detailed status(writing/reading) can be gotten from the return value
-	 * by bit operations.
-	 */
-	int (*query_foreign_access)(grant_ref_t ref);
 };
 
 struct unmap_refs_callback_data {
@@ -255,17 +248,6 @@ int gnttab_grant_foreign_access(domid_t
 }
 EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
 
-static int gnttab_query_foreign_access_v1(grant_ref_t ref)
-{
-	return gnttab_shared.v1[ref].flags & (GTF_reading|GTF_writing);
-}
-
-int gnttab_query_foreign_access(grant_ref_t ref)
-{
-	return gnttab_interface->query_foreign_access(ref);
-}
-EXPORT_SYMBOL_GPL(gnttab_query_foreign_access);
-
 static int gnttab_end_foreign_access_ref_v1(grant_ref_t ref, int readonly)
 {
 	u16 flags, nflags;
@@ -1029,7 +1011,6 @@ static const struct gnttab_ops gnttab_v1
 	.update_entry			= gnttab_update_entry_v1,
 	.end_foreign_access_ref		= gnttab_end_foreign_access_ref_v1,
 	.end_foreign_transfer_ref	= gnttab_end_foreign_transfer_ref_v1,
-	.query_foreign_access		= gnttab_query_foreign_access_v1,
 };
 
 static void gnttab_request_version(void)
--- a/include/xen/grant_table.h
+++ b/include/xen/grant_table.h
@@ -118,8 +118,6 @@ int gnttab_grant_foreign_transfer(domid_
 unsigned long gnttab_end_foreign_transfer_ref(grant_ref_t ref);
 unsigned long gnttab_end_foreign_transfer(grant_ref_t ref);
 
-int gnttab_query_foreign_access(grant_ref_t ref);
-
 /*
  * operations on reserved batches of grant references
  */


