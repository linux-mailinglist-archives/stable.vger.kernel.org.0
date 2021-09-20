Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA69C411DF3
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347291AbhITR0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:26:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345846AbhITRXZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:23:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F73F61A7A;
        Mon, 20 Sep 2021 17:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157300;
        bh=w19I8oZ9rhYp53yKQs341qULcXAwjcFJktO1aC5SfCE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+GSfVBA0yjupxKCMpNY5heHTXZ3B7YPWI5pmZy2L3ClGdSAjHmdYIAZorsg4l/ed
         +WE72lZUsSh8qkKSA+E9mhq5OAL9diRzRpIAmOjoYw1gbyD2tQmB510AlXMPUNsbf/
         l7ckb2xQTrbg1pnakOPcacYSbAsVAMR+88FTwCp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.14 103/217] xen: fix setting of max_pfn in shared_info
Date:   Mon, 20 Sep 2021 18:42:04 +0200
Message-Id: <20210920163928.129083534@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 4b511d5bfa74b1926daefd1694205c7f1bcf677f upstream.

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
Link: https://lore.kernel.org/r/20210730092622.9973-2-jgross@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/xen/p2m.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -613,8 +613,8 @@ int xen_alloc_p2m_entry(unsigned long pf
 	}
 
 	/* Expanded the p2m? */
-	if (pfn > xen_p2m_last_pfn) {
-		xen_p2m_last_pfn = pfn;
+	if (pfn >= xen_p2m_last_pfn) {
+		xen_p2m_last_pfn = ALIGN(pfn + 1, P2M_PER_PAGE);
 		HYPERVISOR_shared_info->arch.max_pfn = xen_p2m_last_pfn;
 	}
 


