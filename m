Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7899145564
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgAVNVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:21:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:38744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730305AbgAVNVe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:21:34 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A49B82467C;
        Wed, 22 Jan 2020 13:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699294;
        bh=jhYhNXYSQxDA8+pS7YjeAPEndnmHw6INZ+Q9N6cpRkw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGbxiDJG+2ituwU1CFzprqy7sn5X0PHEJZZMmx08EiyBnMyhZTnaVbGGY5UsvnUqz
         0OcFWD+N31X0GTWqGZUlZcEzyLXej/GIgCbU69NK4T3QD54b4b/oPm6x/ktfbdZV4p
         3/C2ehslWHTD+5AG4s5lQU4+Bxyc0DIT+qat7hws=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Philipp Rudo <prudo@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH 5.4 073/222] s390/setup: Fix secure ipl message
Date:   Wed, 22 Jan 2020 10:27:39 +0100
Message-Id: <20200122092838.945601820@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Rudo <prudo@linux.ibm.com>

commit 40260b01d029ba374637838213af500e03305326 upstream.

The new machine loader on z15 always creates an IPL Report block and
thus sets the IPL_PL_FLAG_IPLSR even when secure boot is disabled. This
causes the wrong message being printed at boot. Fix this by checking for
IPL_PL_FLAG_SIPL instead.

Fixes: 9641b8cc733f ("s390/ipl: read IPL report at early boot")
Signed-off-by: Philipp Rudo <prudo@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -1059,7 +1059,7 @@ static void __init log_component_list(vo
 
 	if (!early_ipl_comp_list_addr)
 		return;
-	if (ipl_block.hdr.flags & IPL_PL_FLAG_IPLSR)
+	if (ipl_block.hdr.flags & IPL_PL_FLAG_SIPL)
 		pr_info("Linux is running with Secure-IPL enabled\n");
 	else
 		pr_info("Linux is running with Secure-IPL disabled\n");


