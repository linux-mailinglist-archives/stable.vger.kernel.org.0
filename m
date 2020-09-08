Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6374A2613A4
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 17:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbgIHPhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 11:37:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730542AbgIHPfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:35:50 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 092E5224D3;
        Tue,  8 Sep 2020 15:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579299;
        bh=hJ4CKVWnrnDzcY+E+SwF6btxG/3tO217+leRyRg10yA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E+jlx5tP/tF0YDuM3apBu5VqUBedzjHbOC2zvMzDPzrBBNEeANugV/S1OwGRbXjSV
         vm+zm1rdvgGXlPPPJxRjUOkdx69xB3U1f5yWnLVzXQqNb17ecnp3eT3kVMnxvMjZmA
         4CLvtZ8tCPQlMhD/Qu3ofdsr81eRh239h2JIqkic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vineeth Pillai <viremana@linux.microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 020/186] hv_utils: return error if host timesysnc update is stale
Date:   Tue,  8 Sep 2020 17:22:42 +0200
Message-Id: <20200908152242.638237609@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vineeth Pillai <viremana@linux.microsoft.com>

[ Upstream commit 90b125f4cd2697f949f5877df723a0b710693dd0 ]

If for any reason, host timesync messages were not processed by
the guest, hv_ptp_gettime() returns a stale value and the
caller (clock_gettime, PTP ioctl etc) has no means to know this
now. Return an error so that the caller knows about this.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20200821152523.99364-1-viremana@linux.microsoft.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/hv_util.c | 46 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 92ee0fe4c919e..1f86e8d9b018d 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -282,26 +282,52 @@ static struct {
 	spinlock_t			lock;
 } host_ts;
 
-static struct timespec64 hv_get_adj_host_time(void)
+static inline u64 reftime_to_ns(u64 reftime)
 {
-	struct timespec64 ts;
-	u64 newtime, reftime;
+	return (reftime - WLTIMEDELTA) * 100;
+}
+
+/*
+ * Hard coded threshold for host timesync delay: 600 seconds
+ */
+static const u64 HOST_TIMESYNC_DELAY_THRESH = 600 * (u64)NSEC_PER_SEC;
+
+static int hv_get_adj_host_time(struct timespec64 *ts)
+{
+	u64 newtime, reftime, timediff_adj;
 	unsigned long flags;
+	int ret = 0;
 
 	spin_lock_irqsave(&host_ts.lock, flags);
 	reftime = hv_read_reference_counter();
-	newtime = host_ts.host_time + (reftime - host_ts.ref_time);
-	ts = ns_to_timespec64((newtime - WLTIMEDELTA) * 100);
+
+	/*
+	 * We need to let the caller know that last update from host
+	 * is older than the max allowable threshold. clock_gettime()
+	 * and PTP ioctl do not have a documented error that we could
+	 * return for this specific case. Use ESTALE to report this.
+	 */
+	timediff_adj = reftime - host_ts.ref_time;
+	if (timediff_adj * 100 > HOST_TIMESYNC_DELAY_THRESH) {
+		pr_warn_once("TIMESYNC IC: Stale time stamp, %llu nsecs old\n",
+			     (timediff_adj * 100));
+		ret = -ESTALE;
+	}
+
+	newtime = host_ts.host_time + timediff_adj;
+	*ts = ns_to_timespec64(reftime_to_ns(newtime));
 	spin_unlock_irqrestore(&host_ts.lock, flags);
 
-	return ts;
+	return ret;
 }
 
 static void hv_set_host_time(struct work_struct *work)
 {
-	struct timespec64 ts = hv_get_adj_host_time();
 
-	do_settimeofday64(&ts);
+	struct timespec64 ts;
+
+	if (!hv_get_adj_host_time(&ts))
+		do_settimeofday64(&ts);
 }
 
 /*
@@ -622,9 +648,7 @@ static int hv_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
 
 static int hv_ptp_gettime(struct ptp_clock_info *info, struct timespec64 *ts)
 {
-	*ts = hv_get_adj_host_time();
-
-	return 0;
+	return hv_get_adj_host_time(ts);
 }
 
 static struct ptp_clock_info ptp_hyperv_info = {
-- 
2.25.1



