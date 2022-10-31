Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBA56130B9
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 07:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbiJaGta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 02:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbiJaGt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 02:49:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F51EBCB4
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 23:49:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F295B81147
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 06:49:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7A0C433D6;
        Mon, 31 Oct 2022 06:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667198965;
        bh=F7NS55PXNDG2dxy18LS7uM5j0bh8v0Yl1a/TTeUe32o=;
        h=Subject:To:Cc:From:Date:From;
        b=s3qdJ5PJmJapby3/KlmwvoZOIDwIEEQXQhZA5mr41lT7Dz9KBHXAZvhkQUXC5K8T0
         69T5bNZiTcZcshLVQPxUUv3dSAdsAjjTM/9HepClATxQ3HFCOqtW71zJwKT5hMqLI+
         Gm9WLffdCHhGuVHbpm9T0LJdUALb5BR+cyypZ0NQ=
Subject: FAILED: patch "[PATCH] s390/cio: fix out-of-bounds access on cio_ignore free" failed to apply to 5.15-stable tree
To:     oberpar@linux.ibm.com, egorenar@linux.ibm.com, gor@linux.ibm.com,
        stable@vger.kernel.org, vneethv@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 31 Oct 2022 07:50:21 +0100
Message-ID: <16671990212509@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

1b6074112742 ("s390/cio: fix out-of-bounds access on cio_ignore free")
0c3812c347bf ("s390/cio: derive cdev information only for IO-subchannels")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1b6074112742f65ece71b0f299ca5a6a887d2db6 Mon Sep 17 00:00:00 2001
From: Peter Oberparleiter <oberpar@linux.ibm.com>
Date: Fri, 14 Oct 2022 12:24:58 +0200
Subject: [PATCH] s390/cio: fix out-of-bounds access on cio_ignore free

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

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 913b6ddd040b..c7db95398500 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -753,13 +753,9 @@ static int __unset_online(struct device *dev, void *data)
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

