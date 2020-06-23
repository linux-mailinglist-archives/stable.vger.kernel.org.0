Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F11AF206547
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388925AbgFWVdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388897AbgFWULp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:11:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0148320707;
        Tue, 23 Jun 2020 20:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943105;
        bh=OOgmetCZuRCnH71qbi5n8ujQZdNpbGz/9VMiNpgv6Kk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOV1tDR7ACi6Hr1nWze7oGkO/dSlVxK3q4V9Tp1Qbcw6AqEqdIQYDCphs9zPlEsz9
         CFSJ0jfGT4MW7bI8ctEq3DXEgx18LiXYxy2cWT3Tqo2uYk/OQ1tf+0OPgIeX7+8Tdw
         T1JkCZsLNk1g8thxpwj/UxcZSZ8QTzsq/MG+T62E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>,
        kbuild test robot <lkp@intel.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 261/477] USB: gadget: udc: s3c2410_udc: Remove pointless NULL check in s3c2410_udc_nuke
Date:   Tue, 23 Jun 2020 21:54:18 +0200
Message-Id: <20200623195419.903440510@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
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
index 0507a2ca0f552..80002d97b59d8 100644
--- a/drivers/usb/gadget/udc/s3c2410_udc.c
+++ b/drivers/usb/gadget/udc/s3c2410_udc.c
@@ -251,10 +251,6 @@ static void s3c2410_udc_done(struct s3c2410_ep *ep,
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



