Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1F44F3EDA
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 22:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358780AbiDEMXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356161AbiDEKXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:23:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54713BA32B;
        Tue,  5 Apr 2022 03:07:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5DCA6172B;
        Tue,  5 Apr 2022 10:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0602FC385A2;
        Tue,  5 Apr 2022 10:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153232;
        bh=ElByU9jTyxtaqxRWd0JpP6hYFDGkrLID+hTJ/RPQIHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DVDnYzdE7fOA4oqNaRbPOq0pXpFj+NRNSjVzcl1ZYwepaOycG0bf0IQFhKzRrh/G/
         1vyGDi/aNv63zKqqhCEfDVTb5DMdsGFtJ2Mebe9dRjH18wOGbV4NNSbDY4sowc6r6C
         tTDbtyCycxV8a7Jft2kb1LH8BXmJAt3S2HV+hjV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 148/599] PM: hibernate: fix __setup handler error handling
Date:   Tue,  5 Apr 2022 09:27:22 +0200
Message-Id: <20220405070303.246857642@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit ba7ffcd4c4da374b0f64666354eeeda7d3827131 ]

If an invalid value is used in "resumedelay=<seconds>", it is
silently ignored. Add a warning message and then let the __setup
handler return 1 to indicate that the kernel command line option
has been handled.

Fixes: 317cf7e5e85e3 ("PM / hibernate: convert simple_strtoul to kstrtoul")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/hibernate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index bf640fd6142a..522cb1387462 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -1323,7 +1323,7 @@ static int __init resumedelay_setup(char *str)
 	int rc = kstrtouint(str, 0, &resume_delay);
 
 	if (rc)
-		return rc;
+		pr_warn("resumedelay: bad option string '%s'\n", str);
 	return 1;
 }
 
-- 
2.34.1



