Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A856563564D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237790AbiKWJ3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237751AbiKWJ2x (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:28:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C18CE9CB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:27:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0982FB81EE5
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:27:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559D6C433D6;
        Wed, 23 Nov 2022 09:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669195619;
        bh=hjdF7tiMIelbbfSFs+dcstCCLuL2lsK2PLVN4UEC764=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aevyXi+YYyykGNgiw7/bYRol1Wx/YmvMEK07P+DNsssitlxeMYnMtK+JzURYLxX5+
         7S6C8BWTlJ+miC/yZ3FjDDMUhrc0xRYrnzcQOAUKFh7bgta8gnAC1I1uCTuEiYwF2r
         vomGxLUYC4DZMksPme0FJ7rlQiU8sP3fSEb3QFDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tadeusz Struk <tadeusz.struk@linaro.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 137/149] uapi/linux/stddef.h: Add include guards
Date:   Wed, 23 Nov 2022 09:52:00 +0100
Message-Id: <20221123084602.872382606@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
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

From: Tadeusz Struk <tadeusz.struk@linaro.org>

commit 55037ed7bdc62151a726f5685f88afa6a82959b1 upstream.

Add include guard wrapper define to uapi/linux/stddef.h to prevent macro
redefinition errors when stddef.h is included more than once. This was not
needed before since the only contents already used a redefinition test.

Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
Link: https://lore.kernel.org/r/20220329171252.57279-1-tadeusz.struk@linaro.org
Fixes: 50d7bd38c3aa ("stddef: Introduce struct_group() helper macro")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/stddef.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/uapi/linux/stddef.h
+++ b/include/uapi/linux/stddef.h
@@ -1,4 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_STDDEF_H
+#define _UAPI_LINUX_STDDEF_H
+
 #include <linux/compiler_types.h>
 
 #ifndef __always_inline
@@ -25,3 +28,4 @@
 		struct { MEMBERS } ATTRS; \
 		struct TAG { MEMBERS } ATTRS NAME; \
 	}
+#endif


