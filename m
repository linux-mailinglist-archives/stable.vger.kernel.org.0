Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA72411A70
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240264AbhITQtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:49:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230132AbhITQtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:49:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3280C61262;
        Mon, 20 Sep 2021 16:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156469;
        bh=R5RubUIDV5mJf/Ntg1nlkaygmNTmSRGtpF4N1JRkJbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g57UynP5mKg5GZUCeZCWn8PATzX7r/35v7UsPvD55DPwfSmaEg1FKQvfo4hKcyMjo
         uG4W20ulDfNuE0IObrag2I0iokff3EKhVDIrvjcRrXAQob5TFd2r5D3Vr3OCdxctGZ
         o0JBe70tiGQTrzAWIoLm5uqJkDg3cMi6V2Dzgr40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Jan Beulich <jbeulich@suse.com>
Subject: [PATCH 4.4 074/133] xen: fix setting of max_pfn in shared_info
Date:   Mon, 20 Sep 2021 18:42:32 +0200
Message-Id: <20210920163915.067760490@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
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
@@ -623,8 +623,8 @@ int xen_alloc_p2m_entry(unsigned long pf
 	}
 
 	/* Expanded the p2m? */
-	if (pfn > xen_p2m_last_pfn) {
-		xen_p2m_last_pfn = pfn;
+	if (pfn >= xen_p2m_last_pfn) {
+		xen_p2m_last_pfn = ALIGN(pfn + 1, P2M_PER_PAGE);
 		HYPERVISOR_shared_info->arch.max_pfn = xen_p2m_last_pfn;
 	}
 


