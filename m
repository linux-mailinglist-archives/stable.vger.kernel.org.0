Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B98F4414D
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391553AbfFMQNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:59988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731206AbfFMImv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:42:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9FDE20851;
        Thu, 13 Jun 2019 08:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415370;
        bh=0nF0E6OR/0/YkO50J1rU0QWN6hYYNx0848W/umyVxWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pOOkmyUzHCYWMDGLhmselmHLtwyYJy81oUip+SPc3gWbcaS6PF1S3xcc0D3zgHbp1
         RUs9i5MFzH0aV5dRPGP8KKXtayMnwbBDO/SKP2ekhWyuxkLHDCr8yg/78kb6UgGMTJ
         Bqjkpt4CRiQ9TWwmSvIhy8xEdCpg+Khxh65BhbHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wesley Sheng <wesley.sheng@microchip.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/118] switchtec: Fix unintended mask of MRPC event
Date:   Thu, 13 Jun 2019 10:33:29 +0200
Message-Id: <20190613075648.043874764@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075643.642092651@linuxfoundation.org>
References: <20190613075643.642092651@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 083c1b5e50b701899dc32445efa8b153685260d5 ]

When running application tool switchtec-user's `firmware update` and `event
wait` commands concurrently, sometimes the firmware update speed reduced
significantly.

It is because when the MRPC event happened after MRPC event occurrence
check but before the event mask loop reaches its header register in event
ISR, the MRPC event would be masked unintentionally.  Since there's no
chance to enable it again except for a module reload, all the following
MRPC execution completion checks time out.

Fix this bug by skipping the mask operation for MRPC event in event ISR,
same as what we already do for LINK event.

Fixes: 52eabba5bcdb ("switchtec: Add IOCTLs to the Switchtec driver")
Signed-off-by: Wesley Sheng <wesley.sheng@microchip.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/switch/switchtec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index 37d0c15c9eeb..72db2e0ebced 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1116,7 +1116,8 @@ static int mask_event(struct switchtec_dev *stdev, int eid, int idx)
 	if (!(hdr & SWITCHTEC_EVENT_OCCURRED && hdr & SWITCHTEC_EVENT_EN_IRQ))
 		return 0;
 
-	if (eid == SWITCHTEC_IOCTL_EVENT_LINK_STATE)
+	if (eid == SWITCHTEC_IOCTL_EVENT_LINK_STATE ||
+	    eid == SWITCHTEC_IOCTL_EVENT_MRPC_COMP)
 		return 0;
 
 	dev_dbg(&stdev->dev, "%s: %d %d %x\n", __func__, eid, idx, hdr);
-- 
2.20.1



