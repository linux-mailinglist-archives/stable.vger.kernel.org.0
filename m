Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503FB42288A
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbhJENwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235466AbhJENwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:52:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F3EC61989;
        Tue,  5 Oct 2021 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633441851;
        bh=Supx4RRVHRgenGiH964uPjNYEQ08HNmm2bDw3KofKEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ahKxMSxPTU3C5p7gbxVl55Fgu98rbUWPZLINTzT0f2phbcmcXpgOyyRbNV/yLlN90
         Xhs+riYHJOAeKNBvnKyAzhajSHkuNoPA2hSErn+/hWE0do2I5QTqmcCKu3O+P9YAPP
         6lBDm6zDi29iBHO9HC4r4l7o4vmTaikbWLOKL/SGNk6dZgt+TJ02Ifl0NuowcJ28Nl
         q2Z0QBLjkRjC1wr0G+HLcBpv+YcqoZVtHXqPeVpyeIDWpnO9fjEToi3fhw2zpWAKuF
         EWXUUf6Zna9xfwc43Ash8RZDZZa0w/6+024nqLLsRKzIa2dd0NZ7zS2VAk1Av3jEyT
         pWzU+enR7kPug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Evgeny Novikov <novikov@ispras.ru>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        nehal-bakulchandra.shah@amd.com, basavaraj.natikar@amd.com,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 14/40] HID: amd_sfh: Fix potential NULL pointer dereference
Date:   Tue,  5 Oct 2021 09:49:53 -0400
Message-Id: <20211005135020.214291-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211005135020.214291-1-sashal@kernel.org>
References: <20211005135020.214291-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit d46ef750ed58cbeeba2d9a55c99231c30a172764 ]

devm_add_action_or_reset() can suddenly invoke amd_mp2_pci_remove() at
registration that will cause NULL pointer dereference since
corresponding data is not initialized yet. The patch moves
initialization of data before devm_add_action_or_reset().

Found by Linux Driver Verification project (linuxtesting.org).

[jkosina@suse.cz: rebase]
Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_pcie.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
index 8d68796aa905..4069b813c6c3 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_pcie.c
@@ -235,6 +235,10 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 		return rc;
 	}
 
+	rc = amd_sfh_hid_client_init(privdata);
+	if (rc)
+		return rc;
+
 	privdata->cl_data = devm_kzalloc(&pdev->dev, sizeof(struct amdtp_cl_data), GFP_KERNEL);
 	if (!privdata->cl_data)
 		return -ENOMEM;
@@ -245,7 +249,7 @@ static int amd_mp2_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 
 	mp2_select_ops(privdata);
 
-	return amd_sfh_hid_client_init(privdata);
+	return 0;
 }
 
 static const struct pci_device_id amd_mp2_pci_tbl[] = {
-- 
2.33.0

