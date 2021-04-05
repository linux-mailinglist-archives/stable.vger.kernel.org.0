Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8FE353CEB
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 10:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhDEI50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 04:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233175AbhDEI5X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 04:57:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 259FC61394;
        Mon,  5 Apr 2021 08:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617613037;
        bh=2dstsEngq7u3qcpS5E8RZsHMGQ51sMsJ66fsv2qsyQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4q3elFvsuGUEvdQP8OSYbsaMtgZLkC55Noq56rh+4BGjaJQMBb2kXSwEqIZqfMK5
         A/1QrmwCsemr4QuN+NUAl2uz75y29EK/+lqCTZHuTOUOpOlaAvl0f0bXoDgtva+Ocq
         SyTOmMWuZPuPsVUYUoBU8wAz0bd3dvwxrHjSNIF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.9 29/35] cdc-acm: fix BREAK rx code path adding necessary calls
Date:   Mon,  5 Apr 2021 10:54:04 +0200
Message-Id: <20210405085019.789016380@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085018.871387942@linuxfoundation.org>
References: <20210405085018.871387942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 08dff274edda54310d6f1cf27b62fddf0f8d146e upstream.

Counting break events is nice but we should actually report them to
the tty layer.

Fixes: 5a6a62bdb9257 ("cdc-acm: add TIOCMIWAIT")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20210311133714.31881-1-oneukum@suse.com
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/cdc-acm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -335,8 +335,10 @@ static void acm_ctrl_irq(struct urb *urb
 			acm->iocount.dsr++;
 		if (difference & ACM_CTRL_DCD)
 			acm->iocount.dcd++;
-		if (newctrl & ACM_CTRL_BRK)
+		if (newctrl & ACM_CTRL_BRK) {
 			acm->iocount.brk++;
+			tty_insert_flip_char(&acm->port, 0, TTY_BREAK);
+		}
 		if (newctrl & ACM_CTRL_RI)
 			acm->iocount.rng++;
 		if (newctrl & ACM_CTRL_FRAMING)


