Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66EE1615805
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:43:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230324AbiKBCnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiKBCnq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:43:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CF712D1D
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:43:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 58127CE1F1F
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7E9C433C1;
        Wed,  2 Nov 2022 02:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357022;
        bh=B6T3udP1xuHRUwOetjuRpOW65wP3XOTrZTFLS5o+t24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjSSlmzDXC6VBjwqRH6l0GZ2W5LXZ1QSxbkfqFz+2xqsI12eR0ckv9PDix15VEdlF
         elL1TLsypQZqyZKSw7I1iKkKfMlFRR8vshl+qsh4zotPY5Hf7jL3NhXxYa7okNs9Hw
         Mjkx/OnL8vQd1XTTI1KA0XP+lo5VyyqiDVS857+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Alexander Egorenkov <egorenar@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 6.0 100/240] s390/cio: fix out-of-bounds access on cio_ignore free
Date:   Wed,  2 Nov 2022 03:31:15 +0100
Message-Id: <20221102022113.655137701@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peter Oberparleiter <oberpar@linux.ibm.com>

commit 1b6074112742f65ece71b0f299ca5a6a887d2db6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/cio/css.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -753,13 +753,9 @@ static int __unset_online(struct device
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


