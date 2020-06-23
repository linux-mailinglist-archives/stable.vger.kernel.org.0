Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8817A20614C
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390012AbgFWUjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:39:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391697AbgFWUjA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:39:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA9DD217BA;
        Tue, 23 Jun 2020 20:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944740;
        bh=HEzglXm+5tcsLluMZXsqOjSt5kj4dDPLcECP1cMixxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aA07cUcNmctpOtPj+tgpCBWWdu0CYrwIF8awhFb8y2mCKBrSNMVv8MrUBtfc+UfZ8
         AvYFpcnbt+Q+V6kZf5qcx2p4lTBStqvFZXPNuMI2HwiqM3CuVcCOdzvwKLzB9RWs6a
         IQ7aJHoxEQUYM9YPMcX9AxDuh3Kkdzf0zgU9S/Rk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        kbuild test robot <lkp@intel.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 107/206] USB: gadget: udc: s3c2410_udc: Remove pointless NULL check in s3c2410_udc_nuke
Date:   Tue, 23 Jun 2020 21:57:15 +0200
Message-Id: <20200623195322.203197323@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195316.864547658@linuxfoundation.org>
References: <20200623195316.864547658@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 7a0fbcf7c308920bc6116b3a5fb21c8cc5fec128 ]

Clang warns:

drivers/usb/gadget/udc/s3c2410_udc.c:255:11: warning: comparison of
address of 'ep->queue' equal to a null pointer is always false
[-Wtautological-pointer-compare]
        if (&ep->queue == NULL)
             ~~~~^~~~~    ~~~~
1 warning generated.

It is not wrong, queue is not a pointer so if ep is not NULL, the
address of queue cannot be NULL. No other driver does a check like this
and this check has been around since the driver was first introduced,
presumably with no issues so it does not seem like this check should be
something else. Just remove it.

Commit afe956c577b2d ("kbuild: Enable -Wtautological-compare") exposed
this but it is not the root cause of the warning.

Fixes: 3fc154b6b8134 ("USB Gadget driver for Samsung s3c2410 ARM SoC")
Link: https://github.com/ClangBuiltLinux/linux/issues/1004
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/s3c2410_udc.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/usb/gadget/udc/s3c2410_udc.c b/drivers/usb/gadget/udc/s3c2410_udc.c
index 8bf5ad7a59add..6cc63e317aba5 100644
--- a/drivers/usb/gadget/udc/s3c2410_udc.c
+++ b/drivers/usb/gadget/udc/s3c2410_udc.c
@@ -264,10 +264,6 @@ static void s3c2410_udc_done(struct s3c2410_ep *ep,
 static void s3c2410_udc_nuke(struct s3c2410_udc *udc,
 		struct s3c2410_ep *ep, int status)
 {
-	/* Sanity check */
-	if (&ep->queue == NULL)
-		return;
-
 	while (!list_empty(&ep->queue)) {
 		struct s3c2410_request *req;
 		req = list_entry(ep->queue.next, struct s3c2410_request,
-- 
2.25.1



