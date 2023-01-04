Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD55065D914
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbjADQV3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240013AbjADQVQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:21:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88585DF00
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:21:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F99D6179B
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD23FC433D2;
        Wed,  4 Jan 2023 16:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849274;
        bh=seVPZ3T5I644jaLESVd01A3Yw9b8ULez81zRIutoIng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XigTtB4JwNzUJ3oFCnbgATrWPSgHF7l8BuY91S7laYukLppXUhiPymfpaiiGLXs/W
         9QnRKdRcwbhTH4BD23DhqjC7AGURZliUvcuCiICrSS3X48E0Qtjg/AmL26PWnhueFb
         coZ8/Ha3L0qqLzTkdnNjOehSN28um4aFJcLRJXfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, mhiramat@kernel.org, zanussi@kernel.org,
        Zheng Yejian <zhengyejian1@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.0 070/177] tracing/hist: Fix wrong return value in parse_action_params()
Date:   Wed,  4 Jan 2023 17:06:01 +0100
Message-Id: <20230104160509.780374010@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yejian <zhengyejian1@huawei.com>

commit 2cc6a528882d0e0ccbc1bca5f95b8c963cedac54 upstream.

When number of synth fields is more than SYNTH_FIELDS_MAX,
parse_action_params() should return -EINVAL.

Link: https://lore.kernel.org/linux-trace-kernel/20221207034635.2253990-1-zhengyejian1@huawei.com

Cc: <mhiramat@kernel.org>
Cc: <zanussi@kernel.org>
Cc: stable@vger.kernel.org
Fixes: c282a386a397 ("tracing: Add 'onmatch' hist trigger action support")
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3564,6 +3564,7 @@ static int parse_action_params(struct tr
 	while (params) {
 		if (data->n_params >= SYNTH_FIELDS_MAX) {
 			hist_err(tr, HIST_ERR_TOO_MANY_PARAMS, 0);
+			ret = -EINVAL;
 			goto out;
 		}
 


