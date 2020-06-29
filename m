Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B5720E7FA
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732149AbgF2WCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 18:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgF2SfY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 674382467A;
        Mon, 29 Jun 2020 15:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443975;
        bh=RMVHADc1MCpldmDojQ2vsBF9hMOtSGGGcm9B/f+bWkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzD7znvLAPmGq1uz8dlWyKI3ksXNdrD00YjKDrFnAbCY/PUXFbKTAkwSyxWLeVPi1
         q+qr2RQNYqstiLAyCv9QYU/uvU2jERuL2eEJ4PQlrPpMb39GsYplPhwVfUOW+knLGg
         lZlopNFv8L+wLjkxuVrU4WHwvRVSu2bbbPHd+dTw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peter Chen <peter.chen@nxp.com>, Jun Li <jun.li@nxp.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 079/265] usb: cdns3: ep0: fix the test mode set incorrectly
Date:   Mon, 29 Jun 2020 11:15:12 -0400
Message-Id: <20200629151818.2493727-80-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Chen <peter.chen@nxp.com>

commit b51e1cf64f93acebb6d8afbacd648a6ecefc39b4 upstream.

The 'tmode' is ctrl->wIndex, changing it as the real test
mode value for register assignment.

Cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Reviewed-by: Jun Li <jun.li@nxp.com>
Signed-off-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/ep0.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/ep0.c b/drivers/usb/cdns3/ep0.c
index e71240b386b49..f785ce84aba62 100644
--- a/drivers/usb/cdns3/ep0.c
+++ b/drivers/usb/cdns3/ep0.c
@@ -327,7 +327,8 @@ static int cdns3_ep0_feature_handle_device(struct cdns3_device *priv_dev,
 		if (!set || (tmode & 0xff) != 0)
 			return -EINVAL;
 
-		switch (tmode >> 8) {
+		tmode >>= 8;
+		switch (tmode) {
 		case TEST_J:
 		case TEST_K:
 		case TEST_SE0_NAK:
-- 
2.25.1

