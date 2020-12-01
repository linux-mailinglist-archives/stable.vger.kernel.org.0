Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92832C9AC8
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388424AbgLAJAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:00:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388374AbgLAJAw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:00:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B37821D7A;
        Tue,  1 Dec 2020 09:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813237;
        bh=5zTnQBR2uQiioZtrlCyvXMGvrTPfTxctW7F2T1dYdAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QiAuAQ5UeUXpTWwSsJQe8SM+ih9GDJl8Qpld/O5ithNscu9GcMVCZJYjaop9TvJ2
         CD+oGdP3nbH9V+igyX3PpC482Ya/PmUwCtBjEihBET04I5gkybd3O8O9ZTd3yIhEdr
         wLsebiPeAJG0bIQYLckQGAYCrUgVwPnA9mW06lZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4.19 05/57] wireless: Use linux/stddef.h instead of stddef.h
Date:   Tue,  1 Dec 2020 09:53:10 +0100
Message-Id: <20201201084648.353869437@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
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


