Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4506673C6
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 14:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbjALN6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 08:58:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjALN5y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 08:57:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9DB53287
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 05:57:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7A2CB81E68
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 13:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D492C433EF;
        Thu, 12 Jan 2023 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673531860;
        bh=R/FzZwGWEz4Uxqu8dr4LIIJiLMXchnBGGB0kUA2SZEw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NV5p8+7eCMclw8brVLAvrzO3D64kMCQt2Drf+5nqAxrNPzqPdnO9NPzEEU6bbkIFb
         yWNCng4UUZ+m4JKb4/cvjiEMRtJxcsQTIDINbawouF7AN3Ws1/HnqEW8fqPIYprPBK
         yeTnP8VEqbG71pAex+scGIQOr3i9Z2wu5Xm5vmkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kyle Huey <me@kylehuey.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 5.15 06/10] x86/fpu: Emulate XRSTORs behavior if the xfeatures PKRU bit is not set
Date:   Thu, 12 Jan 2023 14:56:43 +0100
Message-Id: <20230112135326.931667008@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135326.689857506@linuxfoundation.org>
References: <20230112135326.689857506@linuxfoundation.org>
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

From: Kyle Huey <me@kylehuey.com>

commit d7e5aceace514a2b1b3ca3dc44f93f1704766ca7 upstream

The hardware XRSTOR instruction resets the PKRU register to its hardware
init value (namely 0) if the PKRU bit is not set in the xfeatures mask.
Emulating that here restores the pre-5.14 behavior for PTRACE_SET_REGSET
with NT_X86_XSTATE, and makes sigreturn (which still uses XRSTOR) and
behave identically.

Fixes: e84ba47e313d ("x86/fpu: Hook up PKRU into ptrace()")
Signed-off-by: Kyle Huey <me@kylehuey.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lore.kernel.org/all/20221115230932.7126-6-khuey%40kylehuey.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1168,7 +1168,8 @@ static int copy_uabi_to_xstate(struct xr
 
 		xpkru = __raw_xsave_addr(xsave, XFEATURE_PKRU);
 		*pkru = xpkru->pkru;
-	}
+	} else
+		*pkru = 0;
 
 	/*
 	 * The state that came in from userspace was user-state only.


