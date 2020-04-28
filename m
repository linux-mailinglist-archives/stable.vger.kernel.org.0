Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D351BCB43
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbgD1ScF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:48006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729767AbgD1ScE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:32:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD55F2076A;
        Tue, 28 Apr 2020 18:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098724;
        bh=I/JYkXwokIC/zsc2l0WbpaKJZM0psZOWtk/Q6kuTBEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LDEmyGQE/aOmQIvaRraNbCIg1XVxKzmHlfzBfpANydowXjDV+v0109LxEBsZ4vcXy
         QTZr3imkM6BiKHAgel08U9brhtDVpYp6K09bflm9OpQSdjSlRbKz0TEajEzrzZLcH8
         n+ikT1afzADcIXX40MgD/uoP+TuV7d+dMgC9Z5wE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 046/131] kvm: fix compilation on s390
Date:   Tue, 28 Apr 2020 20:24:18 +0200
Message-Id: <20200428182230.811099100@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit d30b214d1d0addb7b2c9c78178d1501cd39a01fb upstream.

s390 does not have memremap, even though in this particular case it
would be useful.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4a5ea263edf62..f99b99b77a486 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1722,8 +1722,10 @@ static int __kvm_map_gfn(struct kvm_memory_slot *slot, gfn_t gfn,
 	if (pfn_valid(pfn)) {
 		page = pfn_to_page(pfn);
 		hva = kmap(page);
+#ifdef CONFIG_HAS_IOMEM
 	} else {
 		hva = memremap(pfn_to_hpa(pfn), PAGE_SIZE, MEMREMAP_WB);
+#endif
 	}
 
 	if (!hva)
-- 
2.20.1



