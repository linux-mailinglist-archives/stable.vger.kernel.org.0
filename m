Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7FC3CDB44
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbhGSOmN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:42:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245591AbhGSOjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:39:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 619516135D;
        Mon, 19 Jul 2021 15:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707922;
        bh=dK4oXBu7DvXkxRUmQC1iqHAflWit35SWU6qTryn/LvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejWDxItUr5LJoqB3GQS+iXgWmSSt9A9O9FxzVI4Q+Srxo9MchMZs+sxx0N7254Jbh
         dIdOMqF4Q2yeiUVmSf1xIhty0bI65SQm7xPeqfDeOQL26zRcadLJZm1UtwxjeyqKGv
         fRxQDGSsD81H5SPOuL72+8NI/6vw+aXQAX47Vr7o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 075/315] media: s5p_cec: decrement usage count if disabled
Date:   Mon, 19 Jul 2021 16:49:24 +0200
Message-Id: <20210719144945.338705296@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit 747bad54a677d8633ec14b39dfbeb859c821d7f2 ]

There's a bug at s5p_cec_adap_enable(): if called to
disable the device, it should call pm_runtime_put()
instead of pm_runtime_disable(), as the goal here is to
decrement the usage_count and not to disable PM runtime.

Reported-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Fixes: 1bcbf6f4b6b0 ("[media] cec: s5p-cec: Add s5p-cec driver")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/s5p-cec/s5p_cec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/s5p-cec/s5p_cec.c b/drivers/media/platform/s5p-cec/s5p_cec.c
index 8837e2678bde..3032247c63a5 100644
--- a/drivers/media/platform/s5p-cec/s5p_cec.c
+++ b/drivers/media/platform/s5p-cec/s5p_cec.c
@@ -55,7 +55,7 @@ static int s5p_cec_adap_enable(struct cec_adapter *adap, bool enable)
 	} else {
 		s5p_cec_mask_tx_interrupts(cec);
 		s5p_cec_mask_rx_interrupts(cec);
-		pm_runtime_disable(cec->dev);
+		pm_runtime_put(cec->dev);
 	}
 
 	return 0;
-- 
2.30.2



