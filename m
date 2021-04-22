Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA6F36868B
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 20:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhDVS0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 14:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236768AbhDVS0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 14:26:25 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD48C06174A
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 11:25:50 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id z5-20020a05622a0285b02901b943be06b5so7906310qtw.17
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 11:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cdFFfBwj6y+ldLJWT4RH/UCRgZud/iyFWxuR5ipQoVI=;
        b=kPtqx4n7It6L+YNDdsYxD+Agp+bgfqLUbKTTCN5iRtHehOYyZij9HjCUfBDwHkYrfV
         Ewm4+4uKAQl7/7POfPGXqztoHtuKSLgyBiOl8yYtveYKRoXBoX462R7bgYU9g63iaYmz
         ZBJPzyhqbxNqrBg98+elt4eQDtJ1anUEuieGz2CH5sa53K3vAfTL+9nCDquPIsv9fBr7
         cRM26SgqxG/c+pwkRUb2l3NDeXp+hwGi4vZzm2RQ/5CMKsCr1k/BBI7w20bg/7FGSzFs
         0xRjA5OosaIy3YABLGlVhyd0CQqowaNKhHb+L1HDPBKI/LXq0zabapLS5JSiqRlsDsKU
         FQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cdFFfBwj6y+ldLJWT4RH/UCRgZud/iyFWxuR5ipQoVI=;
        b=gdAa+OZqxP6+eLwuIctV6ajb1nH3tr2zypGNgwcU9/LVfP+cr+gaweovCOt5AjzCIN
         HBU/iB5b/cHgDVirtdInRoALt0604mCqNLV2mnI7/0k5m2yCyei6NJFk9fo5MV14gCXs
         sk/MytrQME5T6asq58WF79MtJxlCrS6fUKrrlKtJVkqhB5L/DNZrnnaaqBrYxc7TUFaw
         PJRT9Jk26oNswP++y9I2rmTKbjl8NBHAmSryuLsCbK8KwKk+U3GT1nxlXRp+6e1HgjDm
         cvsC5jMN2rq3pCgbnQNTxwPw376vm7ecPGIqpvGxcRS/VAzQMWYYLi6cWgcay9QjQzZt
         RXhw==
X-Gm-Message-State: AOAM531jNWuW+oK1UJ8hpsESUN8E3CvrmfxYHC6qXMcNt6QNdtwqxzkk
        KBmXnjo1NGKgaXJAqsD2d49mtknmzTiLgwfD
X-Google-Smtp-Source: ABdhPJxHDiOKvw7MbVPkxJtBsTTRLWxDYith8HTo++LxCspdOO5u1CM0L1TAxMlZXcj0DObKKM0ej9QNERvGplzw
X-Received: from manoj.svl.corp.google.com ([2620:15c:2ce:0:f9bc:2c5f:7aa9:b2])
 (user=manojgupta job=sendgmr) by 2002:a05:6214:13c2:: with SMTP id
 cg2mr228706qvb.4.1619115949274; Thu, 22 Apr 2021 11:25:49 -0700 (PDT)
Date:   Thu, 22 Apr 2021 11:25:45 -0700
Message-Id: <20210422182545.726897-1-manojgupta@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH] iw: set retain atrribute on sections
From:   Manoj Gupta <manojgupta@google.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     stable@vger.kernel.org, maskray@google.com, llozano@google.com,
        manojgupta@google.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LLD 13 and GNU ld 2.37 support -z start-stop-gc which allows garbage
collection of C identifier name sections despite the __start_/__stop_
references.  Simply set the retain attribute so that GCC 11 (if
configure-time binutils is 2.36 or newer)/Clang 13 will set the
SHF_GNU_RETAIN section attribute to prevent garbage collection.

Without the patch, there are linker errors like the following with -z
start-stop-gc:
ld.lld: error: undefined symbol: __stop___cmd
>>> referenced by iw.c:418
>>>               iw.o:(__handle_cmd)

Suggested-by: Fangrui Song <maskray@google.com>

Signed-off-by: Manoj Gupta <manojgupta@google.com>
---
 iw.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/iw.h b/iw.h
index 7f7f4fc..67aa00c 100644
--- a/iw.h
+++ b/iw.h
@@ -118,8 +118,9 @@ struct chandef {
 		.parent = _section,					\
 		.selector = (_sel),					\
 	};								\
+	_Pragma("GCC diagnostic ignored \"-Wattributes\"") 		\
 	static struct cmd *__cmd ## _ ## _symname ## _ ## _handler ## _ ## _nlcmd ## _ ## _idby ## _ ## _hidden ## _p \
-	__attribute__((used,section("__cmd"))) =			\
+	__attribute__((used,retain,section("__cmd"))) =			\
 	&__cmd ## _ ## _symname ## _ ## _handler ## _ ## _nlcmd ## _ ## _idby ## _ ## _hidden
 #define __ACMD(_section, _symname, _name, _args, _nlcmd, _flags, _hidden, _idby, _handler, _help, _sel, _alias)\
 	__COMMAND(_section, _symname, _name, _args, _nlcmd, _flags, _hidden, _idby, _handler, _help, _sel);\
-- 
2.31.1.498.g6c1eba8ee3d-goog

