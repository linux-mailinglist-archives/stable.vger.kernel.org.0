Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AA1420F08
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbhJDNaX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:30:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237464AbhJDN2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:28:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADBFD61C48;
        Mon,  4 Oct 2021 13:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353169;
        bh=Supx4RRVHRgenGiH964uPjNYEQ08HNmm2bDw3KofKEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HDW+ADFOT/U/D2d1Vsi6iESRjYJc84iiNCCGXZEmcuqVWr17qHNTQ2CpsDgl1nmY4
         WN3YtnNmKfljmyhamiIoWLEIpxwQacGEyQ65ixz6G7s/8oy0vgD2aBHPiufdVVdLQS
         qKZu48VdpgzbQiZFhaoLPTVYVzarHnsfm9vK3jWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 022/172] HID: amd_sfh: Fix potential NULL pointer dereference
Date:   Mon,  4 Oct 2021 14:51:12 +0200
Message-Id: <20211004125045.681932875@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



