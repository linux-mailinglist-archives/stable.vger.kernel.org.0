Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52C97152A
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbfGWJ2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:28:54 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:33865 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728140AbfGWJ2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 05:28:54 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C680D503;
        Tue, 23 Jul 2019 05:28:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 05:28:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=D8bpkT
        Wd5veEIT8GQn6QMIcaW1fc//9aqazP+PUdRDI=; b=WIEHAvfK8yRBv6OmhEeYSa
        QmCDVQERn40hIjPRgTwYrqLMCn8PQ86Xd07roe8rL/sGkqq7VpLE+494Cp9v4/Q0
        7SU1np0f4Zkbra1VzHLiC9UJqVuLeJ5qyFhBXl0MUPtxjSD0pGG3eY1sdPHwcRDw
        HnqzQ+mUSsCDvze8X+XVqiy1XLbflmjT4Fp3wmO7SqGpzIUNKyPi/FyOUipICPP2
        hj+e7W7uFBuk7Rxj2IoU8N4MMZsSWszFmXNKhWwWL79jy9fS1LR9Edn+to/iCjvq
        dobWMYD2xZ4i4r+f8jAAvQeqYnVSiGY4f68SYwe11BD8Xpk6wt138lZi/5aPnvFQ
        ==
X-ME-Sender: <xms:VNM2XcAOhL0TfnavMxfDym_tu7c8CXGWDY20Nc4QFEPiU8fWQBDbBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:VNM2XQzMSG53d9LF14JB31chCMpn4Jip45oiBThc4JkybdZo2OaQGg>
    <xmx:VNM2XR2FpcrqsAhcTiCxl0Q6_0ppWVsCVHJjtlmjlsF2YXt-FDJOwg>
    <xmx:VNM2XYwpfWk-hggyepuhmr_wEDLAo8l_R3l0joldJhVNyTiXppC4lQ>
    <xmx:VdM2XVS_8IrID81SbkvA05f3Jcc4OtpDrkDFfwad6VqfhOScYFV-ZQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3048C8005C;
        Tue, 23 Jul 2019 05:28:52 -0400 (EDT)
Subject: FAILED: patch "[PATCH] bcache: destroy dc->writeback_write_wq if failed to create" failed to apply to 4.14-stable tree
To:     colyli@suse.de, axboe@kernel.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 11:28:50 +0200
Message-ID: <15638741309729@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f54d801dda14942dbefa00541d10603015b7859c Mon Sep 17 00:00:00 2001
From: Coly Li <colyli@suse.de>
Date: Fri, 28 Jun 2019 19:59:44 +0800
Subject: [PATCH] bcache: destroy dc->writeback_write_wq if failed to create
 dc->writeback_thread

Commit 9baf30972b55 ("bcache: fix for gc and write-back race") added a
new work queue dc->writeback_write_wq, but forgot to destroy it in the
error condition when creating dc->writeback_thread failed.

This patch destroys dc->writeback_write_wq if kthread_create() returns
error pointer to dc->writeback_thread, then a memory leak is avoided.

Fixes: 9baf30972b55 ("bcache: fix for gc and write-back race")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 262f7ef20992..21081febcb59 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -833,6 +833,7 @@ int bch_cached_dev_writeback_start(struct cached_dev *dc)
 					      "bcache_writeback");
 	if (IS_ERR(dc->writeback_thread)) {
 		cached_dev_put(dc);
+		destroy_workqueue(dc->writeback_write_wq);
 		return PTR_ERR(dc->writeback_thread);
 	}
 	dc->writeback_running = true;

