Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C1A321614
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhBVMRG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:17:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230371AbhBVMPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:15:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 912FE64EF2;
        Mon, 22 Feb 2021 12:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613996044;
        bh=LqBI0T4uKzthKBRdmuCd499fYfUi0a/WI1AfKlgDRIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRRzFePOLw/XhXpiVBWFOiFPhpvAvuLYZSq94F7FjeanNsSwALnBBNAEYLmcHWX09
         Y2p77Cn0296Xr95f8IJemwcIg2Sh42g4VGtdw8t0NRgFcBqrcoMDwLcDXo25ujQt/x
         UsZrz23bw9oC+YNwZDMweVabvP2/+XQaWX6/QwzQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 16/29] Xen/x86: dont bail early from clear_foreign_p2m_mapping()
Date:   Mon, 22 Feb 2021 13:13:10 +0100
Message-Id: <20210222121022.357852140@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121019.444399883@linuxfoundation.org>
References: <20210222121019.444399883@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

commit a35f2ef3b7376bfd0a57f7844bd7454389aae1fc upstream.

Its sibling (set_foreign_p2m_mapping()) as well as the sibling of its
only caller (gnttab_map_refs()) don't clean up after themselves in case
of error. Higher level callers are expected to do so. However, in order
for that to really clean up any partially set up state, the operation
should not terminate upon encountering an entry in unexpected state. It
is particularly relevant to notice here that set_foreign_p2m_mapping()
would skip setting up a p2m entry if its grant mapping failed, but it
would continue to set up further p2m entries as long as their mappings
succeeded.

Arguably down the road set_foreign_p2m_mapping() may want its page state
related WARN_ON() also converted to an error return.

This is part of XSA-361.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/p2m.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -750,17 +750,15 @@ int clear_foreign_p2m_mapping(struct gnt
 		unsigned long mfn = __pfn_to_mfn(page_to_pfn(pages[i]));
 		unsigned long pfn = page_to_pfn(pages[i]);
 
-		if (mfn == INVALID_P2M_ENTRY || !(mfn & FOREIGN_FRAME_BIT)) {
+		if (mfn != INVALID_P2M_ENTRY && (mfn & FOREIGN_FRAME_BIT))
+			set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+		else
 			ret = -EINVAL;
-			goto out;
-		}
-
-		set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
 	}
 	if (kunmap_ops)
 		ret = HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref,
-						kunmap_ops, count);
-out:
+						kunmap_ops, count) ?: ret;
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(clear_foreign_p2m_mapping);


