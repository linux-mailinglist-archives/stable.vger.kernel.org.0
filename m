Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6554D4A3C
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 15:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244139AbiCJOc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 09:32:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343902AbiCJOb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 09:31:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A825AC9936;
        Thu, 10 Mar 2022 06:27:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 472ADB82544;
        Thu, 10 Mar 2022 14:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D4AC340E8;
        Thu, 10 Mar 2022 14:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646922473;
        bh=eC4iea9yKTTY+ZmvRYiJf8svQPFbiRA7Fe4eO3z/pvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zVg3cnfN8bbX1CXUYA8IVcw3qpOeWXEUtpGFI6N/N5+fY/xHUcua2HjJWY3VNl+oJ
         d7hI2WEUsGTFMJiEEGSQqjmb0YCNR3TdpFtX5eiI2Jd7t2gq4h4KrhrURhFx20JapB
         tW6tJXMVpFnZw80qTuuCgfjGCtwGMcq5UxGSqLzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.4 28/33] xen: remove gnttab_query_foreign_access()
Date:   Thu, 10 Mar 2022 15:19:29 +0100
Message-Id: <20220310140809.568983762@linuxfoundation.org>
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
 drivers/xen/grant-table.c |   25 -------------------------
 include/xen/grant_table.h |    2 --
 2 files changed, 27 deletions(-)

--- a/drivers/xen/grant-table.c
+++ b/drivers/xen/grant-table.c
@@ -134,13 +134,6 @@ struct gnttab_ops {
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
@@ -285,22 +278,6 @@ int gnttab_grant_foreign_access(domid_t
 }
 EXPORT_SYMBOL_GPL(gnttab_grant_foreign_access);
 
-static int gnttab_query_foreign_access_v1(grant_ref_t ref)
-{
-	return gnttab_shared.v1[ref].flags & (GTF_reading|GTF_writing);
-}
-
-static int gnttab_query_foreign_access_v2(grant_ref_t ref)
-{
-	return grstatus[ref] & (GTF_reading|GTF_writing);
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
@@ -1307,7 +1284,6 @@ static const struct gnttab_ops gnttab_v1
 	.update_entry			= gnttab_update_entry_v1,
 	.end_foreign_access_ref		= gnttab_end_foreign_access_ref_v1,
 	.end_foreign_transfer_ref	= gnttab_end_foreign_transfer_ref_v1,
-	.query_foreign_access		= gnttab_query_foreign_access_v1,
 };
 
 static const struct gnttab_ops gnttab_v2_ops = {
@@ -1319,7 +1295,6 @@ static const struct gnttab_ops gnttab_v2
 	.update_entry			= gnttab_update_entry_v2,
 	.end_foreign_access_ref		= gnttab_end_foreign_access_ref_v2,
 	.end_foreign_transfer_ref	= gnttab_end_foreign_transfer_ref_v2,
-	.query_foreign_access		= gnttab_query_foreign_access_v2,
 };
 
 static bool gnttab_need_v2(void)
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


