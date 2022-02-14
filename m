Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99AE14B49F6
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346277AbiBNKR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:17:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346939AbiBNKQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:16:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A017B6D4CF;
        Mon, 14 Feb 2022 01:53:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB61C6128D;
        Mon, 14 Feb 2022 09:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB862C340E9;
        Mon, 14 Feb 2022 09:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832404;
        bh=ITOrIx8iB3hB/ew+YJcfeMU3x2zKuqG38QfwPFUBUfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihPIpXmBwrcCBF0WX9ARl2ZSFaaYY4uvbYo8dofWsM5NDrKBhVgiveJG1oaHseL/J
         EHwUKFNKFJBhJvc7gjz5ys+uxQh0qsPPJwkept2l1YRx1BsY8jT9LPrbC4yzL4biGK
         CYjV7JCR8/jeHo+WSjjGMtLpHC26wH1Xb7Y3nPZQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 169/172] MIPS: octeon: Fix missed PTR->PTR_WD conversion
Date:   Mon, 14 Feb 2022 10:27:07 +0100
Message-Id: <20220214092512.229276610@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092506.354292783@linuxfoundation.org>
References: <20220214092506.354292783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit 50317b636e7184d15126e2dfc83db0963a38d31e upstream.

Fixes: fa62f39dc7e2 ("MIPS: Fix build error due to PTR used in more places")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/cavium-octeon/octeon-memcpy.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/cavium-octeon/octeon-memcpy.S
+++ b/arch/mips/cavium-octeon/octeon-memcpy.S
@@ -74,7 +74,7 @@
 #define EXC(inst_reg,addr,handler)		\
 9:	inst_reg, addr;				\
 	.section __ex_table,"a";		\
-	PTR	9b, handler;			\
+	PTR_WD	9b, handler;			\
 	.previous
 
 /*


