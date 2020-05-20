Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27331DAAEE
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 08:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgETGrT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 02:47:19 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:54549 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726224AbgETGrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 02:47:19 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589957238; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=xDWEOM39/obrXrVTHRAwQnXOwD7Y6aHVx/XnwR6FAbc=; b=wwaD6WhnYkSOsrVIOTtldD6I/VSkl3//VlaZ0RizG4ut0HLcFFgwtSx6iFWTr9Nyr52cUJkS
 cWpjLfUY723FzFJbPuebJ93gB7TnBQqfrZk+XRyl+/v5ICGlNMiiLaAHEH24hthJgEercB7x
 REhgMlejKzY5lkl/OaRtQvlvJnE=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyI1ZjI4MyIsICJzdGFibGVAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5ec4d276.7f5ec23f8848-smtp-out-n04;
 Wed, 20 May 2020 06:47:18 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DE524C433C6; Wed, 20 May 2020 06:47:17 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from rananta-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rananta)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0E9C1C433C8;
        Wed, 20 May 2020 06:47:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0E9C1C433C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=rananta@codeaurora.org
From:   Raghavendra Rao Ananta <rananta@codeaurora.org>
To:     gregkh@linuxfoundation.org, jslaby@suse.com, andrew@daynix.com
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Raghavendra Rao Ananta <rananta@codeaurora.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] tty: hvc: Fix data abort due to race in hvc_open
Date:   Tue, 19 May 2020 23:47:08 -0700
Message-Id: <20200520064708.24278-1-rananta@codeaurora.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Potentially, hvc_open() can be called in parallel when two tasks calls
open() on /dev/hvcX. In such a scenario, if the hp->ops->notifier_add()
callback in the function fails, where it sets the tty->driver_data to
NULL, the parallel hvc_open() can see this NULL and cause a memory abort.
Hence, do a NULL check at the beginning, before proceeding ahead.

The issue can be easily reproduced by launching two tasks simultaneously
that does an open() call on /dev/hvcX.
For example:
$ cat /dev/hvc0 & cat /dev/hvc0 &

Cc: stable@vger.kernel.org
Signed-off-by: Raghavendra Rao Ananta <rananta@codeaurora.org>
---
 drivers/tty/hvc/hvc_console.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 436cc51c92c3..80709f754cc8 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -350,6 +350,9 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 	unsigned long flags;
 	int rc = 0;

+	if (!hp)
+		return -ENODEV;
+
 	spin_lock_irqsave(&hp->port.lock, flags);
 	/* Check and then increment for fast path open. */
 	if (hp->port.count++ > 0) {
--
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
