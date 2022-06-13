Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165B65489E1
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343568AbiFMKtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344021AbiFMKqu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:46:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0EE2BB3F;
        Mon, 13 Jun 2022 03:25:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D82C3B80E92;
        Mon, 13 Jun 2022 10:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28619C34114;
        Mon, 13 Jun 2022 10:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115951;
        bh=lUTUaU7NK6xPI/fCw6nR7Vbxfy1nWrm8QQoc/qCEKm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dMpbKHGfN1nBZLtofpjPd+3cbKjaJGPXw7a1arG4YZd2CRP4SjWk/05RoyF+Bm+iI
         f26DZyX8ebffWmjS0EY0r5N+GfRS4E+b2CsuDPBkdBZZVwqz0mjd6SlET6+OfmK1Ri
         F2cVHzATNzEHFBBW+ta+frThCq72a4ahHs5E72Ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Zhbanov <izh1979@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 091/218] powerpc/4xx/cpm: Fix return value of __setup() handler
Date:   Mon, 13 Jun 2022 12:09:09 +0200
Message-Id: <20220613094923.300801202@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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
index 53ff81ca8a3c..6400ae376216 100644
--- a/arch/powerpc/platforms/4xx/cpm.c
+++ b/arch/powerpc/platforms/4xx/cpm.c
@@ -341,6 +341,6 @@ late_initcall(cpm_init);
 static int __init cpm_powersave_off(char *arg)
 {
 	cpm.powersave_off = 1;
-	return 0;
+	return 1;
 }
 __setup("powersave=off", cpm_powersave_off);
-- 
2.35.1



