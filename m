Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B238AE6899
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731030AbfJ0Var (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731260AbfJ0VSU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:18:20 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88E6D2070B;
        Sun, 27 Oct 2019 21:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211100;
        bh=nuMeF0mmWX2+7vy9v0d20cokk40O9na7paeUBzG/SfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nv6pS26+n27MpwBnbHASg2YdLpYKc4AkEg6stM73qNdvBl6i1vykgl5io7ZglmWbi
         rqEXTpAKdTwEXunyNK1Qs+ydT5Ne6X7kyF68ev9NORjuiDAbbJW3+jdp1V2alCEVvL
         WVeYTexTl1m8GBZ+83wbAKBePqhm1Pg3HFajTU7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 031/197] xen/efi: Set nonblocking callbacks
Date:   Sun, 27 Oct 2019 21:59:09 +0100
Message-Id: <20191027203353.421401516@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>

[ Upstream commit df359f0d09dc029829b66322707a2f558cb720f7 ]

Other parts of the kernel expect these nonblocking EFI callbacks to
exist and crash when running under Xen. Since the implementations of
xen_efi_set_variable() and xen_efi_query_variable_info() do not take any
locks, use them for the nonblocking callbacks too.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/xen/efi.c | 2 ++
 arch/x86/xen/efi.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/xen/efi.c b/arch/arm/xen/efi.c
index d687a73044bfa..cb2aaf98e243d 100644
--- a/arch/arm/xen/efi.c
+++ b/arch/arm/xen/efi.c
@@ -19,7 +19,9 @@ void __init xen_efi_runtime_setup(void)
 	efi.get_variable             = xen_efi_get_variable;
 	efi.get_next_variable        = xen_efi_get_next_variable;
 	efi.set_variable             = xen_efi_set_variable;
+	efi.set_variable_nonblocking = xen_efi_set_variable;
 	efi.query_variable_info      = xen_efi_query_variable_info;
+	efi.query_variable_info_nonblocking = xen_efi_query_variable_info;
 	efi.update_capsule           = xen_efi_update_capsule;
 	efi.query_capsule_caps       = xen_efi_query_capsule_caps;
 	efi.get_next_high_mono_count = xen_efi_get_next_high_mono_count;
diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index 0d3365cb64de0..7e3eb70f411ab 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -65,7 +65,9 @@ static efi_system_table_t __init *xen_efi_probe(void)
 	efi.get_variable             = xen_efi_get_variable;
 	efi.get_next_variable        = xen_efi_get_next_variable;
 	efi.set_variable             = xen_efi_set_variable;
+	efi.set_variable_nonblocking = xen_efi_set_variable;
 	efi.query_variable_info      = xen_efi_query_variable_info;
+	efi.query_variable_info_nonblocking = xen_efi_query_variable_info;
 	efi.update_capsule           = xen_efi_update_capsule;
 	efi.query_capsule_caps       = xen_efi_query_capsule_caps;
 	efi.get_next_high_mono_count = xen_efi_get_next_high_mono_count;
-- 
2.20.1



