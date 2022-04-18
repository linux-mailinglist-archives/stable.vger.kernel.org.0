Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 942ED505258
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbiDRMlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240810AbiDRMji (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:39:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE13B20;
        Mon, 18 Apr 2022 05:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7017B80EC1;
        Mon, 18 Apr 2022 12:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C20C385A7;
        Mon, 18 Apr 2022 12:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285044;
        bh=8/1RHy4MdpZjC7sA0dq68BKq+gTwySVBh9ogwJc4L54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jnJVWwO+94szZmtoEVf0M0ZX7yobzN6gy1wP2pVsLNohilkRbPAZ26pb8krIhzwMO
         K6E4lVKb0kmqi1PnIkLCGanvYAq66RqkJ3mbWy6C7njqSzZfRpF/EV/TXi2DJ3lr31
         LVuOJftmQzlTqySVwK3ap1RGS8Q2TADIY8F1TluY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/189] drm/msm: Add missing put_task_struct() in debugfs path
Date:   Mon, 18 Apr 2022 14:11:16 +0200
Message-Id: <20220418121202.100734649@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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
index cb52ac01e512..d280dd64744d 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -937,6 +937,7 @@ void msm_gem_describe(struct drm_gem_object *obj, struct seq_file *m,
 					get_pid_task(aspace->pid, PIDTYPE_PID);
 				if (task) {
 					comm = kstrdup(task->comm, GFP_KERNEL);
+					put_task_struct(task);
 				} else {
 					comm = NULL;
 				}
-- 
2.35.1



