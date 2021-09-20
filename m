Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4EFA412120
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356890AbhITSCI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:02:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:57648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1356431AbhITR7z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:59:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 32EF663222;
        Mon, 20 Sep 2021 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158134;
        bh=fkpJmItxZAh1VTg2jjoL2N7YC7WgQwXD95DqcrK7egA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4P9cfP0bFZFL2O2kYJcm+dNLsKtL2nf0QKzNaDe4l+eEpVvFinjoiHuArNd4400M
         70AnzI0rRLFpM868WLY47Wz9U56s51FyiQGkfTMGSZHW1ijqSvwW4idr+0NPBbgc2l
         Y7Vs8TMJkRRhUwPr3K2ec8bXIIylzevAd68AS3RM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 5.4 008/260] xen: fix setting of max_pfn in shared_info
Date:   Mon, 20 Sep 2021 18:40:26 +0200
Message-Id: <20210920163931.414630351@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
@@ -622,8 +622,8 @@ int xen_alloc_p2m_entry(unsigned long pf
 	}
 
 	/* Expanded the p2m? */
-	if (pfn > xen_p2m_last_pfn) {
-		xen_p2m_last_pfn = pfn;
+	if (pfn >= xen_p2m_last_pfn) {
+		xen_p2m_last_pfn = ALIGN(pfn + 1, P2M_PER_PAGE);
 		HYPERVISOR_shared_info->arch.max_pfn = xen_p2m_last_pfn;
 	}
 


