Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A1BE3AEEAF
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbhFUQbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:49176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhFUQ3d (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:29:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4CBA613F8;
        Mon, 21 Jun 2021 16:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292658;
        bh=HgAeyTIKN6/HSdq0bHXaUPfbBBKqat1+BFLZu8Q0FPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fCNAj60xt8ric2hZkP2Xv2LtyWz06uQ00e86Geo9oKxHWeMJsS0axnAroSkTibe5g
         sZ5nEm+Ljk8Iuq6veDowq5z2gL8tzk5o4nJVNyQeIWHbPzSrwlEO2NpQr33l/9+hVg
         gqLxx/XjqdlMU/sOaQGLiDzTFxoi2NDbkzZnAswo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/146] qlcnic: Fix an error handling path in qlcnic_probe()
Date:   Mon, 21 Jun 2021 18:14:39 +0200
Message-Id: <20210621154912.974483181@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit cb3376604a676e0302258b01893911bdd7aa5278 ]

If an error occurs after a 'pci_enable_pcie_error_reporting()' call, it
must be undone by a corresponding 'pci_disable_pcie_error_reporting()'
call, as already done in the remove function.

Fixes: 451724c821c1 ("qlcnic: aer support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index c2faf96fcade..27c07b2412f4 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2692,6 +2692,7 @@ err_out_free_hw_res:
 	kfree(ahw);
 
 err_out_free_res:
+	pci_disable_pcie_error_reporting(pdev);
 	pci_release_regions(pdev);
 
 err_out_disable_pdev:
-- 
2.30.2



