Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C207F4F2FB1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242212AbiDEIhP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238750AbiDEITV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:19:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1296072479;
        Tue,  5 Apr 2022 01:09:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEB4FB81A37;
        Tue,  5 Apr 2022 08:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198EFC385A1;
        Tue,  5 Apr 2022 08:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146163;
        bh=VKULRthVlARqIBKJxJT2Bjr2YzjzP/RKQZuE96zqOAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3ixLPA76aNDldICDPNfkPBxrET5DdzIBHzNvDflW0qb06jbjJRAHckArjg/ssq1o
         u0FNluG7NeGn3C8+pcn/e8N3NdGKIY8xoU56a1O1u5vyOlMrEyyAzFw6Pidqx3Ww79
         AnrvUoMp3B/Fa5n7gbV9qzb9kq1Xu9m5XssWfIbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0664/1126] samples/bpf, xdpsock: Fix race when running for fix duration of time
Date:   Tue,  5 Apr 2022 09:23:31 +0200
Message-Id: <20220405070427.118455998@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Söderlund <niklas.soderlund@corigine.com>

[ Upstream commit 8fa42d78f6354bb96ad3a079dcbef528ca9fa9e0 ]

When running xdpsock for a fix duration of time before terminating
using --duration=<n>, there is a race condition that may cause xdpsock
to terminate immediately.

When running for a fixed duration of time the check to determine when to
terminate execution is in is_benchmark_done() and is being executed in
the context of the poller thread,

    if (opt_duration > 0) {
            unsigned long dt = (get_nsecs() - start_time);

            if (dt >= opt_duration)
                    benchmark_done = true;
    }

However start_time is only set after the poller thread have been
created. This leaves a small window when the poller thread is starting
and calls is_benchmark_done() for the first time that start_time is not
yet set. In that case start_time have its initial value of 0 and the
duration check fails as it do not correlate correctly for the
applications start time and immediately sets benchmark_done which in
turn terminates the xdpsock application.

Fix this by setting start_time before creating the poller thread.

Fixes: d3f11b018f6c ("samples/bpf: xdpsock: Add duration option to specify how long to run")
Signed-off-by: Niklas Söderlund <niklas.soderlund@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20220315102948.466436-1-niklas.soderlund@corigine.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdpsock_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index aa50864e4415..9f3446af50ce 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -1984,15 +1984,15 @@ int main(int argc, char **argv)
 
 	setlocale(LC_ALL, "");
 
+	prev_time = get_nsecs();
+	start_time = prev_time;
+
 	if (!opt_quiet) {
 		ret = pthread_create(&pt, NULL, poller, NULL);
 		if (ret)
 			exit_with_error(ret);
 	}
 
-	prev_time = get_nsecs();
-	start_time = prev_time;
-
 	/* Configure sched priority for better wake-up accuracy */
 	memset(&schparam, 0, sizeof(schparam));
 	schparam.sched_priority = opt_schprio;
-- 
2.34.1



