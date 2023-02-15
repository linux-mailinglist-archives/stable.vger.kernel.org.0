Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB31E698398
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 19:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjBOSkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 13:40:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBOSkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 13:40:51 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51693D0AA
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 10:40:13 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-52ec8c88d75so203547747b3.12
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 10:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9AI45ZOpupkZ8PCqEd2KJ2+crvZbRCWFsCnapW8KyMY=;
        b=rRLkt201C2lObE2BpLUjn9+EQSazZwAUQ4ioFGspp7gwmAM/qus5o1ENBGOFuypjzI
         BBMzvZzRs3ev1Av2MWX8M0Igzz8NXa0UYGqI5Mffbdxdl2gp8kyKaS/9u6XjL6XR//ph
         e1V8SdolQYwLtUivy533Kp0slA+09cszmpJA/rGHVOpb1Z8vSLMi/dRlgrcJH7PXCk3/
         N7TsbhTdYrQCPmy5y0ZuU/Av9jyYjpfmHH1AY78egSGai6odSDEVcqUjageDuh+7CiiT
         fwY50dDiLnFhAw2EtPWO7dILw5TklNsvYLETkyVyn9p+F17Xlpdi2+NMEE2opexsIY7r
         wYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9AI45ZOpupkZ8PCqEd2KJ2+crvZbRCWFsCnapW8KyMY=;
        b=BQZ+9yHM6HbNlJ7MACkrt2XHyUkKZjbnNpZkdCWLelpjx7iT8idYV4f0vC9zi4s1rJ
         UaeU1OXUM4pi/GHwPdaDMBQFaqU7NQ39c4Zp1xAQoQ9d0AJz8hwQBxJNbH4x3SoaX6rW
         bICEQ4lXExNK/QShA6BI672uiuXzqmwXc4lLphtkN0RH2+1JLPR8e6ReoHX243RLwgrm
         p/F1RDNldS5ogZj+hF3fnMVnKCIQAel0r+qF/mKXYGs8Vt+FsjAJJDPqDaCeGW4i9G6t
         Ggc5oTBfSrjWra9PrPhnfiwdiWMDQcftOPx7LMpcjwJEWS+c2ZRJGLJqsPBNlHy0wR+N
         aRwg==
X-Gm-Message-State: AO0yUKU4Bw5bX5/j01VTKNREqFz1YvYgGqVOKrJ1P70IkW+NyCgdDOBc
        FwU1n2HcTPuQo1khfNlnDHf+9xLHZFdaoQ==
X-Google-Smtp-Source: AK7set+vzUMKmmTrG0QTQ85W35LhRyzCBtUncA+XrTYOmSsEjZ1y5yh5UFGp928Rif+Q435sAgOLiILtsGL+DQ==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5070])
 (user=cmllamas job=sendgmr) by 2002:a25:98c4:0:b0:8b6:9639:950c with SMTP id
 m4-20020a2598c4000000b008b69639950cmr457339ybo.12.1676486345913; Wed, 15 Feb
 2023 10:39:05 -0800 (PST)
Date:   Wed, 15 Feb 2023 18:38:50 +0000
In-Reply-To: <Y+0WJuh1fIg0oEpR@google.com>
Mime-Version: 1.0
References: <Y+0WJuh1fIg0oEpR@google.com>
X-Mailer: git-send-email 2.39.1.637.g21b0678d19-goog
Message-ID: <20230215183850.3353198-1-cmllamas@google.com>
Subject: [PATCH v2] scripts/tags.sh: fix incompatibility with PCRE2
From:   Carlos Llamas <cmllamas@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, Carlos Llamas <cmllamas@google.com>,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jialu Xu <xujialu@vimux.org>,
        Vipin Sharma <vipinsh@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Starting with release 10.38 PCRE2 drops default support for using \K in
lookaround patterns as described in [1]. Unfortunately, scripts/tags.sh
relies on such functionality to collect all_compiled_soures() leading to
the following error:

  $ make COMPILED_SOURCE=1 tags
    GEN     tags
  grep: \K is not allowed in lookarounds (but see PCRE2_EXTRA_ALLOW_LOOKAROUND_BSK)

The usage of \K for this pattern was introduced in commit 4f491bb6ea2a
("scripts/tags.sh: collect compiled source precisely") which speeds up
the generation of tags significantly.

In order to fix this issue without compromising the performance we can
switch over to an equivalent sed expression. The same matching pattern
is preserved here except \K is replaced with a backreference \1.

[1] https://www.pcre.org/current/doc/html/pcre2syntax.html#SEC11

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Jialu Xu <xujialu@vimux.org>
Cc: Vipin Sharma <vipinsh@google.com>
Cc: stable@vger.kernel.org
Fixes: 4f491bb6ea2a ("scripts/tags.sh: collect compiled source precisely")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
v2: add Fixes tag and cc stable

 scripts/tags.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index e137cf15aae9..0d045182c08c 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -91,7 +91,7 @@ all_compiled_sources()
 	{
 		echo include/generated/autoconf.h
 		find $ignore -name "*.cmd" -exec \
-			grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
+			sed -n -E 's/^source_.* (.*)/\1/p; s/^  (\S.*) \\/\1/p' {} \+ |
 		awk '!a[$0]++'
 	} | xargs realpath -esq $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) |
 	sort -u
-- 
2.39.1.637.g21b0678d19-goog

