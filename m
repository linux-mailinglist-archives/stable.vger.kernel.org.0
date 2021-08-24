Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021083F6406
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239262AbhHXRAR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238842AbhHXQ7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09DBF6138B;
        Tue, 24 Aug 2021 16:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824245;
        bh=bOMIH33L41Oipiku4tIzUnvyTa03l4R0s1KVXBSBRJ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iYpxprpG4YxUUof4iDAcdzCFLWKZWf0cLgPZDAGFILppUf5E77IGP+2FsFu0Mtqed
         YpA57bTmkZp8qp029Ev6bCi3gw/U64XDLoVMHTfw2E4RvqcubRVoJwBBQhRwYUxUC2
         QsJ5+zrKuonnCWsUl+X5GgDRfB4Se8bA9R47tkc64AEte7NpCPuWxt1iSnpnQKZ6/u
         GvywDzp/XCsWAqwhSss28oocJPtbXRZL9AtZhtQVHE4NoysNkXvJ2qc5L9ASkHf/FS
         hUnCv/6ktMSgrs+NPnP8Cv8moUDi/gbDxgDmhjQ/VMEctiiBxKurkdDyT+2W/TTEMj
         rTlo+9cb3iD+g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hayes Wang <hayeswang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 078/127] r8152: fix writing USB_BP2_EN
Date:   Tue, 24 Aug 2021 12:55:18 -0400
Message-Id: <20210824165607.709387-79-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit a876a33d2a1102f99fc782fefb784f4dd4841d8c ]

The register of USB_BP2_EN is 16 bits, so we should use
ocp_write_word(), not ocp_write_byte().

Fixes: 9370f2d05a2a ("support request_firmware for RTL8153")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2cf763b4ea84..b2b77edf72b8 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3963,7 +3963,7 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
 	case RTL_VER_15:
 	default:
 		if (type == MCU_TYPE_USB) {
-			ocp_write_byte(tp, MCU_TYPE_USB, USB_BP2_EN, 0);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP2_EN, 0);
 
 			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0);
 			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0);
-- 
2.30.2

