Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F8155CB03
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbiF0Gc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 02:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbiF0Gc1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 02:32:27 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE4626D8
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 23:32:27 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g4so1302463pgc.1
        for <stable@vger.kernel.org>; Sun, 26 Jun 2022 23:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=2HFwlhonew13WWPj5aFc9ku+N8T0ZMk1qaDyDiNOacY=;
        b=YkxTBr10dc6a3INVRUb0bKozNPp0NzlKJ94+Q2gVRx6yQ25s1f8QDkoO5PYgFG8j11
         p+q0FCoDDQKwO+6FR25uT+rYDxd51J/Wi3cFvwB6hUnKngkKPqOKCWrl+FV4Fp9Jg6Tq
         qkaK6A3QKPYN780jesI1l7qhXxAcVGsLo86F56yFQBxz2SV9bQj0jluTkDLDdwVGn5rc
         B+IB/Vkfe699zyvyqtBQ1WHh9SXGJokfiRV6dboAPwdNVK+VR0KZ9nLKKxxMx/2vLW5A
         uPaHAvArw7rIIM6buuBhNvuE6WUtKrck10BpeOKSKlYpAICm4FPFMgkcFLWQwHOyrhDn
         SEAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=2HFwlhonew13WWPj5aFc9ku+N8T0ZMk1qaDyDiNOacY=;
        b=eftpH/jHeztLiO+dNQkJmKizqKP7sa2pLeQcSPN8IZZ5aMY7e6RROkMvaAVnvJ96Rt
         HTN1WJD2HuS1uR1zJ18qOQjE8JdTwLftJ2oDINFBUcHKaLzGUWYWl5m4Q2wPXS5OsgqY
         eUIRJOWSXmbM+cr9zEKtmWIcVpceSm0KMytC0dU9MS0GFVxfiUJFq8i0vcvksprZR0GZ
         V1IPg+usSi7JbJpmueH1izP0ogPAOfuodB5qvLQOZzeVyDoWtvespwxL8EWAHVqjmz33
         OgqOdsA8NzET1NuGAqpJNEQkhuiMZUMnEsFk9yKd5ppM0+0rGWru1vZSkDlFcFAvmmhL
         n/sQ==
X-Gm-Message-State: AJIora+vi1OSKxkJ4rh4nbskCAlg8V9fPcYHogC1UpyYM4bRjdYNsWrw
        Vxpx5QJmZYhh1+KVofmeH78=
X-Google-Smtp-Source: AGRyM1smbCLyKHqUTizM5qIXHjPk3NVBJthz4t8/WPKvfN/oGl9EqMox/Srg8Fd8ZFBLt0Hyw707ww==
X-Received: by 2002:a05:6a00:1a0e:b0:523:1e7c:e26e with SMTP id g14-20020a056a001a0e00b005231e7ce26emr13039354pfv.60.1656311546632;
        Sun, 26 Jun 2022 23:32:26 -0700 (PDT)
Received: from desktop-hypoxic.kamiya.io ([42.120.103.58])
        by smtp.gmail.com with ESMTPSA id q21-20020aa79835000000b0051844a64d3dsm6339260pfl.25.2022.06.26.23.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:32:26 -0700 (PDT)
From:   Yangxi Xiang <xyangxi5@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     stable@vger.kernel.org, Yangxi Xiang <xyangxi5@gmail.com>
Subject: [PATCH] asm-generic: fix buffer overflow read in __strncpy_from_user
Date:   Mon, 27 Jun 2022 14:32:12 +0800
Message-Id: <20220627063212.21626-1-xyangxi5@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

a common calling pattern is strncpy_from_user(buf, user_ptr, sizeof(buf)).
However a buffer-overflow read occurs in this loop when reading the last
byte. Fix it by early checking the available bytes.

Signed-off-by: Yangxi Xiang <xyangxi5@gmail.com>
---
 include/asm-generic/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
index a0b2f270dddc..d45d4f535934 100644
--- a/include/asm-generic/uaccess.h
+++ b/include/asm-generic/uaccess.h
@@ -252,7 +252,7 @@ __strncpy_from_user(char *dst, const char __user *src, long count)
 {
 	char *tmp;
 	strncpy(dst, (const char __force *)src, count);
-	for (tmp = dst; *tmp && count > 0; tmp++, count--)
+	for (tmp = dst; count > 0 && *tmp; tmp++, count--)
 		;
 	return (tmp - dst);
 }
-- 
2.17.1

