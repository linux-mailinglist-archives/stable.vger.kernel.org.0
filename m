Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62097404A2C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbhIILpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238936AbhIILnv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:43:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E65C61211;
        Thu,  9 Sep 2021 11:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187738;
        bh=gt5BgoMf7PUKbuUKs8Clt7Gaku57zTSihOUxXKz1r40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dke46iL8mQAobT72XVJCZOt6fGlOGrJ9YlUiE44xoI82wavDJbGcGsWfp+tJ8X28s
         x8mOLmDgFU822fn4YmGJK+xI7qQkV9aZ+/9YZUko/jS/0aJaWdbECPGOv5sSM/gP3J
         JGE/FS5m/1vSkduI0YejMWYuL1Kzk3k6lTcQl4JxN3Lpbhw79XtiQZQqoGWYrO4gxx
         l2t3tS2SeHxj/e6oTir8thv6OQXdlk9RZ/6tjqQLdZBGlIbQvptHwd1PIx/9QtLyJg
         +Z24rdl3ApAnRifOAm6JoeZiIgmjnCkEEttjyZKE8+KZAxdzc5JgAcND20kKfrI0T7
         DiBpaEfKsSA6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.14 056/252] media: atomisp: pci: fix error return code in atomisp_pci_probe()
Date:   Thu,  9 Sep 2021 07:37:50 -0400
Message-Id: <20210909114106.141462-56-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit d14e272958bdfdc40dcafb827d24ba6fdafa9d52 ]

If init_atomisp_wdts() fails, atomisp_pci_probe() need return
error code.

Link: https://lore.kernel.org/linux-media/20210617072329.1233662-1-yangyingliang@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/atomisp/pci/atomisp_v4l2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
index af0d83eaa68c..1e324f1f656e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp_v4l2.c
@@ -1763,7 +1763,8 @@ static int atomisp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *i
 	if (err < 0)
 		goto register_entities_fail;
 	/* init atomisp wdts */
-	if (init_atomisp_wdts(isp) != 0)
+	err = init_atomisp_wdts(isp);
+	if (err != 0)
 		goto wdt_work_queue_fail;
 
 	/* save the iunit context only once after all the values are init'ed. */
-- 
2.30.2

