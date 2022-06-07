Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9530540DA9
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346590AbiFGSt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354433AbiFGSrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A037E35A96;
        Tue,  7 Jun 2022 11:01:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DDFB618E1;
        Tue,  7 Jun 2022 18:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 280DFC3411F;
        Tue,  7 Jun 2022 18:01:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624872;
        bh=eaLkmUmdG/Xo6u8ERxj5u85vYOJwe/jt0YfOMpJMybE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzFHY+eNPmc9zDY2+A9NYAJBQebdhDRw7Cc7DmwnrLoBjHdIFJW2j2E4YMdtRv9hx
         wH1mmex5OOXU+zZkGs5IEW14aJ/02KlltcocbEjfet2twez95hw3q5/RZ9XWIAvfg+
         yJCrg4APqJtatf+739k8/6Vetnu0moJbE6/1ERbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Zhbanov <izh1979@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 443/667] powerpc/idle: Fix return value of __setup() handler
Date:   Tue,  7 Jun 2022 19:01:48 +0200
Message-Id: <20220607164948.006264774@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit b793a01000122d2bd133ba451a76cc135b5e162c ]

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.

A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings.

Also, error return codes don't mean anything to obsolete_checksetup() --
only non-zero (usually 1) or zero. So return 1 from powersave_off().

Fixes: 302eca184fb8 ("[POWERPC] cell: use ppc_md->power_save instead of cbe_idle_loop")
Reported-by: Igor Zhbanov <izh1979@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220502192925.19954-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/idle.c b/arch/powerpc/kernel/idle.c
index 1f835539fda4..f0271daa8f6a 100644
--- a/arch/powerpc/kernel/idle.c
+++ b/arch/powerpc/kernel/idle.c
@@ -37,7 +37,7 @@ static int __init powersave_off(char *arg)
 {
 	ppc_md.power_save = NULL;
 	cpuidle_disable = IDLE_POWERSAVE_OFF;
-	return 0;
+	return 1;
 }
 __setup("powersave=off", powersave_off);
 
-- 
2.35.1



