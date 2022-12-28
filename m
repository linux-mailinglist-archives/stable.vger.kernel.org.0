Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA1D6658410
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:54:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235232AbiL1QyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235251AbiL1QxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:53:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901CC193FE
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:48:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46249B8172A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B86FC433D2;
        Wed, 28 Dec 2022 16:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246106;
        bh=KNuMHHjvWcTpwbCNWnMLoHadgrrCZZnrlhqt5jUTw98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnMs1HFoDwLBDWrCDmPaHvyuegyrppxJNZvA3TYN58oo9Gtpr3NBWkTxtVNP5HZ2G
         3KPY6hFM6xpqQMTvbLemCr+8LnvUW5SDX/fpIpKUeUlM6EAf0HAiZzvSMqA+efjL+n
         A9xTfIEwexrSbVXRcK5okpXyXEIJUdJT3SJIiVig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 1013/1073] lkdtm: cfi: Make PAC test work with GCC 7 and 8
Date:   Wed, 28 Dec 2022 15:43:21 +0100
Message-Id: <20221228144355.685667171@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristina Martsenko <kristina.martsenko@arm.com>

[ Upstream commit f68022ae0aeb0803450e05abc0e984027c33ef1b ]

The CFI test uses the branch-protection=none compiler attribute to
disable PAC return address protection on a function. While newer GCC
versions support this attribute, older versions (GCC 7 and 8) instead
supported the sign-return-address=none attribute, leading to a build
failure when the test is built with older compilers. Fix it by checking
which attribute is supported and using the correct one.

Fixes: 2e53b877dc12 ("lkdtm: Add CFI_BACKWARD to test ROP mitigations")
Reported-by: Daniel Díaz <daniel.diaz@linaro.org>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/all/CAEUSe78kDPxQmQqCWW-_9LCgJDFhAeMoVBFnX9QLx18Z4uT4VQ@mail.gmail.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/cfi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/lkdtm/cfi.c b/drivers/misc/lkdtm/cfi.c
index 71483cb1e422..f4fd30f7a9a0 100644
--- a/drivers/misc/lkdtm/cfi.c
+++ b/drivers/misc/lkdtm/cfi.c
@@ -51,7 +51,11 @@ static void lkdtm_CFI_FORWARD_PROTO(void)
 # ifdef CONFIG_ARM64_BTI_KERNEL
 #  define __no_pac             "branch-protection=bti"
 # else
-#  define __no_pac             "branch-protection=none"
+#  ifdef CONFIG_CC_HAS_BRANCH_PROT_PAC_RET
+#   define __no_pac            "branch-protection=none"
+#  else
+#   define __no_pac            "sign-return-address=none"
+#  endif
 # endif
 # define __no_ret_protection   __noscs __attribute__((__target__(__no_pac)))
 #else
-- 
2.35.1



