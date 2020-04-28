Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB7D1BCB49
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgD1Szt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729234AbgD1Sb5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:31:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C35420B80;
        Tue, 28 Apr 2020 18:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098717;
        bh=soMyHZTRdotEhdGqYAHn3eNEg3IDW8qhDnFBz1nc1Vc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEqk5rfvl4s63TcX2BULfHDR55dhntsj/FG29dbUjOWqSWKjan48SIe2FehPciL4w
         jsNmx+FsGCZOhh8gL8PGHkYGkFft03NiaqantWNq5Vx0Huz/5jtLjN+qQt2G02+OcQ
         e1tpd7La64QjTiu9N9JVK/nu7tYnTtsrHv7FD0aM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/131] kvm: fix compilation on aarch64
Date:   Tue, 28 Apr 2020 20:24:17 +0200
Message-Id: <20200428182230.701874652@linuxfoundation.org>
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

commit c011d23ba046826ccf8c4a4a6c1d01c9ccaa1403 upstream.

Commit e45adf665a53 ("KVM: Introduce a new guest mapping API", 2019-01-31)
introduced a build failure on aarch64 defconfig:

$ make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- O=out defconfig \
                Image.gz
...
../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:
    In function '__kvm_map_gfn':
../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1763:9: error:
    implicit declaration of function 'memremap'; did you mean 'memset_p'?
../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1763:46: error:
    'MEMREMAP_WB' undeclared (first use in this function)
../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:
    In function 'kvm_vcpu_unmap':
../arch/arm64/kvm/../../../virt/kvm/kvm_main.c:1795:3: error:
    implicit declaration of function 'memunmap'; did you mean 'vm_munmap'?

because these functions are declared in <linux/io.h> rather than <asm/io.h>,
and the former was being pulled in already on x86 but not on aarch64.

Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 4.19: adjust context]
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ec1479abb29de..4a5ea263edf62 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -52,9 +52,9 @@
 #include <linux/sort.h>
 #include <linux/bsearch.h>
 #include <linux/kthread.h>
+#include <linux/io.h>
 
 #include <asm/processor.h>
-#include <asm/io.h>
 #include <asm/ioctl.h>
 #include <linux/uaccess.h>
 #include <asm/pgtable.h>
-- 
2.20.1



