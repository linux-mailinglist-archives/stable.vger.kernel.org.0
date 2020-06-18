Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0301FE6CB
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbgFRBNk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 21:13:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728014AbgFRBNj (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08E3421924;
        Thu, 18 Jun 2020 01:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442819;
        bh=++TE833j+DXLC/txZxLB2LxUhnJsxmm4FsnYJoi9dB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C6pUeXGKa7SvAt8zdK9LNe/ol6sjtyqgKQ5X5hQ8E0JuvdZ4q3K2M7+n3BqaIy/CA
         DvPbgWIZi/rtvsJ7n6o5upj2TuTJMY94nZscG/xjjg8Bzr7iJLf9wIvfkDwU2rjNVX
         VkVo74y7fqEIceYjQnFI7vTeqfwwXZHUeJ1wcFtg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hemant Kumar <hemantk@codeaurora.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Jeffrey Hugo <jhugo@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 256/388] bus: mhi: core: Read transfer length from an event properly
Date:   Wed, 17 Jun 2020 21:05:53 -0400
Message-Id: <20200618010805.600873-256-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hemant Kumar <hemantk@codeaurora.org>

[ Upstream commit ee75cedf82d832561af8ba8380aeffd00a9eea77 ]

When MHI Driver receives an EOT event, it reads xfer_len from the
event in the last TRE. The value is under control of the MHI device
and never validated by Host MHI driver. The value should never be
larger than the real size of the buffer but a malicious device can
set the value 0xFFFF as maximum. This causes driver to memory
overflow (both read or write). Fix this issue by reading minimum of
transfer length from event and the buffer length provided.

Signed-off-by: Hemant Kumar <hemantk@codeaurora.org>
Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Jeffrey Hugo <jhugo@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20200521170249.21795-5-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/main.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/bus/mhi/core/main.c b/drivers/bus/mhi/core/main.c
index 97e06cc586e4..8be3d0fb0614 100644
--- a/drivers/bus/mhi/core/main.c
+++ b/drivers/bus/mhi/core/main.c
@@ -513,7 +513,10 @@ static int parse_xfer_event(struct mhi_controller *mhi_cntrl,
 				mhi_cntrl->unmap_single(mhi_cntrl, buf_info);
 
 			result.buf_addr = buf_info->cb_buf;
-			result.bytes_xferd = xfer_len;
+
+			/* truncate to buf len if xfer_len is larger */
+			result.bytes_xferd =
+				min_t(u16, xfer_len, buf_info->len);
 			mhi_del_ring_element(mhi_cntrl, buf_ring);
 			mhi_del_ring_element(mhi_cntrl, tre_ring);
 			local_rp = tre_ring->rp;
@@ -597,7 +600,9 @@ static int parse_rsc_event(struct mhi_controller *mhi_cntrl,
 
 	result.transaction_status = (ev_code == MHI_EV_CC_OVERFLOW) ?
 		-EOVERFLOW : 0;
-	result.bytes_xferd = xfer_len;
+
+	/* truncate to buf len if xfer_len is larger */
+	result.bytes_xferd = min_t(u16, xfer_len, buf_info->len);
 	result.buf_addr = buf_info->cb_buf;
 	result.dir = mhi_chan->dir;
 
-- 
2.25.1

