Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB46D383353
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238576AbhEQO52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:57:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242131AbhEQOyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:54:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A157619AA;
        Mon, 17 May 2021 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261482;
        bh=40hQnL67yDel9pKz/Y1QEu7i9cfHv98AEBna5R7P3s8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4NqT+RoE3Q91loP832b1B6mc65bMMTHoFb236a3WSqytz97shk99fzEYdAcPrOwh
         WOLrPCrnnYPQcLo89WZ8I40HfKUxS88nqCLeDwA3GocFsQZtCeMmSUInfmsLxsTBe2
         d/WokNVeDt+Exn55IGnES6XRphM12GIjpfeUieAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 096/329] crypto: ccp: Free SEV device if SEV init fails
Date:   Mon, 17 May 2021 16:00:07 +0200
Message-Id: <20210517140305.377136747@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 5b82ba7acc7c..21caed429cc5 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -989,7 +989,7 @@ int sev_dev_init(struct psp_device *psp)
 	if (!sev->vdata) {
 		ret = -ENODEV;
 		dev_err(dev, "sev: missing driver data\n");
-		goto e_err;
+		goto e_sev;
 	}
 
 	psp_set_sev_irq_handler(psp, sev_irq_handler, sev);
@@ -1004,6 +1004,8 @@ int sev_dev_init(struct psp_device *psp)
 
 e_irq:
 	psp_clear_sev_irq_handler(psp);
+e_sev:
+	devm_kfree(dev, sev);
 e_err:
 	psp->sev_data = NULL;
 
-- 
2.30.2



