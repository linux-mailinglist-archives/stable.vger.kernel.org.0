Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6BE206200
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392168AbgFWUxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:44524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392851AbgFWUqd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:46:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EA9B20781;
        Tue, 23 Jun 2020 20:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945193;
        bh=6JlWlTycEqz+qg1DoLJCsDcfqz3mIMOPAVjwGszD3U8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EseUj59yR5mrq7BXciq6bJIVeCDLlaJTDxq5rG/uarp8+Dzy8sjIXHRvwKHQkyny3
         L11euELUVe8IyuESXG2B7aUfFzZsoCN9nHchIdSaiv0FwviVgVot08AqBfDawVA5Vi
         bMS0/sSFK9Ztoxx2kZzCOElAhwbWOqg1QobGOx6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 076/136] x86/apic: Make TSC deadline timer detection message visible
Date:   Tue, 23 Jun 2020 21:58:52 +0200
Message-Id: <20200623195307.503508968@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

[ Upstream commit de308d1815c9e8fe602a958c5c76142ff6501d75 ]

The commit

  c84cb3735fd5 ("x86/apic: Move TSC deadline timer debug printk")

removed the message which said that the deadline timer was enabled.
It added a pr_debug() message which is issued when deadline timer
validation succeeds.

Well, issued only when CONFIG_DYNAMIC_DEBUG is enabled - otherwise
pr_debug() calls get optimized away if DEBUG is not defined in the
compilation unit.

Therefore, make the above message pr_info() so that it is visible in
dmesg.

Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20200525104218.27018-1-bp@alien8.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 48ab5fdd10442..ee33f09513223 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1915,7 +1915,7 @@ void __init init_apic_mappings(void)
 	unsigned int new_apicid;
 
 	if (apic_validate_deadline_timer())
-		pr_debug("TSC deadline timer available\n");
+		pr_info("TSC deadline timer available\n");
 
 	if (x2apic_mode) {
 		boot_cpu_physical_apicid = read_apic_id();
-- 
2.25.1



