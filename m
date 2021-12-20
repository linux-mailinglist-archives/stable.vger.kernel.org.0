Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714D547B038
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239286AbhLTP2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:28:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236871AbhLTP23 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:28:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAFBC09B06F;
        Mon, 20 Dec 2021 06:52:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FBD9611BF;
        Mon, 20 Dec 2021 14:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76862C36AE7;
        Mon, 20 Dec 2021 14:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011930;
        bh=uvDO1gO3GWnwgec+4b41HamvBhDgDRLnqSjArncZ2sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Y8ACPDdRpPYwQop/VpKIghViGMqT7YE33f9vM2nIL37/VtcaC7lK48PVHTBkg9JH
         tpWarg3pia7h77zsO4vbmw5w0HJ64skDUfnCCk6KjMEOXRwvOMIa4g2Q+Bz9dOA1cT
         mpOpN6CRWNqAR4CxID1kXFVWPBkheaUmpAmfcT8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 002/177] KVM: VMX: clear vmx_x86_ops.sync_pir_to_irr if APICv is disabled
Date:   Mon, 20 Dec 2021 15:32:32 +0100
Message-Id: <20211220143040.138972529@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit e90e51d5f01d2baae5dcce280866bbb96816e978 ]

There is nothing to synchronize if APICv is disabled, since neither
other vCPUs nor assigned devices can set PIR.ON.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dacdf2395f01a..4e212f04268bb 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7776,10 +7776,10 @@ static __init int hardware_setup(void)
 		ple_window_shrink = 0;
 	}
 
-	if (!cpu_has_vmx_apicv()) {
+	if (!cpu_has_vmx_apicv())
 		enable_apicv = 0;
+	if (!enable_apicv)
 		vmx_x86_ops.sync_pir_to_irr = NULL;
-	}
 
 	if (cpu_has_vmx_tsc_scaling()) {
 		kvm_has_tsc_control = true;
-- 
2.33.0



