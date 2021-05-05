Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A453374477
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235126AbhEEQ5z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236460AbhEEQyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:54:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E302461979;
        Wed,  5 May 2021 16:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232711;
        bh=0Bk3nstHtjG3V4hoyPoe7jruEuZv2r2/30Mm86m3eM0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOGgNIDu+/Cl5Voe3aq3RwacBvdQuhQFt2N0/l/URbDhmpM93Y4tYqE4dba1AQbRo
         Oz83gLrUtWBgmmh/wqTafCRlh67Vu/GFAhV0TIx1VkLXTXYZ9WGwbrQfaHciH1Kzaf
         AWviaA6fM22S/xUVjAIhPDiSf2gcUJOXtGDWEPISGT+ddOCIkVVtusPDT19JmPHOFl
         5snKKcS8FhvLFGL4/8hQN5F2Wko9cQ+qC4KGzdUVmm0pfftb6v3pWOK13zbymgscV8
         a8oKU4I5w1xCfmOPXD6NWLlhucqVyZVEhCBsr4hbikfw9k6XJPOM3Oua7MIfO/klGk
         cAZlKacg8S46w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 70/85] crypto: ccp: Free SEV device if SEV init fails
Date:   Wed,  5 May 2021 12:36:33 -0400
Message-Id: <20210505163648.3462507-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index 476113e12489..d0eb07afc526 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -986,7 +986,7 @@ int sev_dev_init(struct psp_device *psp)
 	if (!sev->vdata) {
 		ret = -ENODEV;
 		dev_err(dev, "sev: missing driver data\n");
-		goto e_err;
+		goto e_sev;
 	}
 
 	psp_set_sev_irq_handler(psp, sev_irq_handler, sev);
@@ -1001,6 +1001,8 @@ int sev_dev_init(struct psp_device *psp)
 
 e_irq:
 	psp_clear_sev_irq_handler(psp);
+e_sev:
+	devm_kfree(dev, sev);
 e_err:
 	psp->sev_data = NULL;
 
-- 
2.30.2

