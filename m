Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D760745C5D4
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352984AbhKXOAz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 09:00:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:48876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355791AbhKXN6z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:58:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22FE7633E2;
        Wed, 24 Nov 2021 13:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759322;
        bh=qckGJ0je8XgnYTdwWQHY4/eXgo2grTbe4MqAnKjdjSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R5J49BgGBCvnTByvwZx+dTY7FOy80vPyVnZZbu6R0XEdnV6cStYAOxQYLfGlDBZ4V
         RV/qnUXCbqy81B2OAzbqPoyycPyprlvVWpPGUnemj6UrJd5MerJPYtDI/lhYARecFT
         ZyHVLZ1J3U2QTakgYbudIaMrnV2VzdH0ZXIhka7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 5.15 203/279] x86/hyperv: Fix NULL deref in set_hv_tscchange_cb() if Hyper-V setup fails
Date:   Wed, 24 Nov 2021 12:58:10 +0100
Message-Id: <20211124115725.757709770@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit daf972118c517b91f74ff1731417feb4270625a4 upstream.

Check for a valid hv_vp_index array prior to derefencing hv_vp_index when
setting Hyper-V's TSC change callback.  If Hyper-V setup failed in
hyperv_init(), the kernel will still report that it's running under
Hyper-V, but will have silently disabled nearly all functionality.

  BUG: kernel NULL pointer dereference, address: 0000000000000010
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] SMP
  CPU: 4 PID: 1 Comm: swapper/0 Not tainted 5.15.0-rc2+ #75
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
  RIP: 0010:set_hv_tscchange_cb+0x15/0xa0
  Code: <8b> 04 82 8b 15 12 17 85 01 48 c1 e0 20 48 0d ee 00 01 00 f6 c6 08
  ...
  Call Trace:
   kvm_arch_init+0x17c/0x280
   kvm_init+0x31/0x330
   vmx_init+0xba/0x13a
   do_one_initcall+0x41/0x1c0
   kernel_init_freeable+0x1f2/0x23b
   kernel_init+0x16/0x120
   ret_from_fork+0x22/0x30

Fixes: 93286261de1b ("x86/hyperv: Reenlightenment notifications support")
Cc: stable@vger.kernel.org
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Link: https://lore.kernel.org/r/20211104182239.1302956-2-seanjc@google.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/hyperv/hv_init.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -147,6 +147,9 @@ void set_hv_tscchange_cb(void (*cb)(void
 		return;
 	}
 
+	if (!hv_vp_index)
+		return;
+
 	hv_reenlightenment_cb = cb;
 
 	/* Make sure callback is registered before we write to MSRs */


