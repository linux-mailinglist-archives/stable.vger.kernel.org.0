Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42214A441E
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343727AbiAaL0X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:26:23 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56700 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377703AbiAaLYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:24:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C55261237;
        Mon, 31 Jan 2022 11:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79A8C340EE;
        Mon, 31 Jan 2022 11:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628259;
        bh=g3KRHvx21d6YBX7mUnSWSI64yk84o0QhYsXMVsF/jUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CM5zhFcQUXSdnrpGRYA8b3Lc40PGtVIjJqrT4jVh8YWM9VqT0XtL9kpdNRiTmhK+d
         EpejG0/dIgwbOBITQtIAjBluJ8/kRpTyUhEpxEhBBgfMvU8MGMeabsI3ZkEQmWc26I
         rX4d967qPBE6cwlO7vviKVhsWzk0ykzf2WbCuUsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 176/200] sch_htb: Fail on unsupported parameters when offload is requested
Date:   Mon, 31 Jan 2022 11:57:19 +0100
Message-Id: <20220131105239.464153705@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 429c3be8a5e2695b5b92a6a12361eb89eb185495 ]

The current implementation of HTB offload doesn't support some
parameters. Instead of ignoring them, actively return the EINVAL error
when they are set to non-defaults.

As this patch goes to stable, the driver API is not changed here. If
future drivers support more offload parameters, the checks can be moved
to the driver side.

Note that the buffer and cbuffer parameters are also not supported, but
the tc userspace tool assigns some default values derived from rate and
ceil, and identifying these defaults in sch_htb would be unreliable, so
they are still ignored.

Fixes: d03b195b5aa0 ("sch_htb: Hierarchical QoS hardware offload")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20220125100654.424570-1-maximmi@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 9267922ea9c37..23a9d6242429f 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1810,6 +1810,26 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	if (!hopt->rate.rate || !hopt->ceil.rate)
 		goto failure;
 
+	if (q->offload) {
+		/* Options not supported by the offload. */
+		if (hopt->rate.overhead || hopt->ceil.overhead) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the overhead parameter");
+			goto failure;
+		}
+		if (hopt->rate.mpu || hopt->ceil.mpu) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the mpu parameter");
+			goto failure;
+		}
+		if (hopt->quantum) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the quantum parameter");
+			goto failure;
+		}
+		if (hopt->prio) {
+			NL_SET_ERR_MSG(extack, "HTB offload doesn't support the prio parameter");
+			goto failure;
+		}
+	}
+
 	/* Keeping backward compatible with rate_table based iproute2 tc */
 	if (hopt->rate.linklayer == TC_LINKLAYER_UNAWARE)
 		qdisc_put_rtab(qdisc_get_rtab(&hopt->rate, tb[TCA_HTB_RTAB],
-- 
2.34.1



