Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BDF2F13FE
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733125AbhAKNSd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:18:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732970AbhAKNSR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:18:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 027AC2253A;
        Mon, 11 Jan 2021 13:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610371056;
        bh=cvictUPvom2laqjO72/dMCE0WGc+nRIAWqwBfbZztvU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsoRE5tKRL8rfuKDKDKfv5+4Mxg/+IJqZZBmFxwjN2ND1TUs0+Nc7hETJEJrzT40d
         FjH20xUCbOR+8Te92tdSC3L/P28wur8+IO3sYp6T4wVcjTpldxtwxqr8rbcHFeiN/w
         q3OVjDeISO3bsbZ3BooFUtJzzgYtHwnPIDJ29IfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 095/145] USB: yurex: fix control-URB timeout handling
Date:   Mon, 11 Jan 2021 14:01:59 +0100
Message-Id: <20210111130053.100573688@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 372c93131998c0622304bed118322d2a04489e63 upstream.

Make sure to always cancel the control URB in write() so that it can be
reused after a timeout or spurious CMD_ACK.

Currently any further write requests after a timeout would fail after
triggering a WARN() in usb_submit_urb() when attempting to submit the
already active URB.

Reported-by: syzbot+e87ebe0f7913f71f2ea5@syzkaller.appspotmail.com
Fixes: 6bc235a2e24a ("USB: add driver for Meywa-Denki & Kayac YUREX")
Cc: stable <stable@vger.kernel.org>     # 2.6.37
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/yurex.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -495,6 +495,9 @@ static ssize_t yurex_write(struct file *
 		timeout = schedule_timeout(YUREX_WRITE_TIMEOUT);
 	finish_wait(&dev->waitq, &wait);
 
+	/* make sure URB is idle after timeout or (spurious) CMD_ACK */
+	usb_kill_urb(dev->cntl_urb);
+
 	mutex_unlock(&dev->io_mutex);
 
 	if (retval < 0) {


