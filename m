Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E054E6867
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731560AbfJ0VTx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:19:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730943AbfJ0VTw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:19:52 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A28352070B;
        Sun, 27 Oct 2019 21:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211192;
        bh=a35Svl5/lKHXrc2V5aFh4F8Q+GFYEOSVk+PbJ9K6IvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0aG0ghh787D9gG6DQc6xbRFmEupgh3ylxYg7D4UfD8xSJLBzNZXiZc6XA7BBrwkF
         OVP70XC9ssV1kLp2W62ySaTNDYGnwn18C5NYRPIcMlnfGoy/8yth2ipuHAw4QoXfV2
         1LtutJ8EDWqJ3zbh+O5u1VI4HaKlV6hNdaAddbvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Friedrich <afrie@gmx.net>,
        Stephen Douthit <stephend@silicom-usa.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 064/197] libata/ahci: Fix PCS quirk application
Date:   Sun, 27 Oct 2019 21:59:42 +0100
Message-Id: <20191027203355.117224422@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
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
index 3e63294304c72..691852b8bb41f 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1617,7 +1617,9 @@ static void ahci_intel_pcs_quirk(struct pci_dev *pdev, struct ahci_host_priv *hp
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



