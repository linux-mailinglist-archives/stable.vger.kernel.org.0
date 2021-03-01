Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC49D328B7F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240142AbhCASgI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:36:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:41720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240030AbhCAS2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:28:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D125165258;
        Mon,  1 Mar 2021 17:28:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619719;
        bh=UUXgxDay4hebN8voDxmb3sKyYbiChEgdwOuhSR/bO1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/c9Lbz9ylH77INaEi85O303fuqFdsIJoP3XGZpSEm0gZlrTmgLRIJOTHdqiQjPNz
         R6zqOOGmKgC+lp2OfpJbjUiZ3GVmI8ej3t7DBPcZkLviqRB4SIZ9RCGjNEKDHy5EO/
         sRTx1VcMaEHj837Y/+u4/nGPf1j+zLBRYros55Jo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, stable@ger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.10 526/663] tpm_tis: Fix check_locality for correct locality acquisition
Date:   Mon,  1 Mar 2021 17:12:54 +0100
Message-Id: <20210301161207.866768049@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
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
@@ -125,7 +125,8 @@ static bool check_locality(struct tpm_ch
 	if (rc < 0)
 		return false;
 
-	if ((access & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) ==
+	if ((access & (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID
+		       | TPM_ACCESS_REQUEST_USE)) ==
 	    (TPM_ACCESS_ACTIVE_LOCALITY | TPM_ACCESS_VALID)) {
 		priv->locality = l;
 		return true;


