Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082A65C0338
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiIUQA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiIUP6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:58:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE5EA1A7C;
        Wed, 21 Sep 2022 08:52:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8320863158;
        Wed, 21 Sep 2022 15:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857CBC433C1;
        Wed, 21 Sep 2022 15:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775487;
        bh=l/ULhgbHsdxFPXP5MHqHn9qPO8Py2KwwRtVGoKwr2rU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S6Stedx044t3YzIhQVVagrBUHBKbtI4BhwV7BlWjbs1m1uUXT+/zoeYFDJWu/pwCa
         HrY3xduD0V/B+UOChPeyu2I4rNL+zOH5j2F8wE7Dci6twGIHWLdiAWYMsBSLKbNXw/
         YcIHzGxA/RSpQvS++XQci16UB6FpiU4V3y4t2Gf0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ben Hutchings <benh@debian.org>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 23/39] tools/include/uapi: Fix <asm/errno.h> for parisc and xtensa
Date:   Wed, 21 Sep 2022 17:46:28 +0200
Message-Id: <20220921153646.493424372@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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
 tools/include/uapi/asm/errno.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/include/uapi/asm/errno.h b/tools/include/uapi/asm/errno.h
index d30439b4b8ab..869379f91fe4 100644
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
-- 
2.37.3



