Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C6B39A734
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 19:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhFCRKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 13:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231570AbhFCRKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6C001613F8;
        Thu,  3 Jun 2021 17:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740119;
        bh=FNHdvV5gRfdkfTmM6T5k/QAZ8L1tj0CITsaPmdGBSVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxEr51jD6zezqV2OJZ20kvAEHYZLiWBe2aSpZMEcVhdqfjbqyN400jXYpO+aTtMAY
         SdjRm4B+nkQOfnrHAlAg+a2yL6f8trqXO5rgvnekAIOBxVxuBkGDbW7FqbCGFgySYt
         m7XxT2lvpbOcfUNmcBcW5sbab4ucMBnBO3pkELcxSCn8IjzQIeJ/yP0Ve14GYBX4fR
         SUi5QeEZbV/jKebS2a9vBZjsV6Hnkj1cE1MM8EXnEEe8/hXPrJOUWv+URc9fLf9YLR
         P36R1kFldresRmAdHXjG/Msmf22EG8/Y15DKIOX1MUFsatj/AsBJQ82poyOlzMG8B5
         Uw69fyEeLXB8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Peter Chen <peter.chen@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/39] usb: cdns3: Fix runtime PM imbalance on error
Date:   Thu,  3 Jun 2021 13:07:57 -0400
Message-Id: <20210603170829.3168708-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 07adc0225484fc199e3dc15ec889f75f498c4fca ]

When cdns3_gadget_start() fails, a pairing PM usage counter
decrement is needed to keep the counter balanced.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20210412054908.7975-1-dinghao.liu@zju.edu.cn
Signed-off-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/gadget.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/gadget.c b/drivers/usb/cdns3/gadget.c
index 0aa85cc07ff1..c24c0e3440e3 100644
--- a/drivers/usb/cdns3/gadget.c
+++ b/drivers/usb/cdns3/gadget.c
@@ -3255,8 +3255,10 @@ static int __cdns3_gadget_init(struct cdns3 *cdns)
 	pm_runtime_get_sync(cdns->dev);
 
 	ret = cdns3_gadget_start(cdns);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_sync(cdns->dev);
 		return ret;
+	}
 
 	/*
 	 * Because interrupt line can be shared with other components in
-- 
2.30.2

