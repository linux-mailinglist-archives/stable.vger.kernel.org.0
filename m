Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FB0157894
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728968AbgBJNIs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:08:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:37124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728915AbgBJMj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:28 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 123042051A;
        Mon, 10 Feb 2020 12:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338368;
        bh=Jq4Jre2q6+Goe1YtcWIF0yCjvk5dbcstp82dam4pzgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=quhLuq1UUjTEZYZSmsX27RyZONmYnL5nnQVJV5kmXwnyWG16HPAoxpSZ2VC2xk4Ek
         QRYz86XOb70761PzWTzyjk4AF+Z6nRTBJQbqjZ8+I/4FVRxQinzAKGN5/WszFR0P5A
         8UJsRo6Ybb/KOknThS+Y6cm/WBtNSgkikEB9vnjI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+08f3e9d26e5541e1ecf2@syzkaller.appspotmail.com,
        Marco Elver <elver@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 5.5 036/367] srcu: Apply *_ONCE() to ->srcu_last_gp_end
Date:   Mon, 10 Feb 2020 04:29:09 -0800
Message-Id: <20200210122427.307360659@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

commit 844a378de3372c923909681706d62336d702531e upstream.

The ->srcu_last_gp_end field is accessed from any CPU at any time
by synchronize_srcu(), so non-initialization references need to use
READ_ONCE() and WRITE_ONCE().  This commit therefore makes that change.

Reported-by: syzbot+08f3e9d26e5541e1ecf2@syzkaller.appspotmail.com
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/rcu/srcutree.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/kernel/rcu/srcutree.c
+++ b/kernel/rcu/srcutree.c
@@ -530,7 +530,7 @@ static void srcu_gp_end(struct srcu_stru
 	idx = rcu_seq_state(ssp->srcu_gp_seq);
 	WARN_ON_ONCE(idx != SRCU_STATE_SCAN2);
 	cbdelay = srcu_get_delay(ssp);
-	ssp->srcu_last_gp_end = ktime_get_mono_fast_ns();
+	WRITE_ONCE(ssp->srcu_last_gp_end, ktime_get_mono_fast_ns());
 	rcu_seq_end(&ssp->srcu_gp_seq);
 	gpseq = rcu_seq_current(&ssp->srcu_gp_seq);
 	if (ULONG_CMP_LT(ssp->srcu_gp_seq_needed_exp, gpseq))
@@ -762,6 +762,7 @@ static bool srcu_might_be_idle(struct sr
 	unsigned long flags;
 	struct srcu_data *sdp;
 	unsigned long t;
+	unsigned long tlast;
 
 	/* If the local srcu_data structure has callbacks, not idle.  */
 	local_irq_save(flags);
@@ -780,9 +781,9 @@ static bool srcu_might_be_idle(struct sr
 
 	/* First, see if enough time has passed since the last GP. */
 	t = ktime_get_mono_fast_ns();
+	tlast = READ_ONCE(ssp->srcu_last_gp_end);
 	if (exp_holdoff == 0 ||
-	    time_in_range_open(t, ssp->srcu_last_gp_end,
-			       ssp->srcu_last_gp_end + exp_holdoff))
+	    time_in_range_open(t, tlast, tlast + exp_holdoff))
 		return false; /* Too soon after last GP. */
 
 	/* Next, check for probable idleness. */


