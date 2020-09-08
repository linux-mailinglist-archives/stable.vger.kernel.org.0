Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64A772619BF
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732103AbgIHSVE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:21:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731456AbgIHQLL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54F0A24756;
        Tue,  8 Sep 2020 15:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579687;
        bh=Q1MWV3QF384tQ47rClttc12k8j/Mj6/7MqE4HXzRMng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAF0fx/gI/8o6dHxvbWtxw/8ZoiMOLXgZvMQbMIyYD+UDjtlxpJCpska9Pm2c8/j0
         EbfficM4DMfJPctPLhASMmNwXBvavXKA7BKfkmRxPL+2Qgv4Vwfpl89w0oOsOHxBbW
         UPXKPtZqasPTEUhWBw7tcMwAhCkEcqY9cvbUcj8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alistair Popple <alistair@popple.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 181/186] mm/migrate: fixup setting UFFD_WP flag
Date:   Tue,  8 Sep 2020 17:25:23 +0200
Message-Id: <20200908152250.448253850@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alistair Popple <alistair@popple.id.au>

commit ebdf8321eeeb623aed60f7ed16f7445363230118 upstream.

Commit f45ec5ff16a75 ("userfaultfd: wp: support swap and page migration")
introduced support for tracking the uffd wp bit during page migration.
However the non-swap PTE variant was used to set the flag for zone device
private pages which are a type of swap page.

This leads to corruption of the swap offset if the original PTE has the
uffd_wp flag set.

Fixes: f45ec5ff16a75 ("userfaultfd: wp: support swap and page migration")
Signed-off-by: Alistair Popple <alistair@popple.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Peter Xu <peterx@redhat.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Link: https://lkml.kernel.org/r/20200825064232.10023-1-alistair@popple.id.au
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/migrate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -251,7 +251,7 @@ static bool remove_migration_pte(struct
 				entry = make_device_private_entry(new, pte_write(pte));
 				pte = swp_entry_to_pte(entry);
 				if (pte_swp_uffd_wp(*pvmw.pte))
-					pte = pte_mkuffd_wp(pte);
+					pte = pte_swp_mkuffd_wp(pte);
 			}
 		}
 


