Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C4BD80AA
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 22:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732768AbfJOUIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 16:08:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:55088 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbfJOUIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Oct 2019 16:08:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 13:08:37 -0700
X-IronPort-AV: E=Sophos;i="5.67,300,1566889200"; 
   d="scan'208";a="220545203"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.16])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Oct 2019 13:08:36 -0700
Subject: [PATCH] libata/ahci: Fix PCS quirk application
From:   Dan Williams <dan.j.williams@intel.com>
To:     axboe@kernel.dk
Cc:     Andreas Friedrich <afrie@gmx.net>,
        Stephen Douthit <stephend@silicom-usa.com>,
        stable@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 15 Oct 2019 12:54:17 -0700
Message-ID: <157116925749.1211205.12806062056189943042.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-2-gc94f
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/ata/ahci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index dd92faf197d5..05c2b32dcc4d 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1600,7 +1600,9 @@ static void ahci_intel_pcs_quirk(struct pci_dev *pdev, struct ahci_host_priv *hp
 	 */
 	if (!id || id->vendor != PCI_VENDOR_ID_INTEL)
 		return;
-	if (((enum board_ids) id->driver_data) < board_ahci_pcs7)
+
+	/* Skip applying the quirk on Denverton and beyond */
+	if (((enum board_ids) id->driver_data) >= board_ahci_pcs7)
 		return;
 
 	/*

