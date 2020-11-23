Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730A02BFF17
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 05:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgKWEpL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 23:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbgKWEpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 23:45:11 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A73C0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 20:45:11 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id w4so13069613pgg.13
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 20:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6O9tTZiciXa+A2c4TI7AK5QjC1q+v0czK7RN9U7lYo4=;
        b=QKpZ3Aqh7g5seIa2JLfMvINswtL0fXwSXEeR1mQgLIVqlN5VQuLh+uhMHMJMnhbwUW
         sc4+M0xTROyNFID43Us6ebBGRN2wZSC2n8fRVIeBtdnrPvYSOBrbPBLL3Zi+pOVHF+Ed
         LnVswCphznyhRyh63ULBK+8XP2XTHu4uKUfmI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6O9tTZiciXa+A2c4TI7AK5QjC1q+v0czK7RN9U7lYo4=;
        b=rarIpVyXz8HVx9AdDSFWNLYqrLuZuruocK7WbL0QIOmGKk5DiccPOVrSwpKnQNhuXR
         0X744hKQUwl8z59recE+Po/GMIcucHYDVPinCevOr+aFCg2bUwCAWeFAY1XDD5XqHA64
         6MeZrI7WOXCpvktrvcJGnXZVu36B/CEUwJUWm9sHfIoYowXcUvkhnTsTf9l0yxFpnED4
         PsQwnb6cnMqT6pzrcP2+r3OADsQ8bQdWulogT7SGSGeQGqgD32o0nGuFEcSzuWIaLZbD
         ++ZHTJfrP1wrMWm4hGP38SI+qN2cpj8pPBAnJQzsUjG2LnrZ4Xx23iI69mIQ1G0YIn+u
         0V9Q==
X-Gm-Message-State: AOAM533VkQmi03Ql6UY8rsxLpxP3+PN+MvJc1uIcJ5FXXGzcCj3MpJxn
        1czqad2yzLSWOtMouVCjDU+u4VqsCPgxkA==
X-Google-Smtp-Source: ABdhPJxsL/cuQ+2BApGRiNuuqNZfsVzR0427XIxFl0OPk3WqC63Zb2hxwSO8YbOtjMwYa/KDM4Ta3Q==
X-Received: by 2002:a17:90a:be0a:: with SMTP id a10mr9261148pjs.15.1606106710828;
        Sun, 22 Nov 2020 20:45:10 -0800 (PST)
Received: from localhost (2001-44b8-111e-5c00-d5b2-1708-a25b-d6aa.static.ipv6.internode.on.net. [2001:44b8:111e:5c00:d5b2:1708:a25b:d6aa])
        by smtp.gmail.com with ESMTPSA id t16sm9178808pga.51.2020.11.22.20.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 20:45:10 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net, linux@roeck-us.net
Subject: [PATCH v4.14] powerpc/uaccess-flush: fix missing includes in kup-radix.h
Date:   Mon, 23 Nov 2020 15:45:07 +1100
Message-Id: <20201123044507.464364-1-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Guenter reports a build failure on cell_defconfig and maple_defconfg:

In file included from arch/powerpc/include/asm/kup.h:10:0,
		 from arch/powerpc/include/asm/uaccess.h:12,
		 from arch/powerpc/lib/checksum_wrappers.c:24:
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: data definition has no type or storage class [-Werror]
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 ^~~~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: type defaults to ‘int’ in declaration of ‘DECLARE_STATIC_KEY_FALSE’ [-Werror=implicit-int]
arch/powerpc/include/asm/book3s/64/kup-radix.h:5:1: error: parameter names (without types) in function declaration [-Werror]
arch/powerpc/include/asm/book3s/64/kup-radix.h: In function ‘prevent_user_access’:
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:6: error: implicit declaration of function ‘static_branch_unlikely’ [-Werror=implicit-function-declaration]
  if (static_branch_unlikely(&uaccess_flush_key))
      ^~~~~~~~~~~~~~~~~~~~~~
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: error: ‘uaccess_flush_key’ undeclared (first use in this function); did you mean
‘do_uaccess_flush’?
  if (static_branch_unlikely(&uaccess_flush_key))
			      ^~~~~~~~~~~~~~~~~
			      do_uaccess_flush
arch/powerpc/include/asm/book3s/64/kup-radix.h:18:30: note: each undeclared identifier is reported only once for each function it appears in
cc1: all warnings being treated as errors

This is because I failed to include linux/jump_label.h in kup-radix.h. Include it.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 arch/powerpc/include/asm/book3s/64/kup-radix.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/include/asm/book3s/64/kup-radix.h b/arch/powerpc/include/asm/book3s/64/kup-radix.h
index aa54ac2e5659..cce8e7497d72 100644
--- a/arch/powerpc/include/asm/book3s/64/kup-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef _ASM_POWERPC_BOOK3S_64_KUP_RADIX_H
 #define _ASM_POWERPC_BOOK3S_64_KUP_RADIX_H
+#include <linux/jump_label.h>
 
 DECLARE_STATIC_KEY_FALSE(uaccess_flush_key);
 
-- 
2.25.1

