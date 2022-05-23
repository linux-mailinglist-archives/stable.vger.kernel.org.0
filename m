Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06794531976
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239836AbiEWRKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239647AbiEWRKT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 350C26CA8A;
        Mon, 23 May 2022 10:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 824D4B811F6;
        Mon, 23 May 2022 17:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A3EC385A9;
        Mon, 23 May 2022 17:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325779;
        bh=UodYB9RZCKj8YDl/NrPyDzZlEGObUwSATbKP+WigtdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L5RnQaCZNQ2gvFAj4+rLrej47IetSO/y65mwOMhuN4dPnGIQi+cEQ1kpn+Zlsl9al
         n0GI+8rAjnty0JCdbDJSWTPacFHScP1hVSqryOhS1aTxjW4XBfQ2rrNdOaY+phRiGn
         N5FcCXF8Jw+huJM+Z0B9o/oq1L3X7ZoriHLrPvvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/33] ARM: 9196/1: spectre-bhb: enable for Cortex-A15
Date:   Mon, 23 May 2022 19:05:09 +0200
Message-Id: <20220523165751.433712311@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165746.957506211@linuxfoundation.org>
References: <20220523165746.957506211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 0dc14aa94ccd8ba35eb17a0f9b123d1566efd39e ]

The Spectre-BHB mitigations were inadvertently left disabled for
Cortex-A15, due to the fact that cpu_v7_bugs_init() is not called in
that case. So fix that.

Fixes: b9baf5c8c5c3 ("ARM: Spectre-BHB workaround")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/proc-v7-bugs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 1b6e770bc1cd..8b78694d56b8 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -297,6 +297,7 @@ void cpu_v7_ca15_ibe(void)
 {
 	if (check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(0)))
 		cpu_v7_spectre_v2_init();
+	cpu_v7_spectre_bhb_init();
 }
 
 void cpu_v7_bugs_init(void)
-- 
2.35.1



