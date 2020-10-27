Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B75029B570
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794484AbgJ0PMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794477AbgJ0PMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:12:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0198222EA;
        Tue, 27 Oct 2020 15:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811520;
        bh=J5bb873i0+TuyjZqE8UHm0yuR6yzcriMWdBhPjlHMO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqKqsa2bHT9y720w62FOlU4nJfhphiSxPyFpKCX+7L8NpjYrkWBLiq8AUhF51m+4z
         yJtt1fEMFyBUR5SCV9HNP9kSUwVpEIm+3V14oE7RGSDHAkISdvjmolfwvpF/+oVtoT
         WLIdq2pz3ZI8dLbTWMUmWttW/R3a2wtUrbRBWP0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Dave Jiang <dave.jiang@intel.com>,
        Jon Mason <jdmason@kudzu.us>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 523/633] ntb: intel: Fix memleak in intel_ntb_pci_probe
Date:   Tue, 27 Oct 2020 14:54:26 +0100
Message-Id: <20201027135547.305141043@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit dbb8df5c2d27610a87b0168a8acc89d73fbfde94 ]

The default error branch of a series of pdev_is_gen calls
should free ndev just like what we've done in these calls.

Fixes: 26bfe3d0b227 ("ntb: intel: Add Icelake (gen4) support for Intel NTB")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/intel/ntb_hw_gen1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/intel/ntb_hw_gen1.c b/drivers/ntb/hw/intel/ntb_hw_gen1.c
index 423f9b8fbbcf5..fa561d455f7c8 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen1.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen1.c
@@ -1893,7 +1893,7 @@ static int intel_ntb_pci_probe(struct pci_dev *pdev,
 			goto err_init_dev;
 	} else {
 		rc = -EINVAL;
-		goto err_ndev;
+		goto err_init_pci;
 	}
 
 	ndev_reset_unsafe_flags(ndev);
-- 
2.25.1



