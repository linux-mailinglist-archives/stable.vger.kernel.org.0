Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5534C657D72
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbiL1PnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbiL1PnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:43:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE7D17076
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:43:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5A451CE1361
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554B0C433D2;
        Wed, 28 Dec 2022 15:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242193;
        bh=wK5rzT72np5XETtHMRR5L8dBvUrFeT3UP7y0SQOT1Nc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XaFE1C+RQibZYjGTn5jdsuFfZkZM35Se1Wtx3HeC29O7uQ1wXtbh35sTKsfrE6WMq
         zZK3nl4eUmWuIu6Q6WQfYHGhUc06AyRG4WhSeApT1hiGdCNvWhfimPx2VihehMzy1t
         +wln3Arj5+TBnIC6Ru+DHStMyWRb6sXnf8svdksQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        syzbot+0c3cb6dc05fbbdc3ad66@syzkaller.appspotmail.com,
        Gautam Menghani <gautammenghani201@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0378/1073] media: imon: fix a race condition in send_packet()
Date:   Wed, 28 Dec 2022 15:32:46 +0100
Message-Id: <20221228144338.269961455@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Gautam Menghani <gautammenghani201@gmail.com>

[ Upstream commit 813ceef062b53d68f296aa3cb944b21a091fabdb ]

The function send_packet() has a race condition as follows:

func send_packet()
{
    // do work
    call usb_submit_urb()
    mutex_unlock()
    wait_for_event_interruptible()  <-- lock gone
    mutex_lock()
}

func vfd_write()
{
    mutex_lock()
    call send_packet()  <- prev call is not completed
    mutex_unlock()
}

When the mutex is unlocked and the function send_packet() waits for the
call to complete, vfd_write() can start another call, which leads to the
"URB submitted while active" warning in usb_submit_urb().
Fix this by removing the mutex_unlock() call in send_packet() and using
mutex_lock_interruptible().

Link: https://syzkaller.appspot.com/bug?id=e378e6a51fbe6c5cc43e34f131cc9a315ef0337e

Fixes: 21677cfc562a ("V4L/DVB: ir-core: add imon driver")
Reported-by: syzbot+0c3cb6dc05fbbdc3ad66@syzkaller.appspotmail.com
Signed-off-by: Gautam Menghani <gautammenghani201@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/imon.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 735b925da998..91d8056666ec 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -646,15 +646,14 @@ static int send_packet(struct imon_context *ictx)
 		pr_err_ratelimited("error submitting urb(%d)\n", retval);
 	} else {
 		/* Wait for transmission to complete (or abort) */
-		mutex_unlock(&ictx->lock);
 		retval = wait_for_completion_interruptible(
 				&ictx->tx.finished);
 		if (retval) {
 			usb_kill_urb(ictx->tx_urb);
 			pr_err_ratelimited("task interrupted\n");
 		}
-		mutex_lock(&ictx->lock);
 
+		ictx->tx.busy = false;
 		retval = ictx->tx.status;
 		if (retval)
 			pr_err_ratelimited("packet tx failed (%d)\n", retval);
@@ -955,7 +954,8 @@ static ssize_t vfd_write(struct file *file, const char __user *buf,
 	if (ictx->disconnected)
 		return -ENODEV;
 
-	mutex_lock(&ictx->lock);
+	if (mutex_lock_interruptible(&ictx->lock))
+		return -ERESTARTSYS;
 
 	if (!ictx->dev_present_intf0) {
 		pr_err_ratelimited("no iMON device present\n");
-- 
2.35.1



