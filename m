Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF06A5C0296
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 17:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbiIUPyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 11:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbiIUPxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:53:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8A8857F1;
        Wed, 21 Sep 2022 08:49:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7C356312C;
        Wed, 21 Sep 2022 15:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB8D9C433C1;
        Wed, 21 Sep 2022 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775344;
        bh=O4/u53JHf7gUmkfgGF2w+ePqacS+7zX57PDIn4KdBRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlbJqSjRCgIkjlN7ZsxAHlm0XEr0aYj2CeGeei7vnui1CBf8dLOPs/07GmgzxtDsp
         t+j5lgr1SxtsHTbOHsBd9mWNQrQlRuCLXIzag9caHxSUk2TJeZbCbsR+mQf9MU1NUc
         fZ5BHjDwaAqRed50u6QMbKuFdYM0OEWW3CxBMwGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <benh@debian.org>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.15 21/45] tools/include/uapi: Fix <asm/errno.h> for parisc and xtensa
Date:   Wed, 21 Sep 2022 17:46:11 +0200
Message-Id: <20220921153647.569014947@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153646.931277075@linuxfoundation.org>
References: <20220921153646.931277075@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ben Hutchings <benh@debian.org>

commit 95363747a6f39e88a3052fcf6ce6237769495ce0 upstream.

tools/include/uapi/asm/errno.h currently attempts to include
non-existent arch-specific errno.h header for xtensa.
Remove this case so that <asm-generic/errno.h> is used instead,
and add the missing arch-specific header for parisc.

Signed-off-by: Ben Hutchings <benh@debian.org>
Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
Cc: <stable@vger.kernel.org> # 5.10+
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/uapi/asm/errno.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/include/uapi/asm/errno.h
+++ b/tools/include/uapi/asm/errno.h
@@ -9,8 +9,8 @@
 #include "../../../arch/alpha/include/uapi/asm/errno.h"
 #elif defined(__mips__)
 #include "../../../arch/mips/include/uapi/asm/errno.h"
-#elif defined(__xtensa__)
-#include "../../../arch/xtensa/include/uapi/asm/errno.h"
+#elif defined(__hppa__)
+#include "../../../arch/parisc/include/uapi/asm/errno.h"
 #else
 #include <asm-generic/errno.h>
 #endif


