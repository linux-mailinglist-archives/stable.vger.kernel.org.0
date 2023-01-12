Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06551667772
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240025AbjALOnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239811AbjALOmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:42:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B2D758F92
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:32:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0686762038
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:32:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA418C433EF;
        Thu, 12 Jan 2023 14:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673533932;
        bh=xxgQ1qMIt6GbL0CgYCSBLQfoj8CkXvgdaTjaf6KfTOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LasO9TnP16UwT0WEdsc8OXLdEDzsFM2FHdVpyMO2T2xneA7hmj43PWcth0SjGKKJD
         XUAyhYLsp9SI2W+CiJjvAOcFUbnCib5eVRirYAstuJSLGxQUalupPFP/6QycLezvzC
         FBwY4S2WN6qcrpFGPtfXMZ8DOQfsD+DXhN9IqCdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, mhiramat@kernel.org, zanussi@kernel.org,
        Zheng Yejian <zhengyejian1@huawei.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.10 640/783] tracing/hist: Fix wrong return value in parse_action_params()
Date:   Thu, 12 Jan 2023 14:55:56 +0100
Message-Id: <20230112135553.977603631@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
@@ -3115,6 +3115,7 @@ static int parse_action_params(struct tr
 	while (params) {
 		if (data->n_params >= SYNTH_FIELDS_MAX) {
 			hist_err(tr, HIST_ERR_TOO_MANY_PARAMS, 0);
+			ret = -EINVAL;
 			goto out;
 		}
 


