Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBAA5415F5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359844AbiFGUnl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377340AbiFGUdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:33:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00BA1E3B3B;
        Tue,  7 Jun 2022 11:34:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7776B8237F;
        Tue,  7 Jun 2022 18:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D186C385A2;
        Tue,  7 Jun 2022 18:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626895;
        bh=rErfl5eEDB3p0z9t/ZqOeXDL0w1kyG5P6kY7CDdLFXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szlEcjpq28qvBDOcirmqelvTIFvpFX00O2ozZQYoMfV64hLb7JAgA0q4vTqoKohsd
         AbcV1C1RZeQZR1gaVUTpTgI2avqhCN+NaM9f50O6Bwyw3Ulb/LnSSoMYgNJtuGStvT
         y/tWFs7jUoKlW6SMTwYoKoAssFe9Mm9uXfWFpwnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Zhbanov <izh1979@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 516/772] powerpc/idle: Fix return value of __setup() handler
Date:   Tue,  7 Jun 2022 19:01:48 +0200
Message-Id: <20220607165004.185799673@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
index 4ad79eb638c6..77cd4c5a2d63 100644
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



