Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23889548BE3
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352439AbiFMLRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351692AbiFMLQf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:16:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C30413F70;
        Mon, 13 Jun 2022 03:40:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5FB1610A0;
        Mon, 13 Jun 2022 10:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA86BC3411E;
        Mon, 13 Jun 2022 10:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116799;
        bh=zeFraWsJc3yTSgQb3pzJ/B6qVY2pED3bey0qvc0sm3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LN+lNYhpCEG8hK85bOmQcvUSUx8TfyjtYjLEvJzN9DXftqNy8enn18lhNML39/VGT
         kZ321/QbuKClOXPqfFTIztF+ghei4Nle3al6jhU/DkQsumHDqdDwQCKFw9bRs+ueUH
         VHd1fvcUORz7XqTwcoiluTdGSl7vy7v6RLB4Ze3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Zhbanov <izh1979@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 181/411] powerpc/4xx/cpm: Fix return value of __setup() handler
Date:   Mon, 13 Jun 2022 12:07:34 +0200
Message-Id: <20220613094934.087002905@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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

[ Upstream commit 5bb99fd4090fe1acfdb90a97993fcda7f8f5a3d6 ]

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.

A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings.

Also, error return codes don't mean anything to obsolete_checksetup() --
only non-zero (usually 1) or zero. So return 1 from cpm_powersave_off().

Fixes: d164f6d4f910 ("powerpc/4xx: Add suspend and idle support")
Reported-by: Igor Zhbanov <izh1979@gmail.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220502192941.20955-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/4xx/cpm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/4xx/cpm.c b/arch/powerpc/platforms/4xx/cpm.c
index ae8b812c9202..2481e78c0423 100644
--- a/arch/powerpc/platforms/4xx/cpm.c
+++ b/arch/powerpc/platforms/4xx/cpm.c
@@ -327,6 +327,6 @@ late_initcall(cpm_init);
 static int __init cpm_powersave_off(char *arg)
 {
 	cpm.powersave_off = 1;
-	return 0;
+	return 1;
 }
 __setup("powersave=off", cpm_powersave_off);
-- 
2.35.1



