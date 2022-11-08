Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653F2621486
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:02:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbiKHOCP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234988AbiKHOCB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:02:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFE462399
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:02:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C19C361595
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B748AC433D6;
        Tue,  8 Nov 2022 14:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916119;
        bh=N3UOjv83K1NG4QJv42MB/rhQscliIwrIK2Vp7z5gNt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MLHs2NW2cuQ48c6+YAn1bKbnUXi1GsltAwzSwn0YjhsLyuqkHtc7ntfBrBkn3YPWE
         Jl7lz4Kk8vKcnx/B2TorzMHdB9K+F/JktPXm4Zf5ajI3D1w+XWiCSpF7tQz7WcsH+V
         DOuQWWLgOUVNDRQhWfa00/Sao86gs9wlfWCOssbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 068/144] s390/cio: fix out-of-bounds access on cio_ignore free
Date:   Tue,  8 Nov 2022 14:39:05 +0100
Message-Id: <20221108133348.154344678@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.ibm.com>

[ Upstream commit 1b6074112742f65ece71b0f299ca5a6a887d2db6 ]

The channel-subsystem-driver scans for newly available devices whenever
device-IDs are removed from the cio_ignore list using a command such as:

  echo free >/proc/cio_ignore

Since an I/O device scan might interfer with running I/Os, commit
172da89ed0ea ("s390/cio: avoid excessive path-verification requests")
introduced an optimization to exclude online devices from the scan.

The newly added check for online devices incorrectly assumes that
an I/O-subchannel's drvdata points to a struct io_subchannel_private.
For devices that are bound to a non-default I/O subchannel driver, such
as the vfio_ccw driver, this results in an out-of-bounds read access
during each scan.

Fix this by changing the scan logic to rely on a driver-independent
online indication. For this we can use struct subchannel->config.ena,
which is the driver's requested subchannel-enabled state. Since I/Os
can only be started on enabled subchannels, this matches the intent
of the original optimization of not scanning devices where I/O might
be running.

Fixes: 172da89ed0ea ("s390/cio: avoid excessive path-verification requests")
Fixes: 0c3812c347bf ("s390/cio: derive cdev information only for IO-subchannels")
Cc: <stable@vger.kernel.org> # v5.15
Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>
Signed-off-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index ce9e7517430f..2ba9e0135565 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -792,13 +792,9 @@ static int __unset_online(struct device *dev, void *data)
 {
 	struct idset *set = data;
 	struct subchannel *sch = to_subchannel(dev);
-	struct ccw_device *cdev;
 
-	if (sch->st == SUBCHANNEL_TYPE_IO) {
-		cdev = sch_get_cdev(sch);
-		if (cdev && cdev->online)
-			idset_sch_del(set, sch->schid);
-	}
+	if (sch->st == SUBCHANNEL_TYPE_IO && sch->config.ena)
+		idset_sch_del(set, sch->schid);
 
 	return 0;
 }
-- 
2.35.1



