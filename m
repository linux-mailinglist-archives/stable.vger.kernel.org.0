Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6C05948A1
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233766AbiHOXMq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242188AbiHOXLh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:11:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D31DF2C;
        Mon, 15 Aug 2022 13:00:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 259DAB8113E;
        Mon, 15 Aug 2022 20:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A181C433C1;
        Mon, 15 Aug 2022 20:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593624;
        bh=OH96su+aiaQi23wTafGmmD8O4Crw/idqAWFIg1eYYPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CHxBVvd6uZbIwagBtRpumBlyP7jFqrNen2hGJc15wk2fMfJ2FKwrcjkJSL6Usk82a
         yW/eRcKRfpJ6m2xf/4LWJEXCUBjTWH0fd7JG7ny+Cxx6lfMEciABM+qDU8BrMYM8gC
         C3m6pRQ37/53ERhxCukCWzXhtnGba+o11CdBxrLo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Chen Yu <yu.c.chen@intel.com>, Tom Rix <trix@redhat.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0298/1157] tools/power turbostat: Fix file pointer leak
Date:   Mon, 15 Aug 2022 19:54:14 +0200
Message-Id: <20220815180451.559713255@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 5e5fd36c58d6c820f7292ee492c3731c9a104a41 ]

Currently if a fscanf fails then an early return leaks an open
file pointer. Fix this by fclosing the file before the return.
Detected using static analysis with cppcheck:

tools/power/x86/turbostat/turbostat.c:2039:3: error: Resource leak: fp [resourceLeak]

Fixes: eae97e053fe3 ("tools/power turbostat: Support thermal throttle count print")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Tom Rix <trix@redhat.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index ede31a4287a0..2e9a751af260 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2035,9 +2035,9 @@ int get_core_throt_cnt(int cpu, unsigned long long *cnt)
 	if (!fp)
 		return -1;
 	ret = fscanf(fp, "%lld", &tmp);
+	fclose(fp);
 	if (ret != 1)
 		return -1;
-	fclose(fp);
 	*cnt = tmp;
 
 	return 0;
-- 
2.35.1



