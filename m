Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1FA505046
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238496AbiDRMXy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238500AbiDRMWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:22:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43F61DA60;
        Mon, 18 Apr 2022 05:17:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4143C60F01;
        Mon, 18 Apr 2022 12:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C576C385A7;
        Mon, 18 Apr 2022 12:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284265;
        bh=umFTfXUjPTfRuZWvVFLcMfF4nfy/Jnjf1wlhjM1N+Fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZgIiIjWX8IbD0O626ofbNZByvszfVs62hwh/a+1r60YBVZki4tEossx0WlMlF690
         Tvmw2bZcA9RRZ44SWFUgzO2gqYnN25ydY2lLUVsM+sYXFvgtzY0DztErSDDlQL3k4m
         bQ13Qcz+AStzgQ5LzUrWM9gRBjXxpWwUviOhtQzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 058/219] drm/msm: Add missing put_task_struct() in debugfs path
Date:   Mon, 18 Apr 2022 14:10:27 +0200
Message-Id: <20220418121206.991520017@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121203.462784814@linuxfoundation.org>
References: <20220418121203.462784814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit ac3e4f42d5ec459f701743debd9c1ad2f2247402 ]

Fixes: 25faf2f2e065 ("drm/msm: Show process names in gem_describe")
Signed-off-by: Rob Clark <robdclark@chromium.org>
Link: https://lore.kernel.org/r/20220317184550.227991-1-robdclark@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index 02b9ae65a96a..a4f61972667b 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -926,6 +926,7 @@ void msm_gem_describe(struct drm_gem_object *obj, struct seq_file *m,
 					get_pid_task(aspace->pid, PIDTYPE_PID);
 				if (task) {
 					comm = kstrdup(task->comm, GFP_KERNEL);
+					put_task_struct(task);
 				} else {
 					comm = NULL;
 				}
-- 
2.35.1



