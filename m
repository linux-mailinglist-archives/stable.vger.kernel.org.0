Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04BB2150BBC
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgBCQaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:30:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:42336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729883AbgBCQaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:30:02 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86F832051A;
        Mon,  3 Feb 2020 16:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747401;
        bh=WLHXPwq0EdaMgI+zF0ACG1Mj7qwQtreqZgVlFTlDgD0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kz3/+I3dheYeKN0DKxXp6XrCGO6Ajn0pQVIRzReVbw+UN4tD4xILIadYAa+d74Xby
         OQbUcSByDZ2UGG5kEuUfT4AqynH8Poa4vqdEC/SXr2ug8zKWbQUanCLga5XiniBs77
         QO+WF1tgsJoDPO+u46JUVtSkIsNu70Ni33Kkj37M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 66/89] wireless: wext: avoid gcc -O3 warning
Date:   Mon,  3 Feb 2020 16:19:51 +0000
Message-Id: <20200203161925.119010568@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161916.847439465@linuxfoundation.org>
References: <20200203161916.847439465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e16119655c9e6c4aa5767cd971baa9c491f41b13 ]

After the introduction of CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE_O3,
the wext code produces a bogus warning:

In function 'iw_handler_get_iwstats',
    inlined from 'ioctl_standard_call' at net/wireless/wext-core.c:1015:9,
    inlined from 'wireless_process_ioctl' at net/wireless/wext-core.c:935:10,
    inlined from 'wext_ioctl_dispatch.part.8' at net/wireless/wext-core.c:986:8,
    inlined from 'wext_handle_ioctl':
net/wireless/wext-core.c:671:3: error: argument 1 null where non-null expected [-Werror=nonnull]
   memcpy(extra, stats, sizeof(struct iw_statistics));
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
In file included from arch/x86/include/asm/string.h:5,
net/wireless/wext-core.c: In function 'wext_handle_ioctl':
arch/x86/include/asm/string_64.h:14:14: note: in a call to function 'memcpy' declared here

The problem is that ioctl_standard_call() sometimes calls the handler
with a NULL argument that would cause a problem for iw_handler_get_iwstats.
However, iw_handler_get_iwstats never actually gets called that way.

Marking that function as noinline avoids the warning and leads
to slightly smaller object code as well.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20200107200741.3588770-1-arnd@arndb.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/wext-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 6cdb054484d66..5236a3c2c0ccf 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -659,7 +659,8 @@ struct iw_statistics *get_wireless_stats(struct net_device *dev)
 	return NULL;
 }
 
-static int iw_handler_get_iwstats(struct net_device *		dev,
+/* noinline to avoid a bogus warning with -O3 */
+static noinline int iw_handler_get_iwstats(struct net_device *	dev,
 				  struct iw_request_info *	info,
 				  union iwreq_data *		wrqu,
 				  char *			extra)
-- 
2.20.1



