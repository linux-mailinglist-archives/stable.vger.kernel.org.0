Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 752A42C9CB0
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387929AbgLAI6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:58:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387920AbgLAI6W (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:58:22 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9669221FF;
        Tue,  1 Dec 2020 08:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813061;
        bh=5zTnQBR2uQiioZtrlCyvXMGvrTPfTxctW7F2T1dYdAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N+riaCd2i8Eaja8PBM0FxuXI8wF0SFg8+fv3nawDpRZUrx47tgHezPfmyQTaMFwcW
         Ny8Rel08TkNi+KCmFSsQRBQ5mZgYb0Y1mr4VP20vVBUjF6CKs4HsfBc9TlelaHzpUc
         ZNCKlmU5E+vHgJYCikXA97B+nZOfocywZTO0gAKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.14 04/50] wireless: Use linux/stddef.h instead of stddef.h
Date:   Tue,  1 Dec 2020 09:53:03 +0100
Message-Id: <20201201084645.288291546@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

commit 1b9ae0c92925ac40489be526d67d0010d0724ce0 upstream.

When compiling inside the kernel include linux/stddef.h instead of
stddef.h. When I compile this header file in backports for power PC I
run into a conflict with ptrdiff_t. I was unable to reproduce this in
mainline kernel. I still would like to fix this problem in the kernel.

Fixes: 6989310f5d43 ("wireless: Use offsetof instead of custom macro.")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Link: https://lore.kernel.org/r/20200521201422.16493-1-hauke@hauke-m.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/linux/wireless.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/uapi/linux/wireless.h
+++ b/include/uapi/linux/wireless.h
@@ -74,7 +74,11 @@
 #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
 #include <linux/if.h>			/* for IFNAMSIZ and co... */
 
-#include <stddef.h>                     /* for offsetof */
+#ifdef __KERNEL__
+#	include <linux/stddef.h>	/* for offsetof */
+#else
+#	include <stddef.h>		/* for offsetof */
+#endif
 
 /***************************** VERSION *****************************/
 /*


