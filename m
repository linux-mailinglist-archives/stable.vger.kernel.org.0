Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965D7396266
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhEaO4G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:56:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:48408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233425AbhEaOxj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:53:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AE2A6143F;
        Mon, 31 May 2021 13:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469538;
        bh=DjQ2hMj8WxO3WxXz+guJ5eK96NTTpmaG2dey4dg2x6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iBvVMWW0zOo7VcyZf7+wCw+sdTfdsk2C+4Dm/tBVa+nZy7B2l8hXAhDI52V62lJQQ
         FCIdGfn9lnA1pXXT2QZzNfKCc/bkaShNO9SzDmjrCG9ZYKe+PB2D7dUdXmMM8Lj1Jg
         Ej6LA/f25jxpnLoDXIPuI5amsFjtkb0+d/9uVAMA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 235/296] ptp: ocp: Fix a resource leak in an error handling path
Date:   Mon, 31 May 2021 15:14:50 +0200
Message-Id: <20210531130711.701242148@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9c1bb37f8cad5e2ee1933fa1da9a6baa7876a8e4 ]

If an error occurs after a successful 'pci_ioremap_bar()' call, it must be
undone by a corresponding 'pci_iounmap()' call, as already done in the
remove function.

Fixes: a7e1abad13f3 ("ptp: Add clock driver for the OpenCompute TimeCard.")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_ocp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 530e5f90095e..0d1034e3ed0f 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -324,7 +324,7 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (!bp->base) {
 		dev_err(&pdev->dev, "io_remap bar0\n");
 		err = -ENOMEM;
-		goto out;
+		goto out_release_regions;
 	}
 	bp->reg = bp->base + OCP_REGISTER_OFFSET;
 	bp->tod = bp->base + TOD_REGISTER_OFFSET;
@@ -347,6 +347,8 @@ ptp_ocp_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return 0;
 
 out:
+	pci_iounmap(pdev, bp->base);
+out_release_regions:
 	pci_release_regions(pdev);
 out_disable:
 	pci_disable_device(pdev);
-- 
2.30.2



