Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF55534C64D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbhC2IGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:06:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232249AbhC2IFc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:05:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6476461969;
        Mon, 29 Mar 2021 08:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005132;
        bh=ideE3VkGpIYHkuOvbwSnSvB/LfLCelCcufnWZ58AuO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NvSuo9aQgvEja4KiUm92x6wI8MWBKN6oHHq6OoqzM3h11WcEo08yLgtLTZ9F7SbBA
         N0ZTnRubhCFWtG/+KoX4D4SHaoUzZHZd13Zv6A4Iv35+GOAz8/ZdoftSs4zRfu0kBu
         85F1D9M0hJi4OVIwQR0XY6mLRbi7FT1JIajLOPrI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 07/59] net: tehuti: fix error return code in bdx_probe()
Date:   Mon, 29 Mar 2021 09:57:47 +0200
Message-Id: <20210329075609.137376053@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075608.898173317@linuxfoundation.org>
References: <20210329075608.898173317@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 38c26ff3048af50eee3fcd591921357ee5bfd9ee ]

When bdx_read_mac() fails, no error return code of bdx_probe()
is assigned.
To fix this bug, err is assigned with -EFAULT as error return code.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/tehuti/tehuti.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/tehuti/tehuti.c b/drivers/net/ethernet/tehuti/tehuti.c
index 163d8d16bc24..75620c3365b3 100644
--- a/drivers/net/ethernet/tehuti/tehuti.c
+++ b/drivers/net/ethernet/tehuti/tehuti.c
@@ -2058,6 +2058,7 @@ bdx_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		/*bdx_hw_reset(priv); */
 		if (bdx_read_mac(priv)) {
 			pr_err("load MAC address failed\n");
+			err = -EFAULT;
 			goto err_out_iomap;
 		}
 		SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
2.30.1



