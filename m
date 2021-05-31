Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2433F395CEC
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbhEaNkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:40:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232320AbhEaNg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:36:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD16F61449;
        Mon, 31 May 2021 13:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467553;
        bh=aeJBmWwNnCLwm4Zv5IDmFtneV/ZXvJBGnlgGuDcJeYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TXH3MOUi/7MZQ9ncvLaeo7kKcQqQ4mN/DG30GP0yhAy0PfZJJ/pNaOvUrCSOrB5WC
         yFEoxTk7I60O3/akB/qh6fA367wQC+1ww4V+szqm6VzbX/7ERvhVHwHxEZQinWWLfe
         te+wgMZSqwhJVWQgYsXNybk9WtqjpbUid5QI5EIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b4d3fd1dfd53e90afd79@syzkaller.appspotmail.com,
        Jean Delvare <jdelvare@suse.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Wolfram Sang <wsa@kernel.org>
Subject: [PATCH 4.19 073/116] i2c: i801: Dont generate an interrupt on bus reset
Date:   Mon, 31 May 2021 15:14:09 +0200
Message-Id: <20210531130642.627366636@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

commit e4d8716c3dcec47f1557024add24e1f3c09eb24b upstream.

Now that the i2c-i801 driver supports interrupts, setting the KILL bit
in a attempt to recover from a timed out transaction triggers an
interrupt. Unfortunately, the interrupt handler (i801_isr) is not
prepared for this situation and will try to process the interrupt as
if it was signaling the end of a successful transaction. In the case
of a block transaction, this can result in an out-of-range memory
access.

This condition was reproduced several times by syzbot:
https://syzkaller.appspot.com/bug?extid=ed71512d469895b5b34e
https://syzkaller.appspot.com/bug?extid=8c8dedc0ba9e03f6c79e
https://syzkaller.appspot.com/bug?extid=c8ff0b6d6c73d81b610e
https://syzkaller.appspot.com/bug?extid=33f6c360821c399d69eb
https://syzkaller.appspot.com/bug?extid=be15dc0b1933f04b043a
https://syzkaller.appspot.com/bug?extid=b4d3fd1dfd53e90afd79

So disable interrupts while trying to reset the bus. Interrupts will
be enabled again for the following transaction.

Fixes: 636752bcb517 ("i2c-i801: Enable IRQ for SMBus transactions")
Reported-by: syzbot+b4d3fd1dfd53e90afd79@syzkaller.appspotmail.com
Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Tested-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-i801.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -384,11 +384,9 @@ static int i801_check_post(struct i801_p
 		dev_err(&priv->pci_dev->dev, "Transaction timeout\n");
 		/* try to stop the current command */
 		dev_dbg(&priv->pci_dev->dev, "Terminating the current operation\n");
-		outb_p(inb_p(SMBHSTCNT(priv)) | SMBHSTCNT_KILL,
-		       SMBHSTCNT(priv));
+		outb_p(SMBHSTCNT_KILL, SMBHSTCNT(priv));
 		usleep_range(1000, 2000);
-		outb_p(inb_p(SMBHSTCNT(priv)) & (~SMBHSTCNT_KILL),
-		       SMBHSTCNT(priv));
+		outb_p(0, SMBHSTCNT(priv));
 
 		/* Check if it worked */
 		status = inb_p(SMBHSTSTS(priv));


