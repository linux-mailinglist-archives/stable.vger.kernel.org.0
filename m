Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C778D586962
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbiHAMCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:02:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbiHAMAj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:00:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDB24E857;
        Mon,  1 Aug 2022 04:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8807761326;
        Mon,  1 Aug 2022 11:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9344BC433C1;
        Mon,  1 Aug 2022 11:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354784;
        bh=Pk5xfaZveeo4I7PJdyybX2fZfA1CFcunfBUWgqk6NJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WAHp3Yp9L7/Y2JRVQIoF01vFPn7Rt1mOOPramuRw1NO9h3LHrv9eonVdW9sHXtHYT
         m8f0tWVpmAkJjDWX0HIMGzoQ6EX1WS8aG1QzLTPQJB/7ai2eVAU22xgHP+y089C4+U
         CjoNBswF/vGPtP+3uj5fIr/54pRRBnQc3Kd8Lnnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 19/69] tcp: Fix data-races around sysctl_tcp_no_ssthresh_metrics_save.
Date:   Mon,  1 Aug 2022 13:46:43 +0200
Message-Id: <20220801114135.282857286@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

commit ab1ba21b523ab496b1a4a8e396333b24b0a18f9a upstream.

While reading sysctl_tcp_no_ssthresh_metrics_save, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 65e6d90168f3 ("net-tcp: Disable TCP ssthresh metrics cache by default")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_metrics.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -385,7 +385,7 @@ void tcp_update_metrics(struct sock *sk)
 
 	if (tcp_in_initial_slowstart(tp)) {
 		/* Slow start still did not finish. */
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 			if (val && (tcp_snd_cwnd(tp) >> 1) > val)
@@ -401,7 +401,7 @@ void tcp_update_metrics(struct sock *sk)
 	} else if (!tcp_in_slow_start(tp) &&
 		   icsk->icsk_ca_state == TCP_CA_Open) {
 		/* Cong. avoidance phase, cwnd is reliable. */
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH))
 			tcp_metric_set(tm, TCP_METRIC_SSTHRESH,
 				       max(tcp_snd_cwnd(tp) >> 1, tp->snd_ssthresh));
@@ -418,7 +418,7 @@ void tcp_update_metrics(struct sock *sk)
 			tcp_metric_set(tm, TCP_METRIC_CWND,
 				       (val + tp->snd_ssthresh) >> 1);
 		}
-		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
+		if (!READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 			if (val && tp->snd_ssthresh > val)
@@ -463,7 +463,7 @@ void tcp_init_metrics(struct sock *sk)
 	if (tcp_metric_locked(tm, TCP_METRIC_CWND))
 		tp->snd_cwnd_clamp = tcp_metric_get(tm, TCP_METRIC_CWND);
 
-	val = net->ipv4.sysctl_tcp_no_ssthresh_metrics_save ?
+	val = READ_ONCE(net->ipv4.sysctl_tcp_no_ssthresh_metrics_save) ?
 	      0 : tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
 	if (val) {
 		tp->snd_ssthresh = val;


