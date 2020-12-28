Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C99A22E3CDB
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438557AbgL1OH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:07:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:42520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438552AbgL1OH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:07:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22B2C207A9;
        Mon, 28 Dec 2020 14:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164438;
        bh=AxZ1D9jaJpTHEJNzorAHIOzHbl+64PHdoIc9ZvZPfj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZVsb8YpnIPg5HY4ukDa5/u0Uoay6p5iUFqRPIvp2Ld/EiH85+dP5UkryFgFxWYsK
         5WamNLom0w1Z8guDZ4aQpmZxGTpmydXJR+nfD4JsVEu3WbReIsNWE6dP7t3L18bA2i
         PSow6mcgB1jqPfTnz8QL9oMSVuyNsTO5v85kCotE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/717] bus: mhi: core: Remove double locking from mhi_driver_remove()
Date:   Mon, 28 Dec 2020 13:42:28 +0100
Message-Id: <20201228125028.151067722@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

[ Upstream commit 9b627c25e70816a5e1dca940444b5029065b4d60 ]

There is double acquisition of the pm_lock from mhi_driver_remove()
function. Remove the read_lock_bh/read_unlock_bh calls for pm_lock
taken during a call to mhi_device_put() as the lock is acquired
within the function already. This will help avoid a potential
kernel panic.

Fixes: 189ff97cca53 ("bus: mhi: core: Add support for data transfer")
Reported-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/core/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/bus/mhi/core/init.c b/drivers/bus/mhi/core/init.c
index 0ffdebde82657..0a09f8215057d 100644
--- a/drivers/bus/mhi/core/init.c
+++ b/drivers/bus/mhi/core/init.c
@@ -1276,10 +1276,8 @@ static int mhi_driver_remove(struct device *dev)
 		mutex_unlock(&mhi_chan->mutex);
 	}
 
-	read_lock_bh(&mhi_cntrl->pm_lock);
 	while (mhi_dev->dev_wake)
 		mhi_device_put(mhi_dev);
-	read_unlock_bh(&mhi_cntrl->pm_lock);
 
 	return 0;
 }
-- 
2.27.0



