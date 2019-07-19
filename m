Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE626DED9
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730101AbfGSEEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:04:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731098AbfGSEEc (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:04:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91B8E218BB;
        Fri, 19 Jul 2019 04:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509071;
        bh=Wt/gn8m83bZpyLcVa1ftJFsQb6lYMfvE8ePzwf81kV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uH5Erg4J7RjhUrakMzf7Y6U2i5m2BG3GI2mZZwuSP7PH1FOTiGJQ5ii273C0zv6fH
         uFePtrJMEE6Piab1ZFzUWEue7Ccf2Z7ylFfWALRDAweaGWyHDuZhiNKmzNwU3LlhRs
         9hvViaTYr9ODXCDv8Ry11XDTIyMlOdORqSFkek+g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugene Korenevsky <ekorenevsky@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 053/141] kvm: vmx: fix limit checking in get_vmx_mem_address()
Date:   Fri, 19 Jul 2019 00:01:18 -0400
Message-Id: <20190719040246.15945-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugene Korenevsky <ekorenevsky@gmail.com>

[ Upstream commit c1a9acbc5295e278d788e9f7510f543bc9864fa2 ]

Intel SDM vol. 3, 5.3:
The processor causes a
general-protection exception (or, if the segment is SS, a stack-fault
exception) any time an attempt is made to access the following addresses
in a segment:
- A byte at an offset greater than the effective limit
- A word at an offset greater than the (effective-limit â€“ 1)
- A doubleword at an offset greater than the (effective-limit â€“ 3)
- A quadword at an offset greater than the (effective-limit â€“ 7)

Therefore, the generic limit checking error condition must be

exn = (off > limit + 1 - access_len) = (off + access_len - 1 > limit)

but not

exn = (off + access_len > limit)

as for now.

Also avoid integer overflow of `off` at 32-bit KVM by casting it to u64.

Note: access length is currently sizeof(u64) which is incorrect. This
will be fixed in the subsequent patch.

Signed-off-by: Eugene Korenevsky <ekorenevsky@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/nested.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4ca834d22169..897ae4b62980 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4143,7 +4143,7 @@ int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 		 */
 		if (!(s.base == 0 && s.limit == 0xffffffff &&
 		     ((s.type & 8) || !(s.type & 4))))
-			exn = exn || (off + sizeof(u64) > s.limit);
+			exn = exn || ((u64)off + sizeof(u64) - 1 > s.limit);
 	}
 	if (exn) {
 		kvm_queue_exception_e(vcpu,
-- 
2.20.1

