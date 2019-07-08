Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53296239D
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390389AbfGHPde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:33:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390388AbfGHPdd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:33:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8768F20665;
        Mon,  8 Jul 2019 15:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600013;
        bh=nYm/RderVs60C9q8/W5MAG7vDMW9frDiYsHdNMrgyGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9HWnZcqZ51DRh0VJGhSD7zkvW4+7TIbu0wAZLzTNveb/eVWKR+0Qctq5iI10Fz0E
         21buNWJCICGjtFqYTS0BBVbGjxnLgj2lZC/W8oWIGqvzCWMs6DJkTzGM3fHe4kaG5z
         honcauOxXp9xkwqs/3qjf3tAnFyAfpKZCOJ/evrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.1 65/96] dax: Fix xarray entry association for mixed mappings
Date:   Mon,  8 Jul 2019 17:13:37 +0200
Message-Id: <20190708150529.982103261@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 1571c029a2ff289683ddb0a32253850363bcb8a7 upstream.

When inserting entry into xarray, we store mapping and index in
corresponding struct pages for memory error handling. When it happened
that one process was mapping file at PMD granularity while another
process at PTE granularity, we could wrongly deassociate PMD range and
then reassociate PTE range leaving the rest of struct pages in PMD range
without mapping information which could later cause missed notifications
about memory errors. Fix the problem by calling the association /
deassociation code if and only if we are really going to update the
xarray (deassociating and associating zero or empty entries is just
no-op so there's no reason to complicate the code with trying to avoid
the calls for these cases).

Cc: <stable@vger.kernel.org>
Fixes: d2c997c0f145 ("fs, dax: use page->mapping to warn if truncate...")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dax.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/dax.c
+++ b/fs/dax.c
@@ -728,12 +728,11 @@ static void *dax_insert_entry(struct xa_
 
 	xas_reset(xas);
 	xas_lock_irq(xas);
-	if (dax_entry_size(entry) != dax_entry_size(new_entry)) {
+	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+		void *old;
+
 		dax_disassociate_entry(entry, mapping, false);
 		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address);
-	}
-
-	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
@@ -742,7 +741,7 @@ static void *dax_insert_entry(struct xa_
 		 * existing entry is a PMD, we will just leave the PMD in the
 		 * tree and dirty it if necessary.
 		 */
-		void *old = dax_lock_entry(xas, new_entry);
+		old = dax_lock_entry(xas, new_entry);
 		WARN_ON_ONCE(old != xa_mk_value(xa_to_value(entry) |
 					DAX_LOCKED));
 		entry = new_entry;


