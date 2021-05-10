Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C32437854B
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235091AbhEJK77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:59:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234053AbhEJKzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:55:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A456F6197D;
        Mon, 10 May 2021 10:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643421;
        bh=/ZyQaTHux2q5HyOFnWfZ38CYshcWNR6eS8Xbzte5JH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0bC3ympM/+XjziT+B7Dg0wdlgCDUwqvqKfDKs/owl6dF3c2i8rHDYAcwOzq6wOLYd
         RHXPMb/nwE2xspHJcCdIxVVSCEpJUIfkPAjBz85MlqIy6NK12EkDPj4+6PemJNFFra
         O6sou6JxuMv7hPQTIsN9FgtfjN9g3zEAHcw7/m3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeffrey Hugo <jhugo@codeaurora.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.11 001/342] bus: mhi: core: Fix check for syserr at power_up
Date:   Mon, 10 May 2021 12:16:31 +0200
Message-Id: <20210510102010.145680596@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeffrey Hugo <jhugo@codeaurora.org>

commit 6403298c58d4858d93648f553abf0bcbd2dfaca2 upstream.

The check to see if we have reset the device after detecting syserr at
power_up is inverted.  wait_for_event_timeout() returns 0 on failure,
and a positive value on success.  The check is looking for non-zero
as a failure, which is likely to incorrectly cause a device init failure
if syserr was detected at power_up.  Fix this.

Fixes: e18d4e9fa79b ("bus: mhi: core: Handle syserr during power_up")
Signed-off-by: Jeffrey Hugo <jhugo@codeaurora.org>
Reviewed-by: Loic Poulain <loic.poulain@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/1613165243-23359-1-git-send-email-jhugo@codeaurora.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/core/pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/mhi/core/pm.c
+++ b/drivers/bus/mhi/core/pm.c
@@ -1092,7 +1092,7 @@ int mhi_async_power_up(struct mhi_contro
 							   &val) ||
 					!val,
 				msecs_to_jiffies(mhi_cntrl->timeout_ms));
-		if (ret) {
+		if (!ret) {
 			ret = -EIO;
 			dev_info(dev, "Failed to reset MHI due to syserr state\n");
 			goto error_bhi_offset;


