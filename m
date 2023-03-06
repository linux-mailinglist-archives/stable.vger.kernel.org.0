Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C80AF6AB536
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 05:00:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCFEA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Mar 2023 23:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjCFEAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Mar 2023 23:00:45 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00D6F973;
        Sun,  5 Mar 2023 20:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=iULMFTYSH9RAAYP5rn6cyfg7kS6emYH4OKw5O1Q8kv0=; b=tXQ2PYqnaJJHdEPBsIxRpo2kTn
        +GVFOASIP3wlTp2RkxdVE5mcCluSIuVMCfq8w4CfXLaieoO1bEAaOXvBy3kZ7NUbHiOhMWZb98mEr
        xyIKotXVsh5JjZgbzNffAoqIWXOLAGRQ2+EkG8bwTQe9ejfAGEPePbe90MhvZFFvAnOTI+ENw8XJY
        PdZvIJ+lTr+QH3F6/0tBR15CHkpxFNKMz++puKItRP8LkzV9Y2OJNxX6vq1885u5B+dGHTT4XGl4u
        XSf4AsPB/YB/oPZ0EHVL8INakKA+csPIy61+K2o9oIeteubd0TMFHHr5HrrW+SXtzq5xPvuXaa33y
        YQ0GUwSg==;
Received: from [2601:1c2:980:9ec0::df2f] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pZ21h-00B9yD-Ji; Mon, 06 Mar 2023 04:00:41 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        stable@vger.kernel.org
Subject: [PATCH 4/7 v4] sh: math-emu: fix macro redefined warning
Date:   Sun,  5 Mar 2023 20:00:34 -0800
Message-Id: <20230306040037.20350-5-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230306040037.20350-1-rdunlap@infradead.org>
References: <20230306040037.20350-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix a warning that was reported by the kernel test robot:

In file included from ../include/math-emu/soft-fp.h:27,
                 from ../arch/sh/math-emu/math.c:22:
../arch/sh/include/asm/sfp-machine.h:17: warning: "__BYTE_ORDER" redefined
   17 | #define __BYTE_ORDER __BIG_ENDIAN
In file included from ../arch/sh/math-emu/math.c:21:
../arch/sh/math-emu/sfp-util.h:71: note: this is the location of the previous definition
   71 | #define __BYTE_ORDER __LITTLE_ENDIAN

Fixes: b929926f01f2 ("sh: define __BIG_ENDIAN for math-emu")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Link: lore.kernel.org/r/202111121827.6v6SXtVv-lkp@intel.com
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: linux-sh@vger.kernel.org
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
---
v2: add Reviewed-by Geert,
    rebase to linux-next-20211115
v3: skipped
v4: refresh & resend

 arch/sh/math-emu/sfp-util.h |    4 ----
 1 file changed, 4 deletions(-)

diff -- a/arch/sh/math-emu/sfp-util.h b/arch/sh/math-emu/sfp-util.h
--- a/arch/sh/math-emu/sfp-util.h
+++ b/arch/sh/math-emu/sfp-util.h
@@ -67,7 +67,3 @@
   } while (0)
 
 #define abort()	return 0
-
-#define __BYTE_ORDER __LITTLE_ENDIAN
-
-
