Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D9F3285B0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbhCAQ5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:57:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235045AbhCAQuz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:50:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF4D264FB0;
        Mon,  1 Mar 2021 16:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616391;
        bh=7JlgxSgB8VkId5rpVtu+QFDZIel6gZVvYTlVi77vwyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuWXn6W/NfIdLviKnwjGCIBzsZsmwaS2mu0MyxTsU3sjr//3LD7ViSlH5IOzR4JG4
         u1F4G9z3sAfC05e53ZI4g90jQQ1D3VMGA+Cg2Td3WUV3B7B7b657++un56ZiLeteGt
         ZsDMGLNPrvapS8GoDonacdUuV5wc4IegHGi68ALA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@ger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 4.14 136/176] tpm_tis: Fix check_locality for correct locality acquisition
Date:   Mon,  1 Mar 2021 17:13:29 +0100
Message-Id: <20210301161027.746715200@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit 3d9ae54af1d02a7c0edc55c77d7df2b921e58a87 upstream.

The TPM TIS specification says the TPM signals the acquisition of locality
when the TMP_ACCESS_REQUEST_USE bit goes to one *and* the
TPM_ACCESS_REQUEST_USE bit goes to zero.  Currently we only check the
former not the latter, so check both.  Adding the check on
TPM_ACCESS_REQUEST_USE should fix the case where the locality is
re-requested before the TPM has released it.  In this case the locality may
get released briefly before it is reacquired, which causes all sorts of
problems. However, with the added check, TPM_ACCESS_REQUEST_USE should
remain 1 until the second request for the locality is granted.

Cc: stable@ger.kernel.org
Fixes: 27084efee0c3 ("[PATCH] tpm: driver for next generation TPM chips")
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -68,7 +68,8 @@ static bool check_locality(struct tpm_ch
 	if (rc < 0)
 		return false;
 
-	if ((access & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
+	if ((access & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID
+		       | TPM_ACCESS_REQUEST_USE)) ==
 	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) {
 		priv->locality = l;
 		return true;


