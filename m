Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400C46AF130
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjCGSlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:41:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbjCGSkO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:40:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CB6AB08E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:31:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6FB8B819CD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED22C4339E;
        Tue,  7 Mar 2023 18:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213742;
        bh=6GU7YqwBGP6km5FP8YQtlRBF9Ucct22hhgFPrY1uTIM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTYrEYpTeaF4hmTfKzgSa61w69x2iM0hvk9GTW8FRyMCXc2khgzBqxfUGwWah0VAg
         UZGgEy3vTM+UL2LIem4i5RHLoee5JTdtU039THi05fwwxkn78g5ZBNCBxCN/l64q1A
         g7XVXErUJI+RMNlyp24oRSGd3WxqhXfuhyYFIU9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhang Rui <rui.zhang@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 574/885] tools/power/x86/intel-speed-select: Add Emerald Rapid quirk
Date:   Tue,  7 Mar 2023 17:58:28 +0100
Message-Id: <20230307170027.339571355@linuxfoundation.org>
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

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 61f9fdcdcd01f9a996b6db4e7092fcdfe8414ad5 ]

Need memory frequency quirk as Sapphire Rapids in Emerald Rapids.
So add Emerald Rapids CPU model check in is_spr_platform().

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
[srinivas.pandruvada@linux.intel.com: Subject, changelog and code edits]
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index a160bad291eb7..be3668d37d654 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -110,7 +110,7 @@ int is_skx_based_platform(void)
 
 int is_spr_platform(void)
 {
-	if (cpu_model == 0x8F)
+	if (cpu_model == 0x8F || cpu_model == 0xCF)
 		return 1;
 
 	return 0;
-- 
2.39.2



