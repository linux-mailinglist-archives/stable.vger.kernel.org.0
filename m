Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDEB57991B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237535AbiGSL6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237529AbiGSL6T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:58:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B5C45F7C;
        Tue, 19 Jul 2022 04:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9E6261659;
        Tue, 19 Jul 2022 11:57:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFFEC341C6;
        Tue, 19 Jul 2022 11:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231829;
        bh=+8CzF90KkgZMMGOcGho4vUISVftHoe5+9nZIO+iktok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mX10wzbjPlC8zaa0/8c4BQCUC8q3lg3+78D2GnhP4iPaRzXXpXuhYEgLhUOrbzlBd
         WEOUz7uI4vj5gFuGKVHyOpgxxECwzA8SDkPBm0p1xztpFfX+AhVMU9nfHJ3aU72ODS
         IpoVhkWUkP3kotvBx62noFbVaa8yNwaVPkoDu2xY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/43] ARM: 9209/1: Spectre-BHB: avoid pr_info() every time a CPU comes out of idle
Date:   Tue, 19 Jul 2022 13:53:43 +0200
Message-Id: <20220719114523.103022644@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 35c4660e638a..4af4195eed76 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -217,10 +217,10 @@ static int spectre_bhb_install_workaround(int method)
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



