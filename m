Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99BF3DB5DE
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 11:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238221AbhG3J0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 05:26:31 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37968 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238196AbhG3J0a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 05:26:30 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 87F3E2021E;
        Fri, 30 Jul 2021 09:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1627637185; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lW2pCPIM4lkygbLbwGLWABzG2cZ+/JhuOV4NXj3t6fM=;
        b=ds4Q914sXEHoQze6n+6web45Hx/QT2RBD7lWXXbaqKASz3CCwlhuto+m6zphSRvkdNnbVp
        P5ZTquFXRO2Jtc+H4WB6rmyh/3gFa0AdN3pdg5iL3M+fL27oMsl5rFPuJmCQ+aqoBPdN6p
        CWDFOKRcHk6eV1+KUfFmLeLHKB1XO38=
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id 3CE7313748;
        Fri, 30 Jul 2021 09:26:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id KNeODcHFA2GeIwAAGKfGzw
        (envelope-from <jgross@suse.com>); Fri, 30 Jul 2021 09:26:25 +0000
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH v2 1/2] xen: fix setting of max_pfn in shared_info
Date:   Fri, 30 Jul 2021 11:26:21 +0200
Message-Id: <20210730092622.9973-2-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210730092622.9973-1-jgross@suse.com>
References: <20210730092622.9973-1-jgross@suse.com>
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
Reviewed-by: Jan Beulich <jbeulich@suse.com>
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

