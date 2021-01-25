Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1442304AB0
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbhAZE7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:59:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731094AbhAYSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:50:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4399206FA;
        Mon, 25 Jan 2021 18:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600594;
        bh=ql/kFEkBLHLBDz/G+ZYC3wDISYxrGGwrIfVrsmmQ7DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sYK9yMJAPYu54j3O8j9JorTKlehUY5jjUBz7KNiwNxLizyj1g64LCKXQXblmCpwcL
         zN0deFlZSr2OjNMH7/jzKfeZOZyEeoIghPiY3Momb3XB+Aw6vqRa3jWLkKHGXCWDxw
         eq5MA4fskFRUEuz7VfkjfyPs2HDTqxonPCLXrPoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 075/199] x86/xen: fix nopvspin build error
Date:   Mon, 25 Jan 2021 19:38:17 +0100
Message-Id: <20210125183219.433270205@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit bd9dcef67ffcae2de49e319fba349df76472fd10 ]

Fix build error in x86/xen/ when PARAVIRT_SPINLOCKS is not enabled.

Fixes this build error:

../arch/x86/xen/smp_hvm.c: In function ‘xen_hvm_smp_init’:
../arch/x86/xen/smp_hvm.c:77:3: error: ‘nopvspin’ undeclared (first use in this function)
   nopvspin = true;

Fixes: 3d7746bea925 ("x86/xen: Fix xen_hvm_smp_init() when vector callback not available")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20210115191123.27572-1-rdunlap@infradead.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/smp_hvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/xen/smp_hvm.c b/arch/x86/xen/smp_hvm.c
index 056430a1080bb..6ff3c887e0b99 100644
--- a/arch/x86/xen/smp_hvm.c
+++ b/arch/x86/xen/smp_hvm.c
@@ -74,7 +74,9 @@ void __init xen_hvm_smp_init(void)
 	smp_ops.cpu_die = xen_hvm_cpu_die;
 
 	if (!xen_have_vector_callback) {
+#ifdef CONFIG_PARAVIRT_SPINLOCKS
 		nopvspin = true;
+#endif
 		return;
 	}
 
-- 
2.27.0



