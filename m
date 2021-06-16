Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735F23A93E8
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 09:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhFPHcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 03:32:18 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33838 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbhFPHcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 03:32:17 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A261A21A24;
        Wed, 16 Jun 2021 07:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623828610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S1r1xotAufgSrJxoO6eVl3GT9o9kmdrAP0fb2+09k/Y=;
        b=rrtxG4a3oZRTeuM96PmrvNJ9mDw4s3FGu3Lt679kjarEpkWxfo+hWYdS4X+u3TqylaZlJr
        V3FSb3/rS3kXEauOsaW7c5pXjxS4O9eIryIAQc0InNovNDrA6RZm3/l8q7+i88EsnXV6QY
        Gm6m0edAK5fEt0Xzp2IcFUvrAYJKM+w=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 53A0511A98;
        Wed, 16 Jun 2021 07:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1623828610; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S1r1xotAufgSrJxoO6eVl3GT9o9kmdrAP0fb2+09k/Y=;
        b=rrtxG4a3oZRTeuM96PmrvNJ9mDw4s3FGu3Lt679kjarEpkWxfo+hWYdS4X+u3TqylaZlJr
        V3FSb3/rS3kXEauOsaW7c5pXjxS4O9eIryIAQc0InNovNDrA6RZm3/l8q7+i88EsnXV6QY
        Gm6m0edAK5fEt0Xzp2IcFUvrAYJKM+w=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id kOVJE4KoyWBfZAAALh3uQQ
        (envelope-from <jgross@suse.com>); Wed, 16 Jun 2021 07:30:10 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: [PATCH 1/2] xen: fix setting of max_pfn in shared_info
Date:   Wed, 16 Jun 2021 09:30:06 +0200
Message-Id: <20210616073007.5215-2-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210616073007.5215-1-jgross@suse.com>
References: <20210616073007.5215-1-jgross@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Xen PV guests are specifying the highest used PFN via the max_pfn
field in shared_info. This value is used by the Xen tools when saving
or migrating the guest.

Unfortunately this field is misnamed, as in reality it is specifying
the number of pages (including any memory holes) of the guest, so it
is the highest used PFN + 1. Renaming isn't possible, as this is a
public Xen hypervisor interface which needs to be kept stable.

The kernel will set the value correctly initially at boot time, but
when adding more pages (e.g. due to memory hotplug or ballooning) a
real PFN number is stored in max_pfn. This is done when expanding the
p2m array, and the PFN stored there is even possibly wrong, as it
should be the last possible PFN of the just added P2M frame, and not
one which led to the P2M expansion.

Fix that by setting shared_info->max_pfn to the last possible PFN + 1.

Fixes: 98dd166ea3a3c3 ("x86/xen/p2m: hint at the last populated P2M entry")
Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/xen/p2m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index ac06ca32e9ef..5e6e236977c7 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -618,8 +618,8 @@ int xen_alloc_p2m_entry(unsigned long pfn)
 	}
 
 	/* Expanded the p2m? */
-	if (pfn > xen_p2m_last_pfn) {
-		xen_p2m_last_pfn = pfn;
+	if (pfn >= xen_p2m_last_pfn) {
+		xen_p2m_last_pfn = ALIGN(pfn + 1, P2M_PER_PAGE);
 		HYPERVISOR_shared_info->arch.max_pfn = xen_p2m_last_pfn;
 	}
 
-- 
2.26.2

