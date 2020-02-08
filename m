Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6269F15662C
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbgBHScX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:32:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34620 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727942AbgBHS3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:48 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrO-0003jN-KC; Sat, 08 Feb 2020 18:29:42 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrL-000CVm-ND; Sat, 08 Feb 2020 18:29:39 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Max Filippov" <jcmvbkbc@gmail.com>
Date:   Sat, 08 Feb 2020 18:21:04 +0000
Message-ID: <lsq.1581185941.578379774@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 125/148] xtensa: fix TLB sanity checker
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 36de10c4788efc6efe6ff9aa10d38cb7eea4c818 upstream.

Virtual and translated addresses retrieved by the xtensa TLB sanity
checker must be consistent, i.e. correspond to the same state of the
checked TLB entry. KASAN shadow memory is mapped dynamically using
auto-refill TLB entries and thus may change TLB state between the
virtual and translated address retrieval, resulting in false TLB
insanity report.
Move read_xtlb_translation close to read_xtlb_virtual to make sure that
read values are consistent.

Fixes: a99e07ee5e88 ("xtensa: check TLB sanity on return to userspace")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/xtensa/mm/tlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/xtensa/mm/tlb.c
+++ b/arch/xtensa/mm/tlb.c
@@ -218,6 +218,8 @@ static int check_tlb_entry(unsigned w, u
 	unsigned tlbidx = w | (e << PAGE_SHIFT);
 	unsigned r0 = dtlb ?
 		read_dtlb_virtual(tlbidx) : read_itlb_virtual(tlbidx);
+	unsigned r1 = dtlb ?
+		read_dtlb_translation(tlbidx) : read_itlb_translation(tlbidx);
 	unsigned vpn = (r0 & PAGE_MASK) | (e << PAGE_SHIFT);
 	unsigned pte = get_pte_for_vaddr(vpn);
 	unsigned mm_asid = (get_rasid_register() >> 8) & ASID_MASK;
@@ -233,8 +235,6 @@ static int check_tlb_entry(unsigned w, u
 	}
 
 	if (tlb_asid == mm_asid) {
-		unsigned r1 = dtlb ? read_dtlb_translation(tlbidx) :
-			read_itlb_translation(tlbidx);
 		if ((pte ^ r1) & PAGE_MASK) {
 			pr_err("%cTLB: way: %u, entry: %u, mapping: %08x->%08x, PTE: %08x\n",
 					dtlb ? 'D' : 'I', w, e, r0, r1, pte);

