Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 763BA2F7A6B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbhAOMt1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:49:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:43284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387878AbhAOMg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:36:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20AEF207C4;
        Fri, 15 Jan 2021 12:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714171;
        bh=D8uEX+akZC/h2Dp8b3/QNIIkzZ8kmzk7uj0WVa2qJWA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUyDqYvuBQQsb3mVpyUkhazS7hGCzlDulKfn4zwUgmrYdB7U+WvJfK/LIee8VImKy
         fN5hf17maM2yCQ3h7U6VC35M9PT3LKC+F5CUjmzR7+dIKYVDwtkz/l/OfeK3iDN2B6
         0u/s4c9zC+ae3qjp076q4uSBaJoC9H87W4tW6CdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 016/103] net: hns3: fix a phy loopback fail issue
Date:   Fri, 15 Jan 2021 13:27:09 +0100
Message-Id: <20210115122006.831328939@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit f04bbcbf1e38d192e94bbfa126731a52332c40b1 ]

When phy driver does not implement the set_loopback interface,
phy loopback test will return -EOPNOTSUPP, and the loopback test
will fail. So when phy driver does not implement the set_loopback
interface, don't do phy loopback test.

Fixes: c9765a89d142 ("net: hns3: add phy selftest function")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -752,7 +752,8 @@ static int hclge_get_sset_count(struct h
 		handle->flags |= HNAE3_SUPPORT_SERDES_SERIAL_LOOPBACK;
 		handle->flags |= HNAE3_SUPPORT_SERDES_PARALLEL_LOOPBACK;
 
-		if (hdev->hw.mac.phydev) {
+		if (hdev->hw.mac.phydev && hdev->hw.mac.phydev->drv &&
+		    hdev->hw.mac.phydev->drv->set_loopback) {
 			count += 1;
 			handle->flags |= HNAE3_SUPPORT_PHY_LOOPBACK;
 		}


