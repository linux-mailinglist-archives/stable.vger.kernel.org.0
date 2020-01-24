Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 906B2147F28
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730492AbgAXLAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:00:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726294AbgAXLAE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:00:04 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B77C2075D;
        Fri, 24 Jan 2020 11:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579863602;
        bh=xvaCTscUUS1BiC7M8rqYHxE+86nNTWGyjDjU1NLsW/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHqoi6zD+kUuOHNUtOb9SG20J1/t7ZkkUjvSqOtlrKgySYEvqLq0oUAO6x9bsEc/P
         8MSCt1LFoAG65Qr7a2LtWhwSx2jTU7Phk6T/RZ1hqpIxWWGQVG+iS3DrpBL7VW1X13
         XiHFgo2Dmmk4xAk7oRZh91b+8B75UqN5eZMQ1hhI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Jones <tonyj@suse.de>,
        John Johansen <john.johansen@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 024/639] apparmor: Fix network performance issue in aa_label_sk_perm
Date:   Fri, 24 Jan 2020 10:23:14 +0100
Message-Id: <20200124093050.262620021@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

[ Upstream commit 5f997580e8b12b9f585e34cc16304925d26ce49e ]

The netperf benchmark shows a 5.73% reduction in throughput for
small (64 byte) transfers by unconfined tasks.

DEFINE_AUDIT_SK() in aa_label_sk_perm() should not be performed
unconditionally, rather only when the label is confined.

netperf-tcp
                            56974a6fc^              56974a6fc
Min       64         563.48 (   0.00%)      531.17 (  -5.73%)
Min       128       1056.92 (   0.00%)      999.44 (  -5.44%)
Min       256       1945.95 (   0.00%)     1867.97 (  -4.01%)
Min       1024      6761.40 (   0.00%)     6364.23 (  -5.87%)
Min       2048     11110.53 (   0.00%)    10606.20 (  -4.54%)
Min       3312     13692.67 (   0.00%)    13158.41 (  -3.90%)
Min       4096     14926.29 (   0.00%)    14457.46 (  -3.14%)
Min       8192     18399.34 (   0.00%)    18091.65 (  -1.67%)
Min       16384    21384.13 (   0.00%)    21158.05 (  -1.06%)
Hmean     64         564.96 (   0.00%)      534.38 (  -5.41%)
Hmean     128       1064.42 (   0.00%)     1010.12 (  -5.10%)
Hmean     256       1965.85 (   0.00%)     1879.16 (  -4.41%)
Hmean     1024      6839.77 (   0.00%)     6478.70 (  -5.28%)
Hmean     2048     11154.80 (   0.00%)    10671.13 (  -4.34%)
Hmean     3312     13838.12 (   0.00%)    13249.01 (  -4.26%)
Hmean     4096     15009.99 (   0.00%)    14561.36 (  -2.99%)
Hmean     8192     18975.57 (   0.00%)    18326.54 (  -3.42%)
Hmean     16384    21440.44 (   0.00%)    21324.59 (  -0.54%)
Stddev    64           1.24 (   0.00%)        2.85 (-130.64%)
Stddev    128          4.51 (   0.00%)        6.53 ( -44.84%)
Stddev    256         11.67 (   0.00%)        8.50 (  27.16%)
Stddev    1024        48.33 (   0.00%)       75.07 ( -55.34%)
Stddev    2048        54.82 (   0.00%)       65.16 ( -18.86%)
Stddev    3312       153.57 (   0.00%)       56.29 (  63.35%)
Stddev    4096       100.25 (   0.00%)       88.50 (  11.72%)
Stddev    8192       358.13 (   0.00%)      169.99 (  52.54%)
Stddev    16384       43.99 (   0.00%)      141.82 (-222.39%)

Signed-off-by: Tony Jones <tonyj@suse.de>
Fixes: 56974a6fcfef ("apparmor: add base infastructure for socket
mediation")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/net.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/security/apparmor/net.c b/security/apparmor/net.c
index bb24cfa0a164c..d5d72dd1ca1f9 100644
--- a/security/apparmor/net.c
+++ b/security/apparmor/net.c
@@ -146,17 +146,20 @@ int aa_af_perm(struct aa_label *label, const char *op, u32 request, u16 family,
 static int aa_label_sk_perm(struct aa_label *label, const char *op, u32 request,
 			    struct sock *sk)
 {
-	struct aa_profile *profile;
-	DEFINE_AUDIT_SK(sa, op, sk);
+	int error = 0;
 
 	AA_BUG(!label);
 	AA_BUG(!sk);
 
-	if (unconfined(label))
-		return 0;
+	if (!unconfined(label)) {
+		struct aa_profile *profile;
+		DEFINE_AUDIT_SK(sa, op, sk);
 
-	return fn_for_each_confined(label, profile,
-			aa_profile_af_sk_perm(profile, &sa, request, sk));
+		error = fn_for_each_confined(label, profile,
+			    aa_profile_af_sk_perm(profile, &sa, request, sk));
+	}
+
+	return error;
 }
 
 int aa_sk_perm(const char *op, u32 request, struct sock *sk)
-- 
2.20.1



