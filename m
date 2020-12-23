Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF8C2E16CF
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731306AbgLWDCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 22:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:46336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbgLWCTi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2E8F233A1;
        Wed, 23 Dec 2020 02:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689945;
        bh=zmuFXLoaFJwjmAnnu1Jnjzdpd5Ak7hQLxl2x0dUzMXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjPB0nkUpblZgFRG1Z35ROh7C2rdAbc6mxIJTkO42QvCiuIQZF7UyEeRbYw0I4SB7
         Ce32aDz7+lrmPCmoizE+sfYVjY4rbH0OkLtwBL8rLvgTGldfY4GSLSONWu7cYp4cV3
         9UoYCmEFC3EL66jn0XbPqTo/i/1pOCT2ZTYTTixWFdeoSkXg5M1pMNpvsjEbjgViT2
         kY4AhG7KHt5VvQXnzVqat+EtNjXmVBm8ShyPsCLcbka3Mu0EkBO64/BRzx2f+f63Mi
         adTTbNHxh68WxSAU702OfgOVba0qQbktiyJzzERqxeAkFf4mwj3C7qD3vOM2T9n+Y8
         J8ydpLAm8Djsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
        Stefan Haberland <sth@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 040/130] s390/dasd: Fix operational path inconsistency
Date:   Tue, 22 Dec 2020 21:16:43 -0500
Message-Id: <20201223021813.2791612-40-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Höppner <hoeppner@linux.ibm.com>

[ Upstream commit 9e34c8ba91697cb7441805c36d92ab3e695df6e0 ]

During online processing and setting up a DASD device, the configuration
data for operational paths is read and validated two times
(dasd_eckd_read_conf()). The first time to provide information that are
necessary for the LCU setup. A second time after the LCU setup as a
device might report different configuration data then.

When the configuration setup for each operational path is being
validated, an initial call to dasd_eckd_clear_conf_data() is issued.
This call wipes all previously available configuration data and path
information for each path.
However, the operational path mask is not updated during this process.

As a result, the stored operational path mask might no longer correspond
to the operational paths mask reported by the CIO layer, as several
paths might be gone between the two dasd_eckd_read_conf() calls.

This inconsistency leads to more severe issues in later path handling
changes. Fix this by removing the channel paths from the operational
path mask during the dasd_eckd_clear_conf_data() call.

Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_eckd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index ad44d22e88591..b2964c204fefb 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1013,6 +1013,7 @@ static void dasd_eckd_clear_conf_data(struct dasd_device *device)
 		device->path[i].cssid = 0;
 		device->path[i].ssid = 0;
 		device->path[i].chpid = 0;
+		dasd_path_notoper(device, i);
 	}
 }
 
-- 
2.27.0

