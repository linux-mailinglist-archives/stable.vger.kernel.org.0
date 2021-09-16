Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F7540E6D4
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348154AbhIPRZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:46958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348159AbhIPRYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:24:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7138761BD0;
        Thu, 16 Sep 2021 16:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810625;
        bh=gt5BgoMf7PUKbuUKs8Clt7Gaku57zTSihOUxXKz1r40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dJzXnLrbMXTpgadgefIcBkxsIEff0YLEbe0lEC4RoLLBGLhUzVEIBZnZCdX8FZcBw
         cPnxGnKl1YbD1nSTsjShytl8Wk5agOIgU/B1wSqDm9emEzxItdJ+5ZjPQYcENonGxn
         8q0nWD4Qx3jBOOTWK99b915rSSrn8bpclQktefYg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 210/432] media: atomisp: pci: fix error return code in atomisp_pci_probe()
Date:   Thu, 16 Sep 2021 17:59:19 +0200
Message-Id: <20210916155817.951214524@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



