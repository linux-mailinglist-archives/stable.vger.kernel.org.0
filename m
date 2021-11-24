Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7760145C526
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352888AbhKXNzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354425AbhKXNuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9EFBC63366;
        Wed, 24 Nov 2021 13:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759019;
        bh=HYIhxJ8z3Trlek4aMFlvdUNqJ5Kqbub6MW2SD73STlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Znso47sir6DC3taJg8e+uv7VxeSFs5KO1LHRCE7/USepE7pMywpzia1qpXtShYX/F
         BUudAGZmVPKK8L1UpQPkprmQdN1PW8NHhJIZSOCxT1AOnj8lM7rV73QXo/YH7+NGwS
         IHReDPnE+S313HhiyulqRXgRz6VphSeux1DSakds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/279] samples/bpf: Fix summary per-sec stats in xdp_sample_user
Date:   Wed, 24 Nov 2021 12:56:33 +0100
Message-Id: <20211124115722.435165639@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alexandr.lobakin@intel.com>

[ Upstream commit dc14ca4644f48b1cfa93631e35c28bdc011ad109 ]

sample_summary_print() uses accumulated period to calculate and display
per-sec averages. This period gets incremented by sampling interval each
time a new sample is formed, and thus equals to the number of samples
collected multiplied by this interval.

However, the totals are being calculated differently, they receive current
sample statistics already divided by the interval gotten as a difference
between sample timestamps for better precision -- in other words, they are
being incremented by the per-sec values each sample.

This leads to the excessive division of summary per-secs when interval != 1
sec. It is obvious pps couldn't become two times lower just from picking a
different sampling interval value:

  $ samples/bpf/xdp_redirect_cpu -p xdp_prognum_n1_inverse_qnum -c all
    -s -d 6 -i 1
  < snip >
    Packets received    : 2,197,230,321
    Average packets/s   : 22,887,816
    Packets redirected  : 2,197,230,472
    Average redir/s     : 22,887,817
  $ samples/bpf/xdp_redirect_cpu -p xdp_prognum_n1_inverse_qnum -c all
    -s -d 6 -i 2
  < snip >
    Packets received    : 159,566,498
    Average packets/s   : 11,397,607
    Packets redirected  : 159,566,995
    Average redir/s     : 11,397,642

This can be easily fixed by treating the divisor not as a period, but rather
as a total number of samples, and thus incrementing it by 1 instead of
interval. As a nice side effect, we can now remove so-named argument from a
couple of functions. Let us also create an "alias" for sample_output::rx_cnt::pps
named 'num' using a union since this field is used to store this number (period
previously) as well, and the resulting counter-intuitive code might've been a
reason for this bug.

Fixes: 156f886cf697 ("samples: bpf: Add basic infrastructure for XDP samples")
Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/bpf/20211111215703.690-1-alexandr.lobakin@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_sample_user.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index b32d821781990..8740838e77679 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -120,7 +120,10 @@ struct sample_output {
 		__u64 xmit;
 	} totals;
 	struct {
-		__u64 pps;
+		union {
+			__u64 pps;
+			__u64 num;
+		};
 		__u64 drop;
 		__u64 err;
 	} rx_cnt;
@@ -1322,7 +1325,7 @@ int sample_install_xdp(struct bpf_program *xdp_prog, int ifindex, bool generic,
 
 static void sample_summary_print(void)
 {
-	double period = sample_out.rx_cnt.pps;
+	double num = sample_out.rx_cnt.num;
 
 	if (sample_out.totals.rx) {
 		double pkts = sample_out.totals.rx;
@@ -1330,7 +1333,7 @@ static void sample_summary_print(void)
 		print_always("  Packets received    : %'-10llu\n",
 			     sample_out.totals.rx);
 		print_always("  Average packets/s   : %'-10.0f\n",
-			     sample_round(pkts / period));
+			     sample_round(pkts / num));
 	}
 	if (sample_out.totals.redir) {
 		double pkts = sample_out.totals.redir;
@@ -1338,7 +1341,7 @@ static void sample_summary_print(void)
 		print_always("  Packets redirected  : %'-10llu\n",
 			     sample_out.totals.redir);
 		print_always("  Average redir/s     : %'-10.0f\n",
-			     sample_round(pkts / period));
+			     sample_round(pkts / num));
 	}
 	if (sample_out.totals.drop)
 		print_always("  Rx dropped          : %'-10llu\n",
@@ -1355,7 +1358,7 @@ static void sample_summary_print(void)
 		print_always("  Packets transmitted : %'-10llu\n",
 			     sample_out.totals.xmit);
 		print_always("  Average transmit/s  : %'-10.0f\n",
-			     sample_round(pkts / period));
+			     sample_round(pkts / num));
 	}
 }
 
@@ -1422,7 +1425,7 @@ static int sample_stats_collect(struct stats_record *rec)
 	return 0;
 }
 
-static void sample_summary_update(struct sample_output *out, int interval)
+static void sample_summary_update(struct sample_output *out)
 {
 	sample_out.totals.rx += out->totals.rx;
 	sample_out.totals.redir += out->totals.redir;
@@ -1430,12 +1433,11 @@ static void sample_summary_update(struct sample_output *out, int interval)
 	sample_out.totals.drop_xmit += out->totals.drop_xmit;
 	sample_out.totals.err += out->totals.err;
 	sample_out.totals.xmit += out->totals.xmit;
-	sample_out.rx_cnt.pps += interval;
+	sample_out.rx_cnt.num++;
 }
 
 static void sample_stats_print(int mask, struct stats_record *cur,
-			       struct stats_record *prev, char *prog_name,
-			       int interval)
+			       struct stats_record *prev, char *prog_name)
 {
 	struct sample_output out = {};
 
@@ -1452,7 +1454,7 @@ static void sample_stats_print(int mask, struct stats_record *cur,
 	else if (mask & SAMPLE_DEVMAP_XMIT_CNT_MULTI)
 		stats_get_devmap_xmit_multi(cur, prev, 0, &out,
 					    mask & SAMPLE_DEVMAP_XMIT_CNT);
-	sample_summary_update(&out, interval);
+	sample_summary_update(&out);
 
 	stats_print(prog_name, mask, cur, prev, &out);
 }
@@ -1495,7 +1497,7 @@ static void swap(struct stats_record **a, struct stats_record **b)
 }
 
 static int sample_timer_cb(int timerfd, struct stats_record **rec,
-			   struct stats_record **prev, int interval)
+			   struct stats_record **prev)
 {
 	char line[64] = "Summary";
 	int ret;
@@ -1524,7 +1526,7 @@ static int sample_timer_cb(int timerfd, struct stats_record **rec,
 		snprintf(line, sizeof(line), "%s->%s", f ?: "?", t ?: "?");
 	}
 
-	sample_stats_print(sample_mask, *rec, *prev, line, interval);
+	sample_stats_print(sample_mask, *rec, *prev, line);
 	return 0;
 }
 
@@ -1579,7 +1581,7 @@ int sample_run(int interval, void (*post_cb)(void *), void *ctx)
 		if (pfd[0].revents & POLLIN)
 			ret = sample_signal_cb();
 		else if (pfd[1].revents & POLLIN)
-			ret = sample_timer_cb(timerfd, &rec, &prev, interval);
+			ret = sample_timer_cb(timerfd, &rec, &prev);
 
 		if (ret)
 			break;
-- 
2.33.0



