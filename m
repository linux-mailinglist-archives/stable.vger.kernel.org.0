Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4675E1FBA77
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731928AbgFPQL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 12:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:34004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731258AbgFPPoH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:44:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E44E2151B;
        Tue, 16 Jun 2020 15:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322246;
        bh=afYkuL4IJ9wYh4b1EA0ALnm7o3MIMxCg80j6YvOoGjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkZ8k2vEj/QcfziJXs8G9yMt8FLyMObgsmGizGlBEE3FX4HMnj1h4tdM5NOxUYGEy
         vq7pDWpYP2w/pUbA9MXO9h32dejwBs37oD9w/rZlrGPR3HoYa94kVCmfgqKXxOPrCu
         MYmUA1gT+50eRagClPQx6S4PBtGw/NgT+sOBdDPg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Morel <pmorel@linux.ibm.com>,
        Petr Tesarik <ptesarik@suse.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 027/163] s390/pci: Log new handle in clp_disable_fh()
Date:   Tue, 16 Jun 2020 17:33:21 +0200
Message-Id: <20200616153108.181441263@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Tesarik <ptesarik@suse.com>

[ Upstream commit e1750a3d9abbea2ece29cac8dc5a6f5bc19c1492 ]

After disabling a function, the original handle is logged instead of
the disabled handle.

Link: https://lkml.kernel.org/r/20200522183922.5253-1-ptesarik@suse.com
Fixes: 17cdec960cf7 ("s390/pci: Recover handle in clp_set_pci_fn()")
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Petr Tesarik <ptesarik@suse.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci_clp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/pci/pci_clp.c b/arch/s390/pci/pci_clp.c
index ea794ae755ae..179bcecefdee 100644
--- a/arch/s390/pci/pci_clp.c
+++ b/arch/s390/pci/pci_clp.c
@@ -309,14 +309,13 @@ int clp_enable_fh(struct zpci_dev *zdev, u8 nr_dma_as)
 
 int clp_disable_fh(struct zpci_dev *zdev)
 {
-	u32 fh = zdev->fh;
 	int rc;
 
 	if (!zdev_enabled(zdev))
 		return 0;
 
 	rc = clp_set_pci_fn(zdev, 0, CLP_SET_DISABLE_PCI_FN);
-	zpci_dbg(3, "dis fid:%x, fh:%x, rc:%d\n", zdev->fid, fh, rc);
+	zpci_dbg(3, "dis fid:%x, fh:%x, rc:%d\n", zdev->fid, zdev->fh, rc);
 	return rc;
 }
 
-- 
2.25.1



