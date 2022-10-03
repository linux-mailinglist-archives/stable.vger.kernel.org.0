Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E263C5F29E7
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiJCH1g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:27:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbiJCH1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:27:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3734CA30;
        Mon,  3 Oct 2022 00:19:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C175B80E80;
        Mon,  3 Oct 2022 07:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D8CC433B5;
        Mon,  3 Oct 2022 07:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781383;
        bh=dQwt73vypob3Ud3sUD0Ot0P3DTkjbOJMneyPHL9kAww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fchG+VZNKRaOssstqfkFHj1zksLmZBHxPOOhwb4s+es6GQ7z/BSd+Z0Edu69WBeeU
         reX/NY9cNKVQuz6f7xCfAyN/jM85bEWhdtr5hS/76MI4b2q/oBDSenlI5dke080jnB
         7a1Odr7+wjRz6jMyDzqhJJgeTXzM+H9UlMoTUcPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Levi Yun <ppbuk5246@gmail.com>,
        SeongJae Park <sj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.19 101/101] damon/sysfs: fix possible memleak on damon_sysfs_add_target
Date:   Mon,  3 Oct 2022 09:11:37 +0200
Message-Id: <20221003070726.938515610@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070724.490989164@linuxfoundation.org>
References: <20221003070724.490989164@linuxfoundation.org>
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

From: Levi Yun <ppbuk5246@gmail.com>

commit 1c8e2349f2d033f634d046063b704b2ca6c46972 upstream.

When damon_sysfs_add_target couldn't find proper task, New allocated
damon_target structure isn't registered yet, So, it's impossible to free
new allocated one by damon_sysfs_destroy_targets.

By calling damon_add_target as soon as allocating new target, Fix this
possible memory leak.

Link: https://lkml.kernel.org/r/20220926160611.48536-1-sj@kernel.org
Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.17.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2181,13 +2181,13 @@ static int damon_sysfs_add_target(struct
 
 	if (!t)
 		return -ENOMEM;
+	damon_add_target(ctx, t);
 	if (ctx->ops.id == DAMON_OPS_VADDR ||
 			ctx->ops.id == DAMON_OPS_FVADDR) {
 		t->pid = find_get_pid(sys_target->pid);
 		if (!t->pid)
 			goto destroy_targets_out;
 	}
-	damon_add_target(ctx, t);
 	err = damon_sysfs_set_regions(t, sys_target->regions);
 	if (err)
 		goto destroy_targets_out;


