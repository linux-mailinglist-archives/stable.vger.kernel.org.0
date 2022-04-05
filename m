Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FDB4F301E
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343542AbiDEI47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240288AbiDEIbv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:31:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B516B0BC;
        Tue,  5 Apr 2022 01:23:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6C74B81BC0;
        Tue,  5 Apr 2022 08:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7BEC385A1;
        Tue,  5 Apr 2022 08:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147037;
        bh=ikSxT9pj5gq8C7xxZTzQaN50E1eobY1Xe6l3yY+D4Jw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KgpUJ/DhbLhjwySXuRpHV60vvo5kuhqS/iwxbGUrsG+ZZ04oWAn2wY8iRQxZlUJSf
         OWSzl7LCT+OgjyGG0YoXOBSCiIXPgqicEopQbfdLuhfvjfjHxqi/ET+YL+kO7ObeJZ
         1yDhnn4AXE8ruhARUKvGgEgWZ1o7wt+13Jq2xaBk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.17 0962/1126] powerpc/lib/sstep: Fix sthcx instruction
Date:   Tue,  5 Apr 2022 09:28:29 +0200
Message-Id: <20220405070435.744821540@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

commit a633cb1edddaa643fadc70abc88f89a408fa834a upstream.

Looks like there been a copy paste mistake when added the instruction
'stbcx' twice and one was probably meant to be 'sthcx'. Changing to
'sthcx' from 'stbcx'.

Fixes: 350779a29f11 ("powerpc: Handle most loads and stores in instruction emulation code")
Cc: stable@vger.kernel.org # v4.14+
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220224162215.3406642-1-anders.roxell@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/lib/sstep.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -3389,7 +3389,7 @@ int emulate_loadstore(struct pt_regs *re
 			__put_user_asmx(op->val, ea, err, "stbcx.", cr);
 			break;
 		case 2:
-			__put_user_asmx(op->val, ea, err, "stbcx.", cr);
+			__put_user_asmx(op->val, ea, err, "sthcx.", cr);
 			break;
 #endif
 		case 4:


