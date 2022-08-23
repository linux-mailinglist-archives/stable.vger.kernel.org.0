Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E09F59DFFF
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353104AbiHWKNA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352642AbiHWKJp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:09:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D3057E013;
        Tue, 23 Aug 2022 01:55:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BC97614E7;
        Tue, 23 Aug 2022 08:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38F9C433D6;
        Tue, 23 Aug 2022 08:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244957;
        bh=zWkpsM+SDxRe9i4P1nc7g3lxW/BQ0Z1ag1r4NHSl9aI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iaSCFF7hnYrLMSi+jXXASnWBNgphoDFYH0jRETMfJTc0894A3XTYGvyamT3EKTmw7
         ffClKEmeQ6BmnKadqOtT+YdFfCjTyN7JYa9ukXrTzW/Ol9R0Vjbu2HVqiUWSrLFmkG
         howf+YaLrrWRqwbaMebmfnfK91zhQhVhi6HNaDvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.15 151/244] kbuild: fix the modules order between drivers and libs
Date:   Tue, 23 Aug 2022 10:25:10 +0200
Message-Id: <20220823080104.219938671@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
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
@@ -1155,13 +1155,11 @@ vmlinux-alldirs	:= $(sort $(vmlinux-dirs
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


