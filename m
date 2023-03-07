Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC706AEF6C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbjCGSXd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjCGSXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:23:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494FD3C2C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:17:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 091FAB81851
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:17:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3356EC4339B;
        Tue,  7 Mar 2023 18:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213070;
        bh=LEy2NUR4IdIAeTTVC+T0c/xKK8EYO/cdcUB77P4ccG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7hph50iU9SKzp8cDhGKb7KfKXtoyifob0zelT4unrkRVEgPX9gJEyyG1TwxsrgAa
         sJ7qEzohpisw6wgS+uBdfr2Ot7ALYPy1YrN9JVRkS7F/Y4OlhFwzXhpHht1Ltsn0ld
         m6SlX5L7ZCGcpYoHBRrqcUXWC7VTeSNNA3YYTcwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andreas Ziegler <br015@umbiko.net>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 389/885] tools/tracing/rtla: osnoise_hist: use total duration for average calculation
Date:   Tue,  7 Mar 2023 17:55:23 +0100
Message-Id: <20230307170019.259355383@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Ziegler <br015@umbiko.net>

[ Upstream commit fe137a4fe0e77eb95396cfc5c3dd7df404421aa4 ]

Sampled durations must be weighted by observed quantity, to arrive at a correct
average duration value.

Perform calculation of total duration by summing (duration * count).

Link: https://lkml.kernel.org/r/20230103103400.275566-2-br015@umbiko.net

Fixes: 829a6c0b5698 ("rtla/osnoise: Add the hist mode")

Signed-off-by: Andreas Ziegler <br015@umbiko.net>
Acked-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/src/osnoise_hist.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/src/osnoise_hist.c b/tools/tracing/rtla/src/osnoise_hist.c
index 5d7ea479ac89f..fe34452fc4ec0 100644
--- a/tools/tracing/rtla/src/osnoise_hist.c
+++ b/tools/tracing/rtla/src/osnoise_hist.c
@@ -121,6 +121,7 @@ static void osnoise_hist_update_multiple(struct osnoise_tool *tool, int cpu,
 {
 	struct osnoise_hist_params *params = tool->params;
 	struct osnoise_hist_data *data = tool->data;
+	unsigned long long total_duration;
 	int entries = data->entries;
 	int bucket;
 	int *hist;
@@ -131,10 +132,12 @@ static void osnoise_hist_update_multiple(struct osnoise_tool *tool, int cpu,
 	if (data->bucket_size)
 		bucket = duration / data->bucket_size;
 
+	total_duration = duration * count;
+
 	hist = data->hist[cpu].samples;
 	data->hist[cpu].count += count;
 	update_min(&data->hist[cpu].min_sample, &duration);
-	update_sum(&data->hist[cpu].sum_sample, &duration);
+	update_sum(&data->hist[cpu].sum_sample, &total_duration);
 	update_max(&data->hist[cpu].max_sample, &duration);
 
 	if (bucket < entries)
-- 
2.39.2



