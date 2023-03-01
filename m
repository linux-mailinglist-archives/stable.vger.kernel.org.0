Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64FE76A72DE
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjCASKX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjCASKS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D04E14BE95
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5394161466
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A6BC4339B;
        Wed,  1 Mar 2023 18:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694211;
        bh=rUrXEsO9Vl2PFEaMgnHOwelavzTkONbffiHDKsByVNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4qx65OjWfV3jC7ejlvBG3tBREcHc1Eaq0twJgE7kxRTME+ViJDQy6YNGJeWop8gj
         CeSQgLatpZyJIomh/4P+5J5hd8VN0wtmO5vWl8JzuYcCBMxhUHRWvFocJiiBW8TRLQ
         0djpljQPNDu+hyycm7E4xfguC18n/m1I6trhrOqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jialu Xu <xujialu@vimux.org>,
        Vipin Sharma <vipinsh@google.com>,
        Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.10 14/19] scripts/tags.sh: fix incompatibility with PCRE2
Date:   Wed,  1 Mar 2023 19:08:43 +0100
Message-Id: <20230301180652.919259284@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.316428563@linuxfoundation.org>
References: <20230301180652.316428563@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit 6ec363fc6142226b9ab5a6528f65333d729d2b6b upstream.

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
Link: https://lore.kernel.org/r/20230215183850.3353198-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/tags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -98,7 +98,7 @@ all_compiled_sources()
 	{
 		echo include/generated/autoconf.h
 		find $ignore -name "*.cmd" -exec \
-			grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
+			sed -n -E 's/^source_.* (.*)/\1/p; s/^  (\S.*) \\/\1/p' {} \+ |
 		awk '!a[$0]++'
 	} | xargs realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) |
 	sort -u


