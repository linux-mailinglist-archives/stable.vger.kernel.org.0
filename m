Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDA888D5B
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfHJUp0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:45:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55472 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726921AbfHJUoJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:09 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDf-00053j-03; Sat, 10 Aug 2019 21:44:07 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-0003cG-IP; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "YueHaibing" <yuehaibing@huawei.com>,
        "Hulk Robot" <hulkci@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Mukesh Ojha" <mojha@codeaurora.org>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.301010446@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 060/157] dccp: Fix memleak in __feat_register_sp
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: YueHaibing <yuehaibing@huawei.com>

commit 1d3ff0950e2b40dc861b1739029649d03f591820 upstream.

If dccp_feat_push_change fails, we forget free the mem
which is alloced by kmemdup in dccp_feat_clone_sp_val.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: e8ef967a54f4 ("dccp: Registration routines for changing feature values")
Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/dccp/feat.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/dccp/feat.c
+++ b/net/dccp/feat.c
@@ -738,7 +738,12 @@ static int __feat_register_sp(struct lis
 	if (dccp_feat_clone_sp_val(&fval, sp_val, sp_len))
 		return -ENOMEM;
 
-	return dccp_feat_push_change(fn, feat, is_local, mandatory, &fval);
+	if (dccp_feat_push_change(fn, feat, is_local, mandatory, &fval)) {
+		kfree(fval.sp.vec);
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 /**

