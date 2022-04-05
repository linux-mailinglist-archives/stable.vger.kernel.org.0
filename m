Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48114F2BC9
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243090AbiDEJiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238809AbiDEJFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:05:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3CD43818F;
        Tue,  5 Apr 2022 01:56:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3624614E4;
        Tue,  5 Apr 2022 08:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE26DC385A1;
        Tue,  5 Apr 2022 08:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148968;
        bh=7Vx2WvST/3UetrRUM4JsvOUg6Uksvk+kePktchHbQIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rJWs6uZdTxd0LEiXyYq3W4eaZ6olw98GsXL/V+KUovdENpaTB8OsAaf3GHqT68MYe
         ONeab5eQmhAOfVQtWGNiGIs0AKjMAhqWh1Lj5rHF3KIto4ShSImV/MeWU60+b6tY+U
         DXU7X7fWGJGlFIjrTttX97d6dnUtKRwrJJigalJ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Igor Zhbanov <i.zhbanov@omprussia.ru>,
        James Morris <jmorris@namei.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        tomoyo-dev-en@lists.osdn.me, "Serge E. Hallyn" <serge@hallyn.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0545/1017] TOMOYO: fix __setup handlers return values
Date:   Tue,  5 Apr 2022 09:24:18 +0200
Message-Id: <20220405070410.464004240@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

[ Upstream commit 39844b7e3084baecef52d1498b5fa81afa2cefa9 ]

__setup() handlers should return 1 if the parameter is handled.
Returning 0 causes the entire string to be added to init's
environment strings (limited to 32 strings), unnecessarily polluting it.

Using the documented strings "TOMOYO_loader=string1" and
"TOMOYO_trigger=string2" causes an Unknown parameter message:
  Unknown kernel command line parameters
    "BOOT_IMAGE=/boot/bzImage-517rc5 TOMOYO_loader=string1 \
     TOMOYO_trigger=string2", will be passed to user space.

and these strings are added to init's environment string space:
  Run /sbin/init as init process
    with arguments:
     /sbin/init
    with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc5
     TOMOYO_loader=string1
     TOMOYO_trigger=string2

With this change, these __setup handlers act as expected,
and init's environment is not polluted with these strings.

Fixes: 0e4ae0e0dec63 ("TOMOYO: Make several options configurable.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: https://lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: James Morris <jmorris@namei.org>
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: tomoyo-dev-en@lists.osdn.me
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/tomoyo/load_policy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/tomoyo/load_policy.c b/security/tomoyo/load_policy.c
index 3445ae6fd479..363b65be87ab 100644
--- a/security/tomoyo/load_policy.c
+++ b/security/tomoyo/load_policy.c
@@ -24,7 +24,7 @@ static const char *tomoyo_loader;
 static int __init tomoyo_loader_setup(char *str)
 {
 	tomoyo_loader = str;
-	return 0;
+	return 1;
 }
 
 __setup("TOMOYO_loader=", tomoyo_loader_setup);
@@ -64,7 +64,7 @@ static const char *tomoyo_trigger;
 static int __init tomoyo_trigger_setup(char *str)
 {
 	tomoyo_trigger = str;
-	return 0;
+	return 1;
 }
 
 __setup("TOMOYO_trigger=", tomoyo_trigger_setup);
-- 
2.34.1



