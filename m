Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40AF59D65A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344068AbiHWIjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344284AbiHWIhP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:37:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CA577EB5;
        Tue, 23 Aug 2022 01:17:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C53BCCE1B34;
        Tue, 23 Aug 2022 08:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87EDC433C1;
        Tue, 23 Aug 2022 08:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242615;
        bh=epO8K098BtRj6Sc5ipRdBeNNa94m9Yx6xf3h4PdWRFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhJFL6nhxQEmCq8NbRpC4ENDNTtLzV5BWoujyXM1KcepPHwSPbpBMxVqfaWXzfMKs
         wiNXs03rq8N0b3fQRZci+Hf18zx/Qn07zJQ3yUm5vMsGIBaQ2qLbtSa0Nt8QOjEbfp
         sGYHvp0bX6n7wOFFKqP/8ma/09Xf98RBP4NkwC1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.19 145/365] kbuild: dummy-tools: avoid tmpdir leak in dummy gcc
Date:   Tue, 23 Aug 2022 10:00:46 +0200
Message-Id: <20220823080124.294570326@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ondrej Mosnacek <omosnace@redhat.com>

commit aac289653fa5adf9e9985e4912c1d24a3e8cbab2 upstream.

When passed -print-file-name=plugin, the dummy gcc script creates a
temporary directory that is never cleaned up. To avoid cluttering
$TMPDIR, instead use a static directory included in the source tree.

Fixes: 76426e238834 ("kbuild: add dummy toolchains to enable all cc-option etc. in Kconfig")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../dummy-tools/dummy-plugin-dir/include/plugin-version.h | 0
 scripts/dummy-tools/gcc |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)
 create mode 100644 scripts/dummy-tools/dummy-plugin-dir/include/plugin-version.h

--- a/scripts/dummy-tools/gcc
+++ b/scripts/dummy-tools/gcc
@@ -96,12 +96,8 @@ fi
 
 # To set GCC_PLUGINS
 if arg_contain -print-file-name=plugin "$@"; then
-	plugin_dir=$(mktemp -d)
-
-	mkdir -p $plugin_dir/include
-	touch $plugin_dir/include/plugin-version.h
-
-	echo $plugin_dir
+	# Use $0 to find the in-tree dummy directory
+	echo "$(dirname "$(readlink -f "$0")")/dummy-plugin-dir"
 	exit 0
 fi
 


