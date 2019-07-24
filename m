Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4BB73E89
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389253AbfGXTiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389801AbfGXTiy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:38:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9874C217D4;
        Wed, 24 Jul 2019 19:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997134;
        bh=Z6+ShQJG+hOKLklCzcB3DfvNdkX2JB1PAfPefi98eWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhD7qR69EqBRLx1loewvCSVo2V5ONu979sG25gp2fe5sIop2NTMlxzvVP7+wMn0GC
         UR/KWmnFoXIejILeueXVp31CTPOb9uZEBtQUFsBvtgp6WLUILpFEz/PA/zmWdW/7Kf
         K8exAp6UtGdfRtJv1zG15Z+1XSfxF/xMAEw9HOPY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, KarimAllah Ahmed <karahmed@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.2 331/413] KVM: Properly check if "page" is valid in kvm_vcpu_unmap
Date:   Wed, 24 Jul 2019 21:20:22 +0200
Message-Id: <20190724191759.523869258@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: KarimAllah Ahmed <karahmed@amazon.de>

commit b614c6027896ff9ad6757122e84760d938cab15e upstream.

The field "page" is initialized to KVM_UNMAPPED_PAGE when it is not used
(i.e. when the memory lives outside kernel control). So this check will
always end up using kunmap even for memremap regions.

Fixes: e45adf665a53 ("KVM: Introduce a new guest mapping API")
Cc: stable@vger.kernel.org
Signed-off-by: KarimAllah Ahmed <karahmed@amazon.de>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 virt/kvm/kvm_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1790,7 +1790,7 @@ void kvm_vcpu_unmap(struct kvm_vcpu *vcp
 	if (!map->hva)
 		return;
 
-	if (map->page)
+	if (map->page != KVM_UNMAPPED_PAGE)
 		kunmap(map->page);
 #ifdef CONFIG_HAS_IOMEM
 	else


