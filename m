Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84532E41E5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438139AbgL1OGl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:06:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:40542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438131AbgL1OGa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:06:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6EF42063A;
        Mon, 28 Dec 2020 14:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164375;
        bh=MzZ7h9ctZyv1mzlxSsyqT9WMgDm7u9Guw8r+0LU7aJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VqLtjMIFytk5n2ryM9J1hhaidMrj7zs9c8xmO01cp9bulRrBSXMQlyFe4qfvqykT3
         XxQ5Cbm/RmdaNN7TFCzYdDPKf4QRyx0Dd4NzIli+PUZn0LfABO8nE1SRHUyPnwzMQT
         dtGOvTkSOksEcwrFl+7JVehNnd40udzOlOIkZEz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tosk Robot <tencent_os_robot@tencent.com>,
        Kaixu Xia <kaixuxia@tencent.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 159/717] powerpc/powernv/sriov: fix unsigned int win compared to less than zero
Date:   Mon, 28 Dec 2020 13:42:37 +0100
Message-Id: <20201228125028.574300392@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kaixu Xia <kaixuxia@tencent.com>

[ Upstream commit 027717a45ca251a7ba67a63db359994836962cd2 ]

Fix coccicheck warning:

  arch/powerpc/platforms/powernv/pci-sriov.c:443:7-10:
  WARNING: Unsigned expression compared with zero: win < 0

  arch/powerpc/platforms/powernv/pci-sriov.c:462:7-10:
  WARNING: Unsigned expression compared with zero: win < 0

Fixes: 39efc03e3ee8 ("powerpc/powernv/sriov: Move M64 BAR allocation into a helper")
Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/1605007170-22171-1-git-send-email-kaixuxia@tencent.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/pci-sriov.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/pci-sriov.c b/arch/powerpc/platforms/powernv/pci-sriov.c
index c4434f20f42fa..28aac933a4391 100644
--- a/arch/powerpc/platforms/powernv/pci-sriov.c
+++ b/arch/powerpc/platforms/powernv/pci-sriov.c
@@ -422,7 +422,7 @@ static int pnv_pci_vf_assign_m64(struct pci_dev *pdev, u16 num_vfs)
 {
 	struct pnv_iov_data   *iov;
 	struct pnv_phb        *phb;
-	unsigned int           win;
+	int                    win;
 	struct resource       *res;
 	int                    i, j;
 	int64_t                rc;
-- 
2.27.0



