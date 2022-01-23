Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E66449F749
	for <lists+stable@lfdr.de>; Fri, 28 Jan 2022 11:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346199AbiA1K2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 05:28:01 -0500
Received: from www.linuxtv.org ([130.149.80.248]:39018 "EHLO www.linuxtv.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233599AbiA1K2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Jan 2022 05:28:01 -0500
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1nDOHY-00Bwyw-7W; Fri, 28 Jan 2022 10:15:04 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Sun, 23 Jan 2022 20:18:42 +0000
Subject: [git:media_tree/master] media: davinci: vpif: fix unbalanced runtime PM get
To:     linuxtv-commits@linuxtv.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Johan Hovold <johan@kernel.org>, Lad@linuxtv.org,
        Prabhakar <prabhakar.csengg@gmail.com>, stable@vger.kernel.org
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1nDOHY-00Bwyw-7W@www.linuxtv.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: davinci: vpif: fix unbalanced runtime PM get
Author:  Johan Hovold <johan@kernel.org>
Date:    Wed Dec 22 15:20:22 2021 +0100

Make sure to balance the runtime PM usage counter on driver unbind.

Fixes: 407ccc65bfd2 ("[media] davinci: vpif: add pm_runtime support")
Cc: stable@vger.kernel.org      # 3.9
Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Reviewed-by: Lad Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/platform/davinci/vpif.c | 1 +
 1 file changed, 1 insertion(+)

---

diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index 5a89d885d0e3..9752a5ec36f7 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -495,6 +495,7 @@ static int vpif_probe(struct platform_device *pdev)
 
 static int vpif_remove(struct platform_device *pdev)
 {
+	pm_runtime_put(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	return 0;
 }
