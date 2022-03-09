Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1181E4D326E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbiCIQCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234177AbiCIQCh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:02:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B226B170D51;
        Wed,  9 Mar 2022 08:01:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FF2C6167E;
        Wed,  9 Mar 2022 16:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585EAC340F3;
        Wed,  9 Mar 2022 16:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646841697;
        bh=46jo3Lac9ZQVbErqXQpZ2hY92m8kz18vN57CNImpM3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBsom5iJ7wNqsoDwHKDHEKubM7PAZ3/GZVR0hlKrg5fJP05YIZ/NzGQ7a/vnsTNSG
         dtxWj+FSH63lgZowIAd2ui3DWDTSOm5SYgqaAhzk0mftS3hnTbVd7+dFezm07ONIhe
         rIskyEL87LOykhKbX5lk83qA7RrFbUxPDQJ4E9/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.9 13/24] x86/speculation: Use generic retpoline by default on AMD
Date:   Wed,  9 Mar 2022 16:59:26 +0100
Message-Id: <20220309155856.690698640@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309155856.295480966@linuxfoundation.org>
References: <20220309155856.295480966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kim Phillips <kim.phillips@amd.com>

commit 244d00b5dd4755f8df892c86cab35fb2cfd4f14b upstream.

AMD retpoline may be susceptible to speculation. The speculation
execution window for an incorrect indirect branch prediction using
LFENCE/JMP sequence may potentially be large enough to allow
exploitation using Spectre V2.

By default, don't use retpoline,lfence on AMD.  Instead, use the
generic retpoline.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -897,14 +897,6 @@ static enum spectre_v2_mitigation __init
 		return SPECTRE_V2_NONE;
 	}
 
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
-		if (!boot_cpu_has(X86_FEATURE_LFENCE_RDTSC)) {
-			pr_err("LFENCE not serializing, switching to generic retpoline\n");
-			return SPECTRE_V2_RETPOLINE;
-		}
-		return SPECTRE_V2_LFENCE;
-	}
-
 	return SPECTRE_V2_RETPOLINE;
 }
 


