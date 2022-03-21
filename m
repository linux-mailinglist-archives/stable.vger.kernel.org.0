Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AABC4E28AF
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348423AbiCUOAJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348509AbiCUN55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:57:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCBF30F66;
        Mon, 21 Mar 2022 06:55:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD9586126A;
        Mon, 21 Mar 2022 13:55:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0168C340E8;
        Mon, 21 Mar 2022 13:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647870932;
        bh=MyxEPHJ/yrzATKXwkG2a916fXqChGg9FQQ7ePpmg8v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkaBK5pnszL4BOJWNdzKeuL3BfXKqtQL6ru85ZgltDCtNmy6K/pCLFXxtNkLGsm5T
         TPfdoUwNEFVZebtOQ2Z7zxbj0XSlUreWrlpBXzdfRefMSTDDdH1FrNIM9Lhjx6Oa/f
         921Tnm6u8kK+iAMHx39Zq9iFWuBkQyNy9qs7Lxfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, liqiong <liqiong@nfschina.com>
Subject: [PATCH 4.19 21/57] mm: fix dereference a null pointer in migrate[_huge]_page_move_mapping()
Date:   Mon, 21 Mar 2022 14:52:02 +0100
Message-Id: <20220321133222.602567121@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: liqiong <liqiong@nfschina.com>

Upstream doesn't use radix tree any more in migrate.c, no need this patch.

The two functions look up a slot and dereference the pointer,
If the pointer is null, the kernel would crash and dump.

The 'numad' service calls 'migrate_pages' periodically. If some slots
being replaced (Cache Eviction), the radix_tree_lookup_slot() returns
a null pointer that causes kernel crash.

"numad":  crash> bt
[exception RIP: migrate_page_move_mapping+337]

Introduce pointer checking to avoid dereference a null pointer.

Cc: <stable@vger.kernel.org> # linux-4.19.y
Signed-off-by: liqiong <liqiong@nfschina.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/migrate.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -472,6 +472,10 @@ int migrate_page_move_mapping(struct add
 
 	pslot = radix_tree_lookup_slot(&mapping->i_pages,
  					page_index(page));
+	if (pslot == NULL) {
+		xa_unlock_irq(&mapping->i_pages);
+		return -EAGAIN;
+	}
 
 	expected_count += hpage_nr_pages(page) + page_has_private(page);
 	if (page_count(page) != expected_count ||
@@ -590,6 +594,10 @@ int migrate_huge_page_move_mapping(struc
 	xa_lock_irq(&mapping->i_pages);
 
 	pslot = radix_tree_lookup_slot(&mapping->i_pages, page_index(page));
+	if (pslot == NULL) {
+		xa_unlock_irq(&mapping->i_pages);
+		return -EAGAIN;
+	}
 
 	expected_count = 2 + page_has_private(page);
 	if (page_count(page) != expected_count ||


