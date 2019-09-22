Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03A2BBA614
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390820AbfIVSr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:47:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390806AbfIVSrZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:25 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36C13208C2;
        Sun, 22 Sep 2019 18:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178045;
        bh=6Ktj9zXXi9b3bAjU5OSe3uz1uAckroEcPDIgl37r6dk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knA+kmBENMz+SYyI4zgbV7ubgtG9TwEaW1Cw/uBqPOZlMxBaPiOPrpSRd23DQ7sm2
         6Art+Kyc8joaeI55tFUN1mCFEfG1OSLdmi+LUTaIKw6N0bRTwvZCxLY7VhFbv+e3eP
         yz9hHUIIvbIaAwQjyfQuLxqhWfKkQbcu7MY/B9CU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 124/203] media: saa7146: add cleanup in hexium_attach()
Date:   Sun, 22 Sep 2019 14:42:30 -0400
Message-Id: <20190922184350.30563-124-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>

[ Upstream commit 42e64117d3b4a759013f77bbcf25ab6700e55de7 ]

If saa7146_register_device() fails, no cleanup is executed, leading to
memory/resource leaks. To fix this issue, perform necessary cleanup work
before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/saa7146/hexium_gemini.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/pci/saa7146/hexium_gemini.c b/drivers/media/pci/saa7146/hexium_gemini.c
index dca20a3d98e25..f962269306707 100644
--- a/drivers/media/pci/saa7146/hexium_gemini.c
+++ b/drivers/media/pci/saa7146/hexium_gemini.c
@@ -292,6 +292,9 @@ static int hexium_attach(struct saa7146_dev *dev, struct saa7146_pci_extension_d
 	ret = saa7146_register_device(&hexium->video_dev, dev, "hexium gemini", VFL_TYPE_GRABBER);
 	if (ret < 0) {
 		pr_err("cannot register capture v4l2 device. skipping.\n");
+		saa7146_vv_release(dev);
+		i2c_del_adapter(&hexium->i2c_adapter);
+		kfree(hexium);
 		return ret;
 	}
 
-- 
2.20.1

