Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E617F6A0CC5
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 16:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234456AbjBWPVD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 10:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234380AbjBWPVC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 10:21:02 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8130357D21;
        Thu, 23 Feb 2023 07:21:01 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id l1so10680906wry.10;
        Thu, 23 Feb 2023 07:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hu2K9N1s7d8rZuoggXQ62T3TkCxxmvwqtE9EM9xMYtI=;
        b=FrNrSV78f0/i2S72xDv/wDaVp8uPFOkEuTtKGtGItNkg1NY4Ndna0CT14am2KNO04O
         D2g9WN1gwtQoqe8eowZPIB1ha5ipKXF3DsXlz+J+f41PW6YiskamUyfs9JnJO2rA3tjs
         5WYuV4qa4YqBzBZBY8VQgCUMxCNQdqZJwx7h6YESBlKwA9LWtJc9fuz72KUAZ7W91l7O
         bgsNxbGB6OsvwPWiH4JcIorADhZIKN8F2MDHSPS+NlxTnetTYOPA8CB4Wd7PupVh8Lr1
         aar3vd1YofQN9r6+Wi1y4JDkxISsEWbLTl01o/VsB88C7+S3YJczjttUy3/uvSzOhQsE
         7M5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hu2K9N1s7d8rZuoggXQ62T3TkCxxmvwqtE9EM9xMYtI=;
        b=Ld94N7M5Us4cuSdP8g/LHQ+RBxakjMa0g5qzQR+ZvcRtr+vdlwMfunVC2CDXYXxllM
         PrL09QXgQBlpzObteD2Y15bniCOcIjUpgbTSwivNwybINxooxfTaK2nnsIq8qIc7aU/B
         YpCkwZnV0iOhw431dhTc5YDeTHiI00Zgf+vv9tOppEcy71c8kmoQAiw2QTiez6PnTbdb
         L5qB58PVieoZ+X6Ncm53nLsDb2hdWXk6Ykcv/0PVHXX0b+KjrvSAbkiqk0J8n0DPZCFG
         ZHDo/4DmOfS9sHC1aj3MzGnFwKXNDHwT6eE5/WqZg+n48t+DI2Z/ufUcAN9299wcjkQ/
         X8YA==
X-Gm-Message-State: AO0yUKVnucIZjKR8T88gZvrfjeLxkh2WWGPOLXk8V6JVG0zn6CFRiolD
        UQ+sKbcUdkfQsyRGkIcvU3M=
X-Google-Smtp-Source: AK7set/sXECzkm4MstnrYwJK1WtMwcB/QH/NN92+GXlsVdccAU8dQZZk4FXESjlyL6th70OZYbuo+Q==
X-Received: by 2002:a5d:4808:0:b0:2c7:694:aa18 with SMTP id l8-20020a5d4808000000b002c70694aa18mr7674173wrq.15.1677165661056;
        Thu, 23 Feb 2023 07:21:01 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k9-20020a5d6289000000b002c56af32e8csm9372590wru.35.2023.02.23.07.20.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 07:21:00 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 6.1 5/5] fs: use consistent setgid checks in is_sxid()
Date:   Thu, 23 Feb 2023 17:20:44 +0200
Message-Id: <20230223152044.1064909-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230223152044.1064909-1-amir73il@gmail.com>
References: <20230223152044.1064909-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <brauner@kernel.org>

commit 8d84e39d76bd83474b26cb44f4b338635676e7e8 upstream.

Now that we made the VFS setgid checking consistent an inode can't be
marked security irrelevant even if the setgid bit is still set. Make
this function consistent with all other helpers.

Note that enforcing consistent setgid stripping checks for file
modification and mode- and ownership changes will cause the setgid bit
to be lost in more cases than useed to be the case. If an unprivileged
user wrote to a non-executable setgid file that they don't have
privilege over the setgid bit will be dropped. This will lead to
temporary failures in some xfstests until they have been updated.

Reported-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index ed555aa9bf48..f14ecbeab2a9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3549,7 +3549,7 @@ int __init list_bdev_fs_names(char *buf, size_t size);
 
 static inline bool is_sxid(umode_t mode)
 {
-	return (mode & S_ISUID) || ((mode & S_ISGID) && (mode & S_IXGRP));
+	return mode & (S_ISUID | S_ISGID);
 }
 
 static inline int check_sticky(struct user_namespace *mnt_userns,
-- 
2.34.1

