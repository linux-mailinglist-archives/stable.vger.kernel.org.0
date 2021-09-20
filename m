Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9C841234E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348108AbhITSXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358736AbhITSU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:20:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE73160EE2;
        Mon, 20 Sep 2021 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158630;
        bh=phAjSoCyI3ewBD64UJ15KDAR0prdvYouAlArjNQJPf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U2GOppg6S4MNF+Fy2ALcGhwIi+mC0KxXAaZj4IUy579aeg8hgQI+G9jTf5P0ccioK
         /3ZczYdibDy+UuRJ96jUVJ6QAkjXtYuliMlnhTvNxOy3rpue5Oe4LdXnNKdaP0D6PO
         rJSvLUcuPOZNt3a2ViMdkaG6mxFz6dCOUnB9lQiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>,
        Yang Li <yang.lee@linux.alibaba.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 244/260] ethtool: Fix an error code in cxgb2.c
Date:   Mon, 20 Sep 2021 18:44:22 +0200
Message-Id: <20210920163939.414841431@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 7db8263a12155c7ae4ad97e850f1e499c73765fc ]

When adapter->registered_device_map is NULL, the value of err is
uncertain, we set err to -EINVAL to avoid ambiguity.

Clean up smatch warning:
drivers/net/ethernet/chelsio/cxgb/cxgb2.c:1114 init_one() warn: missing
error code 'err'

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 0ccdde366ae1..540d99f59226 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -1153,6 +1153,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!adapter->registered_device_map) {
 		pr_err("%s: could not register any net devices\n",
 		       pci_name(pdev));
+		err = -EINVAL;
 		goto out_release_adapter_res;
 	}
 
-- 
2.30.2



