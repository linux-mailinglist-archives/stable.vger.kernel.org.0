Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDEF566B22
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233642AbiGEMEk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiGEMDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:03:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0959517A96;
        Tue,  5 Jul 2022 05:03:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A8E4CE1B86;
        Tue,  5 Jul 2022 12:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D97FC341C7;
        Tue,  5 Jul 2022 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022612;
        bh=k4N6KH1YWbQV3DGzZLvNHzX7b6DSgKb1L14QGC7GHeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZS5K6XoFr9qq1J/PTe5IxQLI+6DG55csFYz48/644JglOzHO0FtzS4OhhJqMXBGk
         SFH/Q9brCR/cD0rWIyzjLu0CbbXa/ZcfRPpVCLDCaeTYM51hEr/20XDHtpbGdjvrWe
         5SD1BibMBZzaqZf/Foac2RbK94tOEyjx+GdEgrB8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.19 31/33] xen/arm: Fix race in RB-tree based P2M accounting
Date:   Tue,  5 Jul 2022 13:58:23 +0200
Message-Id: <20220705115607.625593510@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
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
@@ -61,11 +61,12 @@ out:
 
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
@@ -151,10 +152,11 @@ bool __set_phys_to_machine_multi(unsigne
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


