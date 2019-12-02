Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1B310ECB2
	for <lists+stable@lfdr.de>; Mon,  2 Dec 2019 16:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727519AbfLBP4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Dec 2019 10:56:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:56786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727432AbfLBP4c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Dec 2019 10:56:32 -0500
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AF3B2071F;
        Mon,  2 Dec 2019 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575302192;
        bh=AkCSgQ9Hq3k6AKyOXWqFtNkWeUGQz+Bli6BIB5jGAeY=;
        h=From:To:Cc:Subject:Date:From;
        b=HtG4m0fLsm8b4hl/TZjXU0Uh93wrGBOzUvMxxwIwPAYhGENjMmQzqcE0bes0FNPJ+
         n/bgOuAJ5Qqgx2fkhQGPP9YboRFETXRwhm1znT3fmbWDjG8ycpjyDPWGnicCarbwmH
         iXEUHmlR309hc8ajr3IAYxw0NA8tk0GlZaQNVCS4=
From:   Keith Busch <kbusch@kernel.org>
To:     linux-nvme@lists.infradead.org
Cc:     hch@lst.de, Keith Busch <kbusch@kernel.org>,
        Ingo Brunberg <ingo_brunberg@web.de>,
        Sagi Grimberg <sagi@grimberg.me>, stable@vger.kernel.org
Subject: [PATCH] nvme: Namepace identification descriptor list is optional
Date:   Tue,  3 Dec 2019 00:56:11 +0900
Message-Id: <20191202155611.21549-1-kbusch@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Despite NVM Express specification 1.3 requires a controller claiming to
be 1.3 or higher implement Identify CNS 03h (Namespace Identification
Descriptor list), the driver doesn't really need this identification in
order to use a namespace. The code had already documented in comments
that we're not to consider an error to this command.

Return success if the controller provided any response to an
namespace identification descriptors command.

Fixes: 538af88ea7d9de24 ("nvme: make nvme_report_ns_ids propagate error back")
Reported-by: Ingo Brunberg <ingo_brunberg@web.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 drivers/nvme/host/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index e6ee34376c5e..2a84e1402244 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1735,6 +1735,8 @@ static int nvme_report_ns_ids(struct nvme_ctrl *ctrl, unsigned int nsid,
 		if (ret)
 			dev_warn(ctrl->device,
 				 "Identify Descriptors failed (%d)\n", ret);
+		if (ret > 0)
+			ret = 0;
 	}
 	return ret;
 }
-- 
2.21.0

