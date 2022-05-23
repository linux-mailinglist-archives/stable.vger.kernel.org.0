Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A31531890
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241758AbiEWRbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241715AbiEWR1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:27:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D317A6175;
        Mon, 23 May 2022 10:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 13043610E8;
        Mon, 23 May 2022 17:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140AFC385A9;
        Mon, 23 May 2022 17:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326478;
        bh=VcPpcPHrQ0SHo1DNrUEe4k1AjZowFc1+BAV9eUH1my4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgW07DpulnUnOFwDG+aZQrPZ48WxcSg11nar66LTdfiqPpq+YHEPXWDYYg7uCOXJk
         D/CcZzD+XUYpeIbK5gikNZy0oBfnAdu5QEld7f205w0mQeI820elxZDi67LPH3HLYH
         Iokm6Xq5mahSdNDxqijkSwlMbadZALns4VYnuxu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/132] ARM: 9196/1: spectre-bhb: enable for Cortex-A15
Date:   Mon, 23 May 2022 19:05:02 +0200
Message-Id: <20220523165838.736427771@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
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
index 06dbfb968182..fb9f3eb6bf48 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -288,6 +288,7 @@ void cpu_v7_ca15_ibe(void)
 {
 	if (check_spectre_auxcr(this_cpu_ptr(&spectre_warned), BIT(0)))
 		cpu_v7_spectre_v2_init();
+	cpu_v7_spectre_bhb_init();
 }
 
 void cpu_v7_bugs_init(void)
-- 
2.35.1



