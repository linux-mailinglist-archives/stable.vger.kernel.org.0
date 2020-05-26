Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87481E2B99
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:06:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391658AbgEZTGq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:06:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:35080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391615AbgEZTGm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:06:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31AA9208A7;
        Tue, 26 May 2020 19:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520001;
        bh=zLWuKfdOMv5Vm2wkPGbl40+ScNFyWiRzHsIAtytfIco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WS02iwiawGZZUFnB+5dr49ZcGyObWIlY4RE5PAc0QmIxeRHfNuz6jYbhGNLjC9y3g
         XcUDBgrYmVnBoOll067WDF5J09UxdoZrYR69iJcTFGcKKzAKMXTf7d1fNMiBQbK+P4
         qT8JxO0rmi1VObIwEaLj5vKGjtg39b+1i/RunSGw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 5.4 002/111] KVM: SVM: Fix potential memory leak in svm_cpu_init()
Date:   Tue, 26 May 2020 20:52:20 +0200
Message-Id: <20200526183932.677280469@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183932.245016380@linuxfoundation.org>
References: <20200526183932.245016380@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit d80b64ff297e40c2b6f7d7abc1b3eba70d22a068 upstream.

When kmalloc memory for sd->sev_vmcbs failed, we forget to free the page
held by sd->save_area. Also get rid of the var r as '-ENOMEM' is actually
the only possible outcome here.

Reviewed-by: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -998,33 +998,32 @@ static void svm_cpu_uninit(int cpu)
 static int svm_cpu_init(int cpu)
 {
 	struct svm_cpu_data *sd;
-	int r;
 
 	sd = kzalloc(sizeof(struct svm_cpu_data), GFP_KERNEL);
 	if (!sd)
 		return -ENOMEM;
 	sd->cpu = cpu;
-	r = -ENOMEM;
 	sd->save_area = alloc_page(GFP_KERNEL);
 	if (!sd->save_area)
-		goto err_1;
+		goto free_cpu_data;
 
 	if (svm_sev_enabled()) {
-		r = -ENOMEM;
 		sd->sev_vmcbs = kmalloc_array(max_sev_asid + 1,
 					      sizeof(void *),
 					      GFP_KERNEL);
 		if (!sd->sev_vmcbs)
-			goto err_1;
+			goto free_save_area;
 	}
 
 	per_cpu(svm_data, cpu) = sd;
 
 	return 0;
 
-err_1:
+free_save_area:
+	__free_page(sd->save_area);
+free_cpu_data:
 	kfree(sd);
-	return r;
+	return -ENOMEM;
 
 }
 


