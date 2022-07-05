Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C46566B96
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbiGEMJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiGEMGW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:06:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2001118B3B;
        Tue,  5 Jul 2022 05:05:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B01CD61909;
        Tue,  5 Jul 2022 12:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92ACAC341C7;
        Tue,  5 Jul 2022 12:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022751;
        bh=PXnYC5Q5J8r1ipXlW9fyoi7kFwV9c2wah0J2rCfcv6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALCkUBl99RwuHbIM6UZbKiv12+TRpKdZeyJFeOaNUH4eay6e3Nl/CLK0fMnj6BbuN
         sKtsvnEe7x0Y7jMu8fU/jG9CqJ05AbhCBNWwbLf3IaGecwO3mch3z34UNLnGf95gvt
         yrywMVj6+vqKfZY8eRjL7TYUFMUQQaKAzqjieiOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.4 55/58] xen/arm: Fix race in RB-tree based P2M accounting
Date:   Tue,  5 Jul 2022 13:58:31 +0200
Message-Id: <20220705115611.865637452@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>

commit b75cd218274e01d026dc5240e86fdeb44bbed0c8 upstream.

During the PV driver life cycle the mappings are added to
the RB-tree by set_foreign_p2m_mapping(), which is called from
gnttab_map_refs() and are removed by clear_foreign_p2m_mapping()
which is called from gnttab_unmap_refs(). As both functions end
up calling __set_phys_to_machine_multi() which updates the RB-tree,
this function can be called concurrently.

There is already a "p2m_lock" to protect against concurrent accesses,
but the problem is that the first read of "phys_to_mach.rb_node"
in __set_phys_to_machine_multi() is not covered by it, so this might
lead to the incorrect mappings update (removing in our case) in RB-tree.

In my environment the related issue happens rarely and only when
PV net backend is running, the xen_add_phys_to_mach_entry() claims
that it cannot add new pfn <-> mfn mapping to the tree since it is
already exists which results in a failure when mapping foreign pages.

But there might be other bad consequences related to the non-protected
root reads such use-after-free, etc.

While at it, also fix the similar usage in __pfn_to_mfn(), so
initialize "struct rb_node *n" with the "p2m_lock" held in both
functions to avoid possible bad consequences.

This is CVE-2022-33744 / XSA-406.

Signed-off-by: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/xen/p2m.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/arm/xen/p2m.c
+++ b/arch/arm/xen/p2m.c
@@ -62,11 +62,12 @@ out:
 
 unsigned long __pfn_to_mfn(unsigned long pfn)
 {
-	struct rb_node *n = phys_to_mach.rb_node;
+	struct rb_node *n;
 	struct xen_p2m_entry *entry;
 	unsigned long irqflags;
 
 	read_lock_irqsave(&p2m_lock, irqflags);
+	n = phys_to_mach.rb_node;
 	while (n) {
 		entry = rb_entry(n, struct xen_p2m_entry, rbnode_phys);
 		if (entry->pfn <= pfn &&
@@ -153,10 +154,11 @@ bool __set_phys_to_machine_multi(unsigne
 	int rc;
 	unsigned long irqflags;
 	struct xen_p2m_entry *p2m_entry;
-	struct rb_node *n = phys_to_mach.rb_node;
+	struct rb_node *n;
 
 	if (mfn == INVALID_P2M_ENTRY) {
 		write_lock_irqsave(&p2m_lock, irqflags);
+		n = phys_to_mach.rb_node;
 		while (n) {
 			p2m_entry = rb_entry(n, struct xen_p2m_entry, rbnode_phys);
 			if (p2m_entry->pfn <= pfn &&


