Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBDAA235A1
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390918AbfETMgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:55344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391253AbfETMgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:36:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4C6721479;
        Mon, 20 May 2019 12:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355778;
        bh=Wfi5sjJAO0p3rdmcBrx/KKtYN2W7HX4627JgRQ/b/QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dxre2+1sMnrwDGKDtZKwKEbWGf7q4lZXbjIjbCsVZctchphTpohkgnDOoMPLFU2Rn
         7GiC8pZnEWcznat0prIXxtoh0WVatGTpf7fV4k116QuOCDb3wzjhQH1FpnhOy/0i66
         2D4qZyfNha88FfQQZLoEJiGcOtqS1RpFRON+siRE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.1 121/128] xen/pvh: set xen_domain_type to HVM in xen_pvh_init
Date:   Mon, 20 May 2019 14:15:08 +0200
Message-Id: <20190520115256.833930543@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115249.449077487@linuxfoundation.org>
References: <20190520115249.449077487@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Pau Monne <roger.pau@citrix.com>

commit c9f804d64bb93c8dbf957df1d7e9de11380e522d upstream.

Or else xen_domain() returns false despite xen_pvh being set.

Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/enlighten_pvh.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/xen/enlighten_pvh.c
+++ b/arch/x86/xen/enlighten_pvh.c
@@ -27,6 +27,7 @@ void __init xen_pvh_init(void)
 	u64 pfn;
 
 	xen_pvh = 1;
+	xen_domain_type = XEN_HVM_DOMAIN;
 	xen_start_flags = pvh_start_info.flags;
 
 	msr = cpuid_ebx(xen_cpuid_base() + 2);


