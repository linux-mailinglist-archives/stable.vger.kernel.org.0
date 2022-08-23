Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77B159DBFF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349278AbiHWMSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356480AbiHWMPm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:15:42 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CAD67960C;
        Tue, 23 Aug 2022 02:41:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8B62CE1B5A;
        Tue, 23 Aug 2022 09:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D103DC433C1;
        Tue, 23 Aug 2022 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247622;
        bh=cVGm+Vjxw8Jv+M9DnbQRMTUqK+6WagTBRZOsSNTMfpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03G0+TGmKLFDp84gaW2Z5qr6Wmf4tz1fQEyJZZ20eT3KQYVB3MNL3kYx4GgPbVcvR
         WiTn+HxpQn2dyOS9meZBOUTC5UMNNSLJ0onEq9vHk9FExJWXBzc1DGhdS2Twf45+bx
         1t7j7W47U+vvtj3rK8AoWb9SW9+TAaNr0xq3ROpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 093/158] kbuild: fix the modules order between drivers and libs
Date:   Tue, 23 Aug 2022 10:27:05 +0200
Message-Id: <20220823080049.801391859@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

commit 113147510b48e764e624e3d0e6707a1e48bc05a9 upstream.

Commit b2c885549122 ("kbuild: update modules.order only when contained
modules are updated") accidentally changed the modules order.

Prior to that commit, the modules order was determined based on
vmlinux-dirs, which lists core-y/m, drivers-y/m, libs-y/m, in this order.

Now, subdir-modorder lists them in a different order: core-y/m, libs-y/m,
drivers-y/m.

Presumably, there was no practical issue because the modules in drivers
and libs are orthogonal, but there is no reason to have this distortion.

Get back to the original order.

Fixes: b2c885549122 ("kbuild: update modules.order only when contained modules are updated")
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -1133,13 +1133,11 @@ vmlinux-alldirs	:= $(sort $(vmlinux-dirs
 		     $(patsubst %/,%,$(filter %/, $(core-) \
 			$(drivers-) $(libs-))))
 
-subdir-modorder := $(addsuffix modules.order,$(filter %/, \
-			$(core-y) $(core-m) $(libs-y) $(libs-m) \
-			$(drivers-y) $(drivers-m)))
-
 build-dirs	:= $(vmlinux-dirs)
 clean-dirs	:= $(vmlinux-alldirs)
 
+subdir-modorder := $(addsuffix /modules.order, $(build-dirs))
+
 # Externally visible symbols (used by link-vmlinux.sh)
 KBUILD_VMLINUX_OBJS := $(head-y) $(patsubst %/,%/built-in.a, $(core-y))
 KBUILD_VMLINUX_OBJS += $(addsuffix built-in.a, $(filter %/, $(libs-y)))


