Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FF0499468
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389523AbiAXUlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:41:35 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33224 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353760AbiAXUhy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:37:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7457E61545;
        Mon, 24 Jan 2022 20:37:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB18C340E7;
        Mon, 24 Jan 2022 20:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056672;
        bh=IWsJn1qUltswEzZQyGwVZ4QpIXfIN5nldvNPVenoV+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxX6YFowwv+cooyWsmh8KgcW8tPXgfJJySHwzqOAGFfWvs1VW4G4WAyc2YyjDGOlC
         SKbOFaSbMVSgQKOtkGLOET2ugHnnZVBQw1LSvh4vusfqaH5h69fK8Ao1e7PluorQHC
         ydxpef3Tg7663uUINfYTTMz2dccDKiYhRsfbcwKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Allen <john.allen@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 562/846] crypto: ccp - Move SEV_INIT retry for corrupted data
Date:   Mon, 24 Jan 2022 19:41:19 +0100
Message-Id: <20220124184120.416260637@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Gonda <pgonda@google.com>

[ Upstream commit e423b9d75e779d921e6adf5ac3d0b59400d6ba7e ]

Move the data corrupted retry of SEV_INIT into the
__sev_platform_init_locked() function. This is for upcoming INIT_EX
support as well as helping direct callers of
__sev_platform_init_locked() which currently do not support the
retry.

Signed-off-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Rientjes <rientjes@google.com>
Cc: John Allen <john.allen@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2ecb0e1f65d8d..e2806ca3300a8 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -241,7 +241,7 @@ static int __sev_platform_init_locked(int *error)
 	struct psp_device *psp = psp_master;
 	struct sev_data_init data;
 	struct sev_device *sev;
-	int rc = 0;
+	int psp_ret, rc = 0;
 
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
@@ -266,7 +266,21 @@ static int __sev_platform_init_locked(int *error)
 		data.tmr_len = SEV_ES_TMR_SIZE;
 	}
 
-	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, error);
+	rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, &psp_ret);
+	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
+		/*
+		 * Initialization command returned an integrity check failure
+		 * status code, meaning that firmware load and validation of SEV
+		 * related persistent data has failed. Retrying the
+		 * initialization function should succeed by replacing the state
+		 * with a reset state.
+		 */
+		dev_dbg(sev->dev, "SEV: retrying INIT command");
+		rc = __sev_do_cmd_locked(SEV_CMD_INIT, &data, &psp_ret);
+	}
+	if (error)
+		*error = psp_ret;
+
 	if (rc)
 		return rc;
 
@@ -1091,18 +1105,6 @@ void sev_pci_init(void)
 
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
-	if (rc && (error == SEV_RET_SECURE_DATA_INVALID)) {
-		/*
-		 * INIT command returned an integrity check failure
-		 * status code, meaning that firmware load and
-		 * validation of SEV related persistent data has
-		 * failed and persistent state has been erased.
-		 * Retrying INIT command here should succeed.
-		 */
-		dev_dbg(sev->dev, "SEV: retrying INIT command");
-		rc = sev_platform_init(&error);
-	}
-
 	if (rc) {
 		dev_err(sev->dev, "SEV: failed to INIT error %#x\n", error);
 		return;
-- 
2.34.1



