Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC52461CDC
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 18:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350338AbhK2Rl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 12:41:57 -0500
Received: from mail-oo1-f41.google.com ([209.85.161.41]:43574 "EHLO
        mail-oo1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349418AbhK2Rj5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 12:39:57 -0500
Received: by mail-oo1-f41.google.com with SMTP id w5-20020a4a2745000000b002c2649b8d5fso5886200oow.10;
        Mon, 29 Nov 2021 09:36:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7lJ10f8y/0PIbedlfa3Wr6oemBqVYv8pglfzNp2iNBY=;
        b=4qPiGU8Bio7q5ULvUipGGAhZCVJYylcmhFeS3ANWaX27Uwv1ZXfPQ9vqLOpb1Sk8iL
         1asaUEEigffu9u5Z+cqlsRrPwVUqkCw8lP+YpRk57rYMDnWycLTyihtoQeD1W8ulT4Xf
         3tWtfTRy1G2P4nJ8RwuNZ5W3qePTBAy70HzSqaAml3zIo0khuDgPj5R56B/2lIEiEcFZ
         mSYsg/nO5yuRAqzrJw4CPUlbA8pRzCm/gvH3JYWlgvSH2jndGM+jO/g5GBEumtpNp5L5
         bEGFylosgSAgcoTSuB2iBccgHyZBFj7dOfKtb7e6vreLmuxMP4OJuSKGmNCd4idjdZsy
         zRgQ==
X-Gm-Message-State: AOAM532y2l1g0e+USwn+b32k0lYpbzAmPWLIBD19fC6g1BVym4XtY4iR
        71X6tX30kdhX1SomVJ3W4A==
X-Google-Smtp-Source: ABdhPJxOFsKDz/kUN/bzIWamMUb8LeKME2ffXjmYCDWkLoJQEyvRcbWl9tSYvGwRxtmtffmYZaP3Nw==
X-Received: by 2002:a4a:9406:: with SMTP id h6mr32456017ooi.80.1638207399085;
        Mon, 29 Nov 2021 09:36:39 -0800 (PST)
Received: from xps15.herring.priv (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.googlemail.com with ESMTPSA id n22sm2343037oop.29.2021.11.29.09.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 09:36:38 -0800 (PST)
From:   Rob Herring <robh@kernel.org>
To:     Toan Le <toan@os.amperecomputing.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>
Cc:     =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        stable@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: xgene: Fix IB window setup
Date:   Mon, 29 Nov 2021 11:36:37 -0600
Message-Id: <20211129173637.303201-1-robh@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
broke PCI support on XGene. The cause is the IB resources are now sorted
in address order instead of being in DT dma-ranges order. The result is
which inbound registers are used for each region are swapped. I don't
know the details about this h/w, but it appears that IB region 0
registers can't handle a size greater than 4GB. In any case, limiting
the size for region 0 is enough to get back to the original assignment
of dma-ranges to regions.

Reported-by: Stéphane Graber <stgraber@ubuntu.com>
Fixes: 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
Link: https://lore.kernel.org/all/CA+enf=v9rY_xnZML01oEgKLmvY1NGBUUhnSJaETmXtDtXfaczA@mail.gmail.com/
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/pci/controller/pci-xgene.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pci-xgene.c b/drivers/pci/controller/pci-xgene.c
index 56d0d50338c8..d83dbd977418 100644
--- a/drivers/pci/controller/pci-xgene.c
+++ b/drivers/pci/controller/pci-xgene.c
@@ -465,7 +465,7 @@ static int xgene_pcie_select_ib_reg(u8 *ib_reg_mask, u64 size)
 		return 1;
 	}
 
-	if ((size > SZ_1K) && (size < SZ_1T) && !(*ib_reg_mask & (1 << 0))) {
+	if ((size > SZ_1K) && (size < SZ_4G) && !(*ib_reg_mask & (1 << 0))) {
 		*ib_reg_mask |= (1 << 0);
 		return 0;
 	}
-- 
2.32.0

