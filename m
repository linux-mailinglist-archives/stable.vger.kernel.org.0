Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEA859DFEE
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359492AbiHWML4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359844AbiHWMLS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:11:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975C3E2C5A;
        Tue, 23 Aug 2022 02:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C7D16148E;
        Tue, 23 Aug 2022 09:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDD2C433D6;
        Tue, 23 Aug 2022 09:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247497;
        bh=JqwqA8K/Bi/JlYaxPGlyPEUe8HAVD/tfbTEB5pz8NI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvVTtg0s6OyjH7QHREFlS5+ag8/5mpZCoH/wm+aXp9kTyJ2PCOvjmpuFjasXdAysB
         Qx43LdsInjBBK4MggClG/+5Xc9svm7m2rp2r1ANZ7H33xc2AsFroJ4xYOCCO3+PPf/
         AOUdLIP+Od5bn4+9na7M7tjFjjgHjR/NV1h5FkEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 055/158] kbuild: dummy-tools: avoid tmpdir leak in dummy gcc
Date:   Tue, 23 Aug 2022 10:26:27 +0200
Message-Id: <20220823080048.307327393@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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
@@ -77,12 +77,8 @@ fi
 
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
 


