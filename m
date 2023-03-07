Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEE76AEEE1
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbjCGSRq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:17:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjCGSR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:17:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48110A80C9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:12:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28DE7614DF
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14398C433EF;
        Tue,  7 Mar 2023 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212738;
        bh=OZdwRaIXCowRIk33gj614RkTEgt+m/8idpbUsFriHok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TECTB+pkZ1mtajU1X1waaXS4SHK3LOuhjPrTZh0GICfqpf9fHUag60BcVwCmjji1
         rbM43BlFWXd6JVYMjalXkX0YQAdC0ExUG5xvuCCXG+v5/Cptb+F/ieu18tephAUIhQ
         XkYh4n3Gu6/FJKTzxIdAG9IwQM4zPq/67+c6LcnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/885] tools/lib/thermal: Fix thermal_sampling_exit()
Date:   Tue,  7 Mar 2023 17:52:55 +0100
Message-Id: <20230307170012.483517551@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,TVD_SPACE_RATIO,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Guittot <vincent.guittot@linaro.org>

[ Upstream commit a29cbd76aaf63f5493e962aa2fbaadcdc4615143 ]

thermal_sampling_init() suscribes to THERMAL_GENL_SAMPLING_GROUP_NAME group
so thermal_sampling_exit() should unsubscribe from the same group.

Fixes: 47c4b0de080a ("tools/lib/thermal: Add a thermal library")
Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230202102812.453357-1-vincent.guittot@linaro.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/thermal/sampling.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/thermal/sampling.c b/tools/lib/thermal/sampling.c
index ee818f4e9654d..70577423a9f0c 100644
--- a/tools/lib/thermal/sampling.c
+++ b/tools/lib/thermal/sampling.c
@@ -54,7 +54,7 @@ int thermal_sampling_fd(struct thermal_handler *th)
 thermal_error_t thermal_sampling_exit(struct thermal_handler *th)
 {
 	if (nl_unsubscribe_thermal(th->sk_sampling, th->cb_sampling,
-				   THERMAL_GENL_EVENT_GROUP_NAME))
+				   THERMAL_GENL_SAMPLING_GROUP_NAME))
 		return THERMAL_ERROR;
 
 	nl_thermal_disconnect(th->sk_sampling, th->cb_sampling);
-- 
2.39.2



