Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBCF29C62F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1825805AbgJ0SOJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756485AbgJ0ONg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:13:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5DA7206F7;
        Tue, 27 Oct 2020 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808016;
        bh=wM0Wf3yPdy3kVc/aMeDh+4zxtEy0QFesEioMEaiYheM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7yWkXSPf/w0O5G8E8nYaSs0WmyfMz8bSaxNxXFLZ0HZyD5oHbzhZ64/7HnZxithR
         20hlBqIkneHq3sLKzIc1JBRbfRvG9+7G4mlmsxpVFDoH2kbeQmDiCnCiIsKUzCg1Za
         PqAdtQpkyqci7W3F37gqATucYyaKr6H4HYN3RzsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 125/191] KVM: x86: emulating RDPID failure shall return #UD rather than #GP
Date:   Tue, 27 Oct 2020 14:49:40 +0100
Message-Id: <20201027134915.707611758@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Hoo <robert.hu@linux.intel.com>

[ Upstream commit a9e2e0ae686094571378c72d8146b5a1a92d0652 ]

Per Intel's SDM, RDPID takes a #UD if it is unsupported, which is more or
less what KVM is emulating when MSR_TSC_AUX is not available.  In fact,
there are no scenarios in which RDPID is supposed to #GP.

Fixes: fb6d4d340e ("KVM: x86: emulate RDPID")
Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Message-Id: <1598581422-76264-1-git-send-email-robert.hu@linux.intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/emulate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4cc8a4a6f1d00..46559812da24e 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3544,7 +3544,7 @@ static int em_rdpid(struct x86_emulate_ctxt *ctxt)
 	u64 tsc_aux = 0;
 
 	if (ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux))
-		return emulate_gp(ctxt, 0);
+		return emulate_ud(ctxt);
 	ctxt->dst.val = tsc_aux;
 	return X86EMUL_CONTINUE;
 }
-- 
2.25.1



