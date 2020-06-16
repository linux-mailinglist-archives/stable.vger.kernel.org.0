Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7BC1FBB67
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgFPPgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:36:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730070AbgFPPgt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:36:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A81D20B1F;
        Tue, 16 Jun 2020 15:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321808;
        bh=eZQl0S2K3ZTzZ0LLyydp0Siqt2ix5XFxW31Fv2OTH6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+RuCHmybubuyMxAGbba8ROwr68xdzaJNjxxCjehT3p1bCQvSCcCUFEn0u8tXTNEa
         oxg9TwHug8aMHlYHXm+uTQfS9a4Nz0k6ffVmNvkyAXefTXzdm7G12m2ztwfb1PgTGH
         bblYlBkkW4TwajxMQJ66LVyMlnvRxZqLfqlNCa68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pierre Morel <pmorel@linux.ibm.com>,
        Petr Tesarik <ptesarik@suse.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/134] s390/pci: Log new handle in clp_disable_fh()
Date:   Tue, 16 Jun 2020 17:33:28 +0200
Message-Id: <20200616153101.907591519@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
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
index 281e0dd4c614..20e093f86329 100644
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



