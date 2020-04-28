Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF8F1BC866
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729792AbgD1ScO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:48316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbgD1ScO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:32:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AE47218AC;
        Tue, 28 Apr 2020 18:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098733;
        bh=/Pgjjic5C0EKauwdVzgPf6juUebWhP8kZUQgSEb41Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIkm4vYxhvdvwgmwD5A/aP5G0ow0StiL+eMhtIPgF60dUajhNbk4jEsT0iUpTD94l
         zar5WM4+ZKssZe+ovhDjzLUF3VvA9z/wp52/Nrg4++fyZ16T3JoC3wdajAop0ZWJam
         UfYO4w2qaf5ziY4DqY6FqfQfJbKrbzd+uMCjmrLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        KarimAllah Ahmed <karahmed@amazon.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/131] kvm: fix compile on s390 part 2
Date:   Tue, 28 Apr 2020 20:24:19 +0200
Message-Id: <20200428182230.935133221@linuxfoundation.org>
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

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit eb1f2f387db8c0d084581fb26e7faffde700bc8e upstream.

We also need to fence the memunmap part.

Fixes: e45adf665a53 ("KVM: Introduce a new guest mapping API")
Fixes: d30b214d1d0a (kvm: fix compilation on s390)
Cc: Michal Kubecek <mkubecek@suse.cz>
Cc: KarimAllah Ahmed <karahmed@amazon.de>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f99b99b77a486..5b949aa273de5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1756,8 +1756,10 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcpu, struct kvm_host_map *map,
 
 	if (map->page)
 		kunmap(map->page);
+#ifdef CONFIG_HAS_IOMEM
 	else
 		memunmap(map->hva);
+#endif
 
 	if (dirty) {
 		kvm_vcpu_mark_page_dirty(vcpu, map->gfn);
-- 
2.20.1



