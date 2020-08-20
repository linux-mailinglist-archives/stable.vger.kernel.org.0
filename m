Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F2A24B515
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729565AbgHTKSK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731361AbgHTKRo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:17:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CEECE2067C;
        Thu, 20 Aug 2020 10:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918663;
        bh=bZHxh33PZkH/MAFburC2lqHt5TjiyHUeFr/pGPuH/zU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CpOnklwJs28aezUNhEl4mVetrKh9uiSM2T9BL3LZugsziHVMMpQ/L0h6zHinaUuoJ
         FI089dRNhYWquGLsu9co5Va9t350b/0GnfIizCfGmUcOcV07YeB9QmtIxbbbRsAY96
         AgVl0B+HtLow2OyaZAU1nPdhsuuevwfatalb/wcY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Navid Emamdoost <navid.emamdoost@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 022/149] nfc: s3fwrn5: add missing release on skb in s3fwrn5_recv_frame
Date:   Thu, 20 Aug 2020 11:21:39 +0200
Message-Id: <20200820092126.786782277@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820092125.688850368@linuxfoundation.org>
References: <20200820092125.688850368@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Navid Emamdoost <navid.emamdoost@gmail.com>

[ Upstream commit 1e8fd3a97f2d83a7197876ceb4f37b4c2b00a0f3 ]

The implementation of s3fwrn5_recv_frame() is supposed to consume skb on
all execution paths. Release skb before returning -ENODEV.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/s3fwrn5/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/s3fwrn5/core.c b/drivers/nfc/s3fwrn5/core.c
index 0d866ca295e3f..cafab107ba9bc 100644
--- a/drivers/nfc/s3fwrn5/core.c
+++ b/drivers/nfc/s3fwrn5/core.c
@@ -209,6 +209,7 @@ int s3fwrn5_recv_frame(struct nci_dev *ndev, struct sk_buff *skb,
 	case S3FWRN5_MODE_FW:
 		return s3fwrn5_fw_recv_frame(ndev, skb);
 	default:
+		kfree_skb(skb);
 		return -ENODEV;
 	}
 }
-- 
2.25.1



