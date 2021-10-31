Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AD0440D6E
	for <lists+stable@lfdr.de>; Sun, 31 Oct 2021 08:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhJaH0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 Oct 2021 03:26:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:47454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229697AbhJaH0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 31 Oct 2021 03:26:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF06C60E9C;
        Sun, 31 Oct 2021 07:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635665058;
        bh=xw1/N/mxaxWwcK0FpxALPPA8nKlsfh/cUNukKUK0Z8A=;
        h=Subject:To:From:Date:From;
        b=qhCsb4uuHJCCjisXpsu5OEtzFmoqx4SVqp0UratZz7qQkM7Wk4wc58OMpIM1MkIo8
         h8SD8JgHbhk967etTW9R4IhrpIPy442xPsbG2p/6oxiVgGsWzfer99ffJ+tuBT8FV7
         KxTCyswVF82vwat+bPzQQf5HOyh/qg0KZXaJOoSo=
Subject: patch "coresight: cti: Correct the parameter for pm_runtime_put" added to char-misc-next
To:     quic_taozha@quicinc.com, leo.yan@linaro.org,
        mathieu.poirier@linaro.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 31 Oct 2021 08:24:04 +0100
Message-ID: <1635665044222251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    coresight: cti: Correct the parameter for pm_runtime_put

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 692c9a499b286ea478f41b23a91fe3873b9e1326 Mon Sep 17 00:00:00 2001
From: Tao Zhang <quic_taozha@quicinc.com>
Date: Thu, 19 Aug 2021 17:29:37 +0800
Subject: coresight: cti: Correct the parameter for pm_runtime_put

The input parameter of the function pm_runtime_put should be the
same in the function cti_enable_hw and cti_disable_hw. The correct
parameter to use here should be dev->parent.

Signed-off-by: Tao Zhang <quic_taozha@quicinc.com>
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Fixes: 835d722ba10a ("coresight: cti: Initial CoreSight CTI Driver")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1629365377-5937-1-git-send-email-quic_taozha@quicinc.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/hwtracing/coresight/coresight-cti-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwtracing/coresight/coresight-cti-core.c b/drivers/hwtracing/coresight/coresight-cti-core.c
index e2a3620cbf48..8988b2ed2ea6 100644
--- a/drivers/hwtracing/coresight/coresight-cti-core.c
+++ b/drivers/hwtracing/coresight/coresight-cti-core.c
@@ -175,7 +175,7 @@ static int cti_disable_hw(struct cti_drvdata *drvdata)
 	coresight_disclaim_device_unlocked(csdev);
 	CS_LOCK(drvdata->base);
 	spin_unlock(&drvdata->spinlock);
-	pm_runtime_put(dev);
+	pm_runtime_put(dev->parent);
 	return 0;
 
 	/* not disabled this call */
-- 
2.33.1


