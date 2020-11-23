Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958142BFF08
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 05:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgKWEjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 23:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbgKWEjX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 23:39:23 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF2DC0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 20:39:22 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id c66so13745552pfa.4
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 20:39:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6O9tTZiciXa+A2c4TI7AK5QjC1q+v0czK7RN9U7lYo4=;
        b=VaPoQkmlI2wCGxuMKkyxyivpoyOdNyvGnc2vrkUtNd1EqlPMjuOJo5ELo2rImQhv8+
         tu98ty4ybco9EIGGk+9ZTzwBZTiWJxMRqs5FbRJpwX7LZd+uHF4ZIRWsWj5MNk7mLLko
         ybEnyvWuSJT3e32RxQo6VVKSXD2QQiXd1IaPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6O9tTZiciXa+A2c4TI7AK5QjC1q+v0czK7RN9U7lYo4=;
        b=d+lIQ+OnUXqh7uZEb/Od8xJYschIu1e+fHqS5b4d8w6Pum9ZTkC2amB8yb5VqXr5Jv
         neFFFV1llxzWJ4GKeWY6/uug5Lacr5vbDrYB+36zvvxxydL2yuaFMcgB+5HJrtGnOfwx
         rSEL37xAqbJ6W8HnugRZFTqmt5SlxPFtXu53OxbglX32umT3cdZoyG7g3yCNq4wDZBur
         Pm6BL4u+1NGJmSGTav0D8TUnF2UjqSS4TmwrPZK7WNipbqZALKy3xcQa+m/C7UjH9Xr2
         A8HIGBCypC6cAlXYJL690meMz8e22IGvPWEUdSuyca+2Npl9xP8jPRulR9yr2WcdXsKB
         UKXA==
X-Gm-Message-State: AOAM530aDrWnc5GmPSe0o5+F1nEbVQZTlhUYCc8NTVrprZBP1CFa6jLt
        +LZqjz5xscCE9Dhe6efnNNv0zMuXuzukZA==
X-Google-Smtp-Source: ABdhPJwJvMkmYSuvnCumIePeQFJ3FkY1uqfZ/UsK9OHvInCCMxZToIcVpw0FwYRHXtpOgnvFqCyfvw==
X-Received: by 2002:a17:90a:8805:: with SMTP id s5mr21180935pjn.116.1606106361112;
        Sun, 22 Nov 2020 20:39:21 -0800 (PST)
Received: from localhost (2001-44b8-111e-5c00-d5b2-1708-a25b-d6aa.static.ipv6.internode.on.net. [2001:44b8:111e:5c00:d5b2:1708:a25b:d6aa])
        by smtp.gmail.com with ESMTPSA id 204sm6671158pfy.59.2020.11.22.20.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 20:39:20 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net, linux@roeck-us.net
Subject: [PATCH v4.9] powerpc/uaccess-flush: fix missing includes in kup-radix.h
Date:   Mon, 23 Nov 2020 15:39:16 +1100
Message-Id: <20201123043916.463870-1-dja@axtens.net>
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

