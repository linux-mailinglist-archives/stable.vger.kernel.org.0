Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E53CB38F023
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbhEXQBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:41102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234833AbhEXQA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:00:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9C066146D;
        Mon, 24 May 2021 15:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871168;
        bh=XCt114qiNhLnTdPz6qVXnm6+12wngqJVV6L5zOEzmO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xP5dztCHvk3pIrIsE5nRy5HOROaJ3reNy8dqfqxKKnrL9oEvMRcatfKgxQgFCBZON
         BnLSEsvBf/WKQmyk4tddcq1AwCThqsNmEI1OMecLPFaxokwev4fUbTFGVKeUKGSz/E
         us6nLWHjNY+YNsJ9aX5D+oTRwV813OMa04ikuU1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?q?Martin=20=C3=85gren?= <martin.agren@gmail.com>
Subject: [PATCH 5.12 060/127] uio/uio_pci_generic: fix return value changed in refactoring
Date:   Mon, 24 May 2021 17:26:17 +0200
Message-Id: <20210524152336.865935428@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Ågren <martin.agren@gmail.com>

commit 156ed0215ef365604f2382d5164c36d3a1cfd98f upstream.

Commit ef84928cff58 ("uio/uio_pci_generic: use device-managed function
equivalents") was able to simplify various error paths thanks to no
longer having to clean up on the way out. Some error paths were dropped,
others were simplified. In one of those simplifications, the return
value was accidentally changed from -ENODEV to -ENOMEM. Restore the old
return value.

Fixes: ef84928cff58 ("uio/uio_pci_generic: use device-managed function equivalents")
Cc: stable <stable@vger.kernel.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Martin Ågren <martin.agren@gmail.com>
Link: https://lore.kernel.org/r/20210422192240.1136373-1-martin.agren@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_pci_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/uio/uio_pci_generic.c
+++ b/drivers/uio/uio_pci_generic.c
@@ -82,7 +82,7 @@ static int probe(struct pci_dev *pdev,
 	}
 
 	if (pdev->irq && !pci_intx_mask_supported(pdev))
-		return -ENOMEM;
+		return -ENODEV;
 
 	gdev = devm_kzalloc(&pdev->dev, sizeof(struct uio_pci_generic_dev), GFP_KERNEL);
 	if (!gdev)


