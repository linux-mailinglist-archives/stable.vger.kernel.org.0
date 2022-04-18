Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7BC5053D2
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239009AbiDRNBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241275AbiDRM6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:58:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06712275CB;
        Mon, 18 Apr 2022 05:38:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58232B80EDD;
        Mon, 18 Apr 2022 12:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7DAC385A1;
        Mon, 18 Apr 2022 12:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285530;
        bh=7pljjTtnQK7vSOC4UMs/AsmTYE4EvmJi4DnLDl8Bdgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kqgN2cCF9d4QE1+4rePZFDQAn+z6Vc5UM67b+KGIEfmo5Qn3M68DMzQ5MImoTh/tH
         XL8fQjaH7AL6bd7Ja+j2Yme4KREo43wgXhiTxhoqNBQQoM5265RFwLLc5eCARwrPzw
         DrkLw0lrxPPGbIfZCfYeuTYJ1M6WQR5dC0BMO8a0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/105] drm/msm: Add missing put_task_struct() in debugfs path
Date:   Mon, 18 Apr 2022 14:12:09 +0200
Message-Id: <20220418121145.657156428@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121145.140991388@linuxfoundation.org>
References: <20220418121145.140991388@linuxfoundation.org>
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
index 819567e40565..9c05bf6c4551 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -849,6 +849,7 @@ void msm_gem_describe(struct drm_gem_object *obj, struct seq_file *m)
 					get_pid_task(aspace->pid, PIDTYPE_PID);
 				if (task) {
 					comm = kstrdup(task->comm, GFP_KERNEL);
+					put_task_struct(task);
 				} else {
 					comm = NULL;
 				}
-- 
2.35.1



