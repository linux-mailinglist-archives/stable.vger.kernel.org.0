Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A971411EC6
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351480AbhITReK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:34:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345873AbhITRcP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:32:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D050061AF8;
        Mon, 20 Sep 2021 17:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157494;
        bh=HRYt+w4rh3mflXhyz3JiNRj8hMqLQ2bq6430B8eWofc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZk6EKMca3eYUUxEmMc0jfIp2zWJNhc1z/7vcC203eKtmLu5sT+n3981KZT8T3s2i
         POWt7IcWyrbsxGTHUax5L/NH4X6EVOzEc3bavwApBU85sOtwLjyg3ic2YgzvsyELGy
         1ITfbW0513b51Nm3oZ7TfOKKRwHDPu5+LuCKQyHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 4.19 017/293] USB: serial: mos7720: improve OOM-handling in read_mos_reg()
Date:   Mon, 20 Sep 2021 18:39:39 +0200
Message-Id: <20210920163933.850068913@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit 161a582bd1d8681095f158d11bc679a58f1d026b upstream.

clang static analysis reports this problem

mos7720.c:352:2: warning: Undefined or garbage value returned to caller
        return d;
        ^~~~~~~~

In the parport_mos7715_read_data()'s call to read_mos_reg(), 'd' is
only set after the alloc block.

	buf = kmalloc(1, GFP_KERNEL);
	if (!buf)
		return -ENOMEM;

Although the problem is reported in parport_most7715_read_data(),
none of the callee's of read_mos_reg() check the return status.

Make sure to clear the return-value buffer also on allocation failures.

Fixes: 0d130367abf5 ("USB: serial: mos7720: fix control-message error handling")
Signed-off-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20210111220904.1035957-1-trix@redhat.com
[ johan: only clear the buffer on errors, amend commit message ]
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/mos7720.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -226,8 +226,10 @@ static int read_mos_reg(struct usb_seria
 	int status;
 
 	buf = kmalloc(1, GFP_KERNEL);
-	if (!buf)
+	if (!buf) {
+		*data = 0;
 		return -ENOMEM;
+	}
 
 	status = usb_control_msg(usbdev, pipe, request, requesttype, value,
 				     index, buf, 1, MOS_WDR_TIMEOUT);


