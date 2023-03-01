Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A74F86A72F0
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjCASKz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:10:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjCASKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:10:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D7D42BFF
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:10:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EE59B810DB
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE616C433D2;
        Wed,  1 Mar 2023 18:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694251;
        bh=sL9E7aXqzAJeeCcVzyUJVpyYHQXqHP5+00clrvbzG9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0P5Wu4RBr0GVlvA5MYb/+89Gl1dMNjIcA0crE6wjG80XC+QDPv1I/1/j5pc6Du9D5
         DrmpXcuAqSghzvel/8VGQUgELjj593RxKSN8D2FWyasyw/Ly3/b1ac2JOnkYhWBH83
         PCXaK1EEoDaMKgwXjbxnH4VVqgDAE8Wkl58V7pPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 5.15 17/22] scripts/tags.sh: Invoke realpath via xargs
Date:   Wed,  1 Mar 2023 19:08:50 +0100
Message-Id: <20230301180653.342663439@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>
References: <20230301180652.658125575@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

commit 7394d2ebb651a9f62e08c6ab864aac015d27c64d upstream.

When COMPILED_SOURCE is set, running

  make ARCH=x86_64 COMPILED_SOURCE=1 cscope tags

could throw the following errors:

scripts/tags.sh: line 98: /usr/bin/realpath: Argument list too long
cscope: no source files found
scripts/tags.sh: line 98: /usr/bin/realpath: Argument list too long
ctags: No files specified. Try "ctags --help".

This is most likely to happen when the kernel is configured to build a
large number of modules, which has the consequence of passing too many
arguments when calling 'realpath' in 'all_compiled_sources()'.

Let's improve this by invoking 'realpath' through 'xargs', which takes
care of properly limiting the argument list.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20220516234646.531208-1-cristian.ciocaltea@collabora.com
Cc: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/tags.sh |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -95,10 +95,13 @@ all_sources()
 
 all_compiled_sources()
 {
-	realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) \
-		include/generated/autoconf.h $(find $ignore -name "*.cmd" -exec \
-		grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
-		awk '!a[$0]++') | sort -u
+	{
+		echo include/generated/autoconf.h
+		find $ignore -name "*.cmd" -exec \
+			grep -Poh '(?(?=^source_.* \K).*|(?=^  \K\S).*(?= \\))' {} \+ |
+		awk '!a[$0]++'
+	} | xargs realpath -es $([ -z "$KBUILD_ABS_SRCTREE" ] && echo --relative-to=.) |
+	sort -u
 }
 
 all_target_sources()


