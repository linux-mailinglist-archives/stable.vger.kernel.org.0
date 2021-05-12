Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDBB37C67C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbhELPvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236888AbhELPrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:47:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2452E61C99;
        Wed, 12 May 2021 15:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833033;
        bh=Ou5baM93maEufZ1Up8/JrftESuCW3fNu8L4LME2rSRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJznjfTFkrFqZ1qGelI9octwrpxqXuZULps/Q5suPGOv5DLnITvStV1aAjZbb0odn
         /4pb5ip2HJqkJDgf0J1rc2qX7zImar+Q0d9MtQZrq6zm2e04fF8eUhQCZHz0YyQWN1
         PI9z7CZUZSyu6M3zXNa5exTqHNywGa8XGykrmo28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brijesh Singh <brijesh.singh@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 478/530] crypto: ccp: Detect and reject "invalid" addresses destined for PSP
Date:   Wed, 12 May 2021 16:49:48 +0200
Message-Id: <20210512144835.468166158@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 74c1f1366eb7714b8b211554f6c5cee315ff3fbc ]

Explicitly reject using pointers that are not virt_to_phys() friendly
as the source for SEV commands that are sent to the PSP.  The PSP works
with physical addresses, and __pa()/virt_to_phys() will not return the
correct address in these cases, e.g. for a vmalloc'd pointer.  At best,
the bogus address will cause the command to fail, and at worst lead to
system instability.

While it's unlikely that callers will deliberately use a bad pointer for
SEV buffers, a caller can easily use a vmalloc'd pointer unknowingly when
running with CONFIG_VMAP_STACK=y as it's not obvious that putting the
command buffers on the stack would be bad.  The command buffers are
relative  small and easily fit on the stack, and the APIs to do not
document that the incoming pointer must be a physically contiguous,
__pa() friendly pointer.

Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Fixes: 200664d5237f ("crypto: ccp: Add Secure Encrypted Virtualization (SEV) command support")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210406224952.4177376-3-seanjc@google.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 476113e12489..5b82ba7acc7c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -149,6 +149,9 @@ static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 
 	sev = psp->sev_data;
 
+	if (data && WARN_ON_ONCE(!virt_addr_valid(data)))
+		return -EINVAL;
+
 	/* Get the physical address of the command buffer */
 	phys_lsb = data ? lower_32_bits(__psp_pa(data)) : 0;
 	phys_msb = data ? upper_32_bits(__psp_pa(data)) : 0;
-- 
2.30.2



