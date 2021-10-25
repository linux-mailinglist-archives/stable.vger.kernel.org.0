Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDFC643A325
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238901AbhJYT4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:56:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239252AbhJYTy1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:54:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1095D60F4F;
        Mon, 25 Oct 2021 19:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635191112;
        bh=HE4PmzW54rEQQgoPfYsS2lGpZo21B1lfgplaFYBTJBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LY5sNFC/IUi3wMQNTzJx8UgVlQls3jGqjnHznqPK+t/6EUDqYWg+rxGykTK+uSN+f
         IDlGwBEFCrXaAOYpbmBQRA9ueeKCyiFL+1DG+EyCOP4l2yxyKnlhTc4T2eQQDAeCys
         bRXhe3Zx66bgfOWJisxPtf3DYe6yOudpYRD1lwzk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        David Gow <davidgow@google.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 127/169] gcc-plugins/structleak: add makefile var for disabling structleak
Date:   Mon, 25 Oct 2021 21:15:08 +0200
Message-Id: <20211025191033.833556238@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

[ Upstream commit 554afc3b9797511e3245864e32aebeb6abbab1e3 ]

KUnit and structleak don't play nice, so add a makefile variable for
enabling structleak when it complains.

Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.gcc-plugins | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 952e46876329..4aad28480035 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -19,6 +19,10 @@ gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF)		\
 		+= -fplugin-arg-structleak_plugin-byref
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL)	\
 		+= -fplugin-arg-structleak_plugin-byref-all
+ifdef CONFIG_GCC_PLUGIN_STRUCTLEAK
+    DISABLE_STRUCTLEAK_PLUGIN += -fplugin-arg-structleak_plugin-disable
+endif
+export DISABLE_STRUCTLEAK_PLUGIN
 gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STRUCTLEAK)		\
 		+= -DSTRUCTLEAK_PLUGIN
 
-- 
2.33.0



