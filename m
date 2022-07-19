Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6635799FF
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238342AbiGSMKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238469AbiGSMI6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:08:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF3E45F55;
        Tue, 19 Jul 2022 05:02:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 192E3616B7;
        Tue, 19 Jul 2022 12:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F166EC341C6;
        Tue, 19 Jul 2022 12:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232124;
        bh=N9y9jrWkFWavSQgIg0Y/ZqemYrSMNISBg/Cd4IgMipM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mQqiY5bZjP2JdC2Nqg2hpVuah2kVn+6vxuLcl42X2HFTZ5e1s9/pkh8G+69rgl28e
         tJ3X9mjUImXKAoa34mR5LZQF2YtNCdQ+Ey7rDBpGq/wJum6FAvCAlHMeqRlMVYXdzA
         yHk+NpSbNrwiOj5YcmFI7NeQBuIeJlHsixYuzC9M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/71] ARM: 9209/1: Spectre-BHB: avoid pr_info() every time a CPU comes out of idle
Date:   Tue, 19 Jul 2022 13:53:43 +0200
Message-Id: <20220719114554.188643571@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 0609e200246bfd3b7516091c491bec4308349055 ]

Jon reports that the Spectre-BHB init code is filling up the kernel log
with spurious notifications about which mitigation has been enabled,
every time any CPU comes out of a low power state.

Given that Spectre-BHB mitigations are system wide, only a single
mitigation can be enabled, and we already print an error if two types of
CPUs coexist in a single system that require different Spectre-BHB
mitigations.

This means that the pr_info() that describes the selected mitigation
does not need to be emitted for each CPU anyway, and so we can simply
emit it only once.

In order to clarify the above in the log message, update it to describe
that the selected mitigation will be enabled on all CPUs, including ones
that are unaffected. If another CPU comes up later that is affected and
requires a different mitigation, we report an error as before.

Fixes: b9baf5c8c5c3 ("ARM: Spectre-BHB workaround")
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/proc-v7-bugs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index f2c8ff0683fd..b09c54499f95 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -221,10 +221,10 @@ static int spectre_bhb_install_workaround(int method)
 			return SPECTRE_VULNERABLE;
 
 		spectre_bhb_method = method;
-	}
 
-	pr_info("CPU%u: Spectre BHB: using %s workaround\n",
-		smp_processor_id(), spectre_bhb_method_name(method));
+		pr_info("CPU%u: Spectre BHB: enabling %s workaround for all CPUs\n",
+			smp_processor_id(), spectre_bhb_method_name(method));
+	}
 
 	return SPECTRE_MITIGATED;
 }
-- 
2.35.1



