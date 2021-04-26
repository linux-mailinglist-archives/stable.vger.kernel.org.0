Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6158B36AEA3
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhDZHpz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:45:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234092AbhDZHor (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:44:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8153613E3;
        Mon, 26 Apr 2021 07:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422882;
        bh=cF9brIkzMn7X6OUeIYmyYlwPCL9kFNXn1fdTYvJB3R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npXnzQ6ne4TEdqjsLQamYruR1wzHibNR+jRtU2DVsDZj3tfWlBKVigDUkRWWu1GZ/
         54f4hcuqcKkaJbGXruql4S/6PBrdacjWKm0Rt/+mKBV7iTBY2xjBSLO7zCYvGzPZr7
         cjpZjJ0kzfOg3UpjreuCIqXYoTi8gslzQD1eTYGk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 08/41] KEYS: trusted: Fix TPM reservation for seal/unseal
Date:   Mon, 26 Apr 2021 09:29:55 +0200
Message-Id: <20210426072819.972833675@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072819.666570770@linuxfoundation.org>
References: <20210426072819.666570770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Bottomley <James.Bottomley@HansenPartnership.com>

[ Upstream commit 9d5171eab462a63e2fbebfccf6026e92be018f20 ]

The original patch 8c657a0590de ("KEYS: trusted: Reserve TPM for seal
and unseal operations") was correct on the mailing list:

https://lore.kernel.org/linux-integrity/20210128235621.127925-4-jarkko@kernel.org/

But somehow got rebased so that the tpm_try_get_ops() in
tpm2_seal_trusted() got lost.  This causes an imbalanced put of the
TPM ops and causes oopses on TIS based hardware.

This fix puts back the lost tpm_try_get_ops()

Fixes: 8c657a0590de ("KEYS: trusted: Reserve TPM for seal and unseal operations")
Reported-by: Mimi Zohar <zohar@linux.ibm.com>
Acked-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/trusted-keys/trusted_tpm2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index e2a0ed5d02f0..c87c4df8703d 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -79,7 +79,7 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	if (i == ARRAY_SIZE(tpm2_hash_map))
 		return -EINVAL;
 
-	rc = tpm_buf_init(&buf, TPM2_ST_SESSIONS, TPM2_CC_CREATE);
+	rc = tpm_try_get_ops(chip);
 	if (rc)
 		return rc;
 
-- 
2.30.2



