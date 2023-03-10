Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D68B46B4AF7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234277AbjCJP2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234325AbjCJP2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:28:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7344810A4C5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:17:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB30F60F55
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1685C4339C;
        Fri, 10 Mar 2023 15:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461380;
        bh=Ga4cjeItZzAvaKTrpuRHK60VTRjWvgqJOO+hwJ2/SFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vdWElNmm536c+fRKyvoto4872ziTRzS0zW5KKMLkXDxE1B5Cc4gb6lQCx1y+vHreo
         PZNZD41Df1/qBAy+iDpAgZU3pjgGkzgkpbdr7pluU1a1ie7eXwRAhuaH0NgZnDXLuE
         H+qcCrPd1JjG1CAirFFKdpuhD7luRPcvLzQJqRuQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/136] kernel/fail_function: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:44:00 +0100
Message-Id: <20230310133710.781863114@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 2bb3669f576559db273efe49e0e69f82450efbca ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20230202151633.2310897-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fail_function.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/fail_function.c b/kernel/fail_function.c
index 60dc825ecc2b3..d81ec84765811 100644
--- a/kernel/fail_function.c
+++ b/kernel/fail_function.c
@@ -163,10 +163,7 @@ static void fei_debugfs_add_attr(struct fei_attr *attr)
 
 static void fei_debugfs_remove_attr(struct fei_attr *attr)
 {
-	struct dentry *dir;
-
-	dir = debugfs_lookup(attr->kp.symbol_name, fei_debugfs_dir);
-	debugfs_remove_recursive(dir);
+	debugfs_lookup_and_remove(attr->kp.symbol_name, fei_debugfs_dir);
 }
 
 static int fei_kprobe_handler(struct kprobe *kp, struct pt_regs *regs)
-- 
2.39.2



