Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C76C29BCB0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1810996AbgJ0Qgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:36:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801890AbgJ0Po6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:44:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C85D122409;
        Tue, 27 Oct 2020 15:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813491;
        bh=TKmVJoukR4BZOhkxwruw+3wTFzHmXCsTzhI8cRjqa2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EB36+SYKOr5w6zr2WlWQdoDgeOrKZXtdIDJAM2z7IO/D1E+4tZwyk7RuTY1QEDGtn
         ngjdQayXO8+YymqAQR1fwAbQlkHWooxXdB5Z4sknlcHGGOxJCYh+Cqj3vSh2/AcZph
         BEqwaYSkQ1A4YsBFw5DFGMbTHIntabpJQUtSIjrU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Hoo <robert.hu@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 569/757] KVM: x86: emulating RDPID failure shall return #UD rather than #GP
Date:   Tue, 27 Oct 2020 14:53:39 +0100
Message-Id: <20201027135517.201145013@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 2f6510de6b0c0..85111cd0adcd0 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3606,7 +3606,7 @@ static int em_rdpid(struct x86_emulate_ctxt *ctxt)
 	u64 tsc_aux = 0;
 
 	if (ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux))
-		return emulate_gp(ctxt, 0);
+		return emulate_ud(ctxt);
 	ctxt->dst.val = tsc_aux;
 	return X86EMUL_CONTINUE;
 }
-- 
2.25.1



