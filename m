Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880613741A8
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbhEEQkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:40:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235236AbhEEQik (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:38:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53F6661466;
        Wed,  5 May 2021 16:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232425;
        bh=YIgiDKWIFVKg7jqKcxleD6nHQX99SbwsL/ROMz1BenQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qakmDSveEQPWTAMKBOv+3voGj1NPmMMF6074gwjJM68tMj4dS+x0/eLGqJvrKMZUD
         fua+7frxPhVaBLAelqMpCI1q+rVwzf3QS6J5vaux2VAdZ5UW7YXnPHdHaTEEKhB9Cy
         Yu6InPScJ5MTf0YRJcGCYoolfNPTZXrlilVOvSy6WJAc2dI2sb2ABmjNudt5cx8Ntp
         9W3B/2J/oeHrC+RB91p32k3Di0erGBHzq+CXf0M8izho2ZaXaYGHBcXuXaubnDCT8T
         go8/knG4CUBzilk4nXD71gSVz9IkwJ2+vdNA/CehFPAlawdvAAB81o/4NH3vLwZCFm
         RHoTIIYihkQeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 099/116] crypto: ccp: Free SEV device if SEV init fails
Date:   Wed,  5 May 2021 12:31:07 -0400
Message-Id: <20210505163125.3460440-99-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit b61a9071dc72a3c709192c0c00ab87c2b3de1d94 ]

Free the SEV device if later initialization fails.  The memory isn't
technically leaked as it's tracked in the top-level device's devres
list, but unless the top-level device is removed, the memory won't be
freed and is effectively leaked.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210406224952.4177376-2-seanjc@google.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index cb9b4c4e371e..ba240d33d26e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -987,7 +987,7 @@ int sev_dev_init(struct psp_device *psp)
 	if (!sev->vdata) {
 		ret = -ENODEV;
 		dev_err(dev, "sev: missing driver data\n");
-		goto e_err;
+		goto e_sev;
 	}
 
 	psp_set_sev_irq_handler(psp, sev_irq_handler, sev);
@@ -1002,6 +1002,8 @@ int sev_dev_init(struct psp_device *psp)
 
 e_irq:
 	psp_clear_sev_irq_handler(psp);
+e_sev:
+	devm_kfree(dev, sev);
 e_err:
 	psp->sev_data = NULL;
 
-- 
2.30.2

