Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1881786990
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404934AbfHHTIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:08:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404929AbfHHTIe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:08:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98019214C6;
        Thu,  8 Aug 2019 19:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291313;
        bh=MTFwszCrmSaCj63SpvMh7Xi8g7NApYngPDhIgzx0W1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9HIy5B5fKt7J8s/901BLMyzc63WizxiSvwUT1uClklYv4VsJOtpkzNtUH2h4Irm0
         BxLqHjS8/K7GQpbxtDOR1TZ+VOyz+ZWc7TmtrbRzMNFs715uBrTmpDhR8mWu7d7INe
         LeJc3EQTTL+mtbmNJj2av2AWnFKwCKSdrEpsvqOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 12/45] atm: iphase: Fix Spectre v1 vulnerability
Date:   Thu,  8 Aug 2019 21:04:58 +0200
Message-Id: <20190808190454.460239585@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit ea443e5e98b5b74e317ef3d26bcaea54931ccdee ]

board is controlled by user-space, hence leading to a potential
exploitation of the Spectre variant 1 vulnerability.

This issue was detected with the help of Smatch:

drivers/atm/iphase.c:2765 ia_ioctl() warn: potential spectre issue 'ia_dev' [r] (local cap)
drivers/atm/iphase.c:2774 ia_ioctl() warn: possible spectre second half.  'iadev'
drivers/atm/iphase.c:2782 ia_ioctl() warn: possible spectre second half.  'iadev'
drivers/atm/iphase.c:2816 ia_ioctl() warn: possible spectre second half.  'iadev'
drivers/atm/iphase.c:2823 ia_ioctl() warn: possible spectre second half.  'iadev'
drivers/atm/iphase.c:2830 ia_ioctl() warn: potential spectre issue '_ia_dev' [r] (local cap)
drivers/atm/iphase.c:2845 ia_ioctl() warn: possible spectre second half.  'iadev'
drivers/atm/iphase.c:2856 ia_ioctl() warn: possible spectre second half.  'iadev'

Fix this by sanitizing board before using it to index ia_dev and _ia_dev

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://lore.kernel.org/lkml/20180423164740.GY17484@dhcp22.suse.cz/

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/atm/iphase.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -63,6 +63,7 @@
 #include <asm/byteorder.h>  
 #include <linux/vmalloc.h>
 #include <linux/jiffies.h>
+#include <linux/nospec.h>
 #include "iphase.h"		  
 #include "suni.h"		  
 #define swap_byte_order(x) (((x & 0xff) << 8) | ((x & 0xff00) >> 8))
@@ -2760,8 +2761,11 @@ static int ia_ioctl(struct atm_dev *dev,
    }
    if (copy_from_user(&ia_cmds, arg, sizeof ia_cmds)) return -EFAULT; 
    board = ia_cmds.status;
-   if ((board < 0) || (board > iadev_count))
-         board = 0;    
+
+	if ((board < 0) || (board > iadev_count))
+		board = 0;
+	board = array_index_nospec(board, iadev_count + 1);
+
    iadev = ia_dev[board];
    switch (ia_cmds.cmd) {
    case MEMDUMP:


