Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D44DAE6688
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728695AbfJ0VMu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:12:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbfJ0VMt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:12:49 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 657C220B7C;
        Sun, 27 Oct 2019 21:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210769;
        bh=IUj/HxYB2rHKVhwAa6+OElvjVYWfgUzquy9H1go8RzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQRXQkrz+pCITnrP9oNpe3eyKXkpi8SYsWatdWBvaP3cudx5UQfcqQie6x29Tb/Fy
         HdZMUpQdPeIVjue0Lw04I1EeSx6q/C2A1L4PXjZpbPTrw1ww323Az/rM8+fs0POAbU
         8IQHZ+CdJKf19xogG7YtmV8zwjnHUwrfB4mK7JHM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/93] xen/efi: Set nonblocking callbacks
Date:   Sun, 27 Oct 2019 22:00:23 +0100
Message-Id: <20191027203254.262432938@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
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
index b4d78959cadf0..bc9a37b3cecd6 100644
--- a/arch/arm/xen/efi.c
+++ b/arch/arm/xen/efi.c
@@ -31,7 +31,9 @@ void __init xen_efi_runtime_setup(void)
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
index 1804b27f9632a..66bcdeeee639a 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -77,7 +77,9 @@ static efi_system_table_t __init *xen_efi_probe(void)
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



