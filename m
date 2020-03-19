Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 956F018B71F
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgCSNS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729786AbgCSNS0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:18:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51D5E2173E;
        Thu, 19 Mar 2020 13:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623905;
        bh=0kxq0BJjqASj1v92/2XvVAjaj22dPauRFuuHXWbmc9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rOzJCzPghIvpx00pcikdfnobNHqyyx/FmygtULuBadfHboRbrKDbR671uXv39wGzR
         BocsD5vmi1XkhevfcbhU+GLws2z+8FqX5tPvxazqWaYnEVgYsvv3VmVjWX5iU5C4gZ
         57ADOsk8ETRKpRTtfD1vb24gyKX/BIIXqdBAor+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luo bin <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 93/99] hinic: fix a bug of setting hw_ioctxt
Date:   Thu, 19 Mar 2020 14:04:11 +0100
Message-Id: <20200319124007.255188924@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo bin <luobin9@huawei.com>

[ Upstream commit d2ed69ce9ed3477e2a9527e6b89fe4689d99510e ]

a reserved field is used to signify prime physical function index
in the latest firmware version, so we must assign a value to it
correctly

Signed-off-by: Luo bin <luobin9@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c | 1 +
 drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h | 2 +-
 drivers/net/ethernet/huawei/hinic/hinic_hw_if.h  | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
index 79b5674470842..46aba02b8672b 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.c
@@ -312,6 +312,7 @@ static int set_hw_ioctxt(struct hinic_hwdev *hwdev, unsigned int rq_depth,
 	}
 
 	hw_ioctxt.func_idx = HINIC_HWIF_FUNC_IDX(hwif);
+	hw_ioctxt.ppf_idx = HINIC_HWIF_PPF_IDX(hwif);
 
 	hw_ioctxt.set_cmdq_depth = HW_IOCTXT_SET_CMDQ_DEPTH_DEFAULT;
 	hw_ioctxt.cmdq_depth = 0;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index 0f5563f3b7798..a011fd2d26270 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -104,8 +104,8 @@ struct hinic_cmd_hw_ioctxt {
 
 	u8      rsvd2;
 	u8      rsvd3;
+	u8      ppf_idx;
 	u8      rsvd4;
-	u8      rsvd5;
 
 	u16     rq_depth;
 	u16     rx_buf_sz_idx;
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
index 5b4760c0e9f53..f683ccbdfca02 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_if.h
@@ -146,6 +146,7 @@
 #define HINIC_HWIF_FUNC_IDX(hwif)       ((hwif)->attr.func_idx)
 #define HINIC_HWIF_PCI_INTF(hwif)       ((hwif)->attr.pci_intf_idx)
 #define HINIC_HWIF_PF_IDX(hwif)         ((hwif)->attr.pf_idx)
+#define HINIC_HWIF_PPF_IDX(hwif)        ((hwif)->attr.ppf_idx)
 
 #define HINIC_FUNC_TYPE(hwif)           ((hwif)->attr.func_type)
 #define HINIC_IS_PF(hwif)               (HINIC_FUNC_TYPE(hwif) == HINIC_PF)
-- 
2.20.1



