Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2B6540DA4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353870AbiFGStU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354412AbiFGSrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F783982C;
        Tue,  7 Jun 2022 11:01:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93F05B82375;
        Tue,  7 Jun 2022 18:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA442C385A5;
        Tue,  7 Jun 2022 18:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624864;
        bh=q2WfSuGehAysC4oWHH5FcLye7l4l9jfwd2iIF05nmrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ec3O4gCpNIeTEa2myzhNQxdcSpxkjXRKDQ1d4/zdPX5KKXNlZuye41hYtFAF2sxJr
         rSphhA109wOTAveRGVgB2t67lHFFxBWSr4G4tBN1oJ1JzMzFX82jVjFmKm8yiBs49g
         bSnp1h08aTaox6fDn870t+9+e8mNiETxzKsQT/tI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 440/667] powerpc/8xx: export cpm_setbrg for modules
Date:   Tue,  7 Jun 2022 19:01:45 +0200
Message-Id: <20220607164947.917698205@linuxfoundation.org>
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

[ Upstream commit 22f8e625ebabd7ed3185b82b44b4f12fc0402113 ]

Fix missing export for a loadable module build:

ERROR: modpost: "cpm_setbrg" [drivers/tty/serial/cpm_uart/cpm_uart.ko] undefined!

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
[chleroy: Changed Fixes: tag]
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210122010819.30986-1-rdunlap@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/8xx/cpm1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/8xx/cpm1.c b/arch/powerpc/platforms/8xx/cpm1.c
index c58b6f1c40e3..3ef5e9fd3a9b 100644
--- a/arch/powerpc/platforms/8xx/cpm1.c
+++ b/arch/powerpc/platforms/8xx/cpm1.c
@@ -280,6 +280,7 @@ cpm_setbrg(uint brg, uint rate)
 		out_be32(bp, (((BRG_UART_CLK_DIV16 / rate) - 1) << 1) |
 			      CPM_BRG_EN | CPM_BRG_DIV16);
 }
+EXPORT_SYMBOL(cpm_setbrg);
 
 struct cpm_ioport16 {
 	__be16 dir, par, odr_sor, dat, intr;
-- 
2.35.1



