Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F03DE68EA
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730245AbfJ0VNV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:13:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730242AbfJ0VNU (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:13:20 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CC5C21726;
        Sun, 27 Oct 2019 21:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210800;
        bh=XcLVq4dXUD65aMWEle5DTCRCdPNJPqSExLNXHs+Kq00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvVMzKJM9WlUrF1pwll8B71PvBXOMFsapiV86JSSQ+W6OaWm2/VGz1Ku+8AOvoWtu
         zZ3ps1GU2Ltvea6pGhafuzCTNhTgRVYWtfP2g2n04Vc/qE34keIj3pO5Dq5zsoR8oi
         zmH3kyNUkl4Q0PZ9bFRh/+sMxCzL9ewSMJL+ywlU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Friedrich <afrie@gmx.net>,
        Stephen Douthit <stephend@silicom-usa.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 21/93] libata/ahci: Fix PCS quirk application
Date:   Sun, 27 Oct 2019 22:00:33 +0100
Message-Id: <20191027203255.740297738@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 09d6ac8dc51a033ae0043c1fe40b4d02563c2496 ]

Commit c312ef176399 "libata/ahci: Drop PCS quirk for Denverton and
beyond" got the polarity wrong on the check for which board-ids should
have the quirk applied. The board type board_ahci_pcs7 is defined at the
end of the list such that "pcs7" boards can be special cased in the
future if they need the quirk. All prior Intel board ids "<
board_ahci_pcs7" should proceed with applying the quirk.

Reported-by: Andreas Friedrich <afrie@gmx.net>
Reported-by: Stephen Douthit <stephend@silicom-usa.com>
Fixes: c312ef176399 ("libata/ahci: Drop PCS quirk for Denverton and beyond")
Cc: <stable@vger.kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 5d110b1362e74..fa1c5a4429579 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1633,7 +1633,9 @@ static void ahci_intel_pcs_quirk(struct pci_dev *pdev, struct ahci_host_priv *hp
 	 */
 	if (!id || id->vendor != PCI_VENDOR_ID_INTEL)
 		return;
-	if (((enum board_ids) id->driver_data) < board_ahci_pcs7)
+
+	/* Skip applying the quirk on Denverton and beyond */
+	if (((enum board_ids) id->driver_data) >= board_ahci_pcs7)
 		return;
 
 	/*
-- 
2.20.1



