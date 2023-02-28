Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D096A5EFC
	for <lists+stable@lfdr.de>; Tue, 28 Feb 2023 19:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjB1Stw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Feb 2023 13:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjB1Stv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Feb 2023 13:49:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D222A6E2
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 10:49:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A34C2B80EAA
        for <stable@vger.kernel.org>; Tue, 28 Feb 2023 18:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01763C433D2;
        Tue, 28 Feb 2023 18:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677610187;
        bh=n875INF9hu/zLQxYPxdclw3Qgu/MHP2vmyDReS/GJPk=;
        h=Subject:To:Cc:From:Date:From;
        b=LDG+xR2gqZhcmCXZUwyyWTQUCdKeFh62xb1WibiEpXfqVCCwQqKDxRSdLZPwbOjqs
         pcmdgAikGUDSTip3xsC8x+QvLHMDZsMbskABTzb8HnkQ1TDV1wLNspqOgZf4tAloaw
         v8eWDwdmeCdkBOxUHerxHstlXTkFmGhESvQR04OU=
Subject: FAILED: patch "[PATCH] scripts/tags.sh: fix incompatibility with PCRE2" failed to apply to 4.19-stable tree
To:     cmllamas@google.com, cristian.ciocaltea@collabora.com,
        gregkh@linuxfoundation.org, masahiroy@kernel.org,
        vipinsh@google.com, xujialu@vimux.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 28 Feb 2023 19:49:39 +0100
Message-ID: <1677610179159112@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6ec363fc6142 ("scripts/tags.sh: fix incompatibility with PCRE2")
7394d2ebb651 ("scripts/tags.sh: Invoke 'realpath' via 'xargs'")
162343a876f1 ("scripts/tags.sh: exclude tools directory from tags generation")
4f491bb6ea2a ("scripts/tags.sh: collect compiled source precisely")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6ec363fc6142226b9ab5a6528f65333d729d2b6b Mon Sep 17 00:00:00 2001
From: Carlos Llamas <cmllamas@google.com>
Date: Wed, 15 Feb 2023 18:38:50 +0000
Subject: [PATCH] scripts/tags.sh: fix incompatibility with PCRE2

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

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 1ad45f17179a..6b9001853890 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -98,7 +98,7 @@ all_compiled_sources()
 	{
 		echo include/generated/autoconf.h
 		find $ignore -name "*.cmd" -exec \
-			grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
+			sed -n -E 's/^source_.* (.*)/\1/p; s/^  (\S.*) \\/\1/p' {} \+ |
 		awk '!a[$0]++'
 	} | xargs realpath -esq $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) |
 	sort -u

