Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AA2406BFA
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbhIJMgE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:52702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234033AbhIJMfI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:35:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18A3E611CC;
        Fri, 10 Sep 2021 12:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277237;
        bh=MsUrpv+8nCOeEELFJtLuUlsx1w8G5rLltBS4j9M9LU0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLO87TRjjtCTqYd60qXC6ecRVUnMExbqnnHzZ7YcXyiDQJdBz4wyRK+bqRFyeO/RC
         ZAdDqDi0nxA3EY8G8lB6ZEFhbo24X2L685EUo2Uq0+V8u/i+mzI08RY3MSrp80xC6n
         04ebU4tsePCfo75V1ShSItXkbAuwkno0dMlecl7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 05/26] net: kcov: dont select SKB_EXTENSIONS when there is no NET
Date:   Fri, 10 Sep 2021 14:30:09 +0200
Message-Id: <20210910122916.426335728@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.253646001@linuxfoundation.org>
References: <20210910122916.253646001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit 85ce50d337d10a6fd328fa70b0a15543bf5c0f64 upstream.

Fix kconfig warning when CONFIG_NET is not set/enabled:

WARNING: unmet direct dependencies detected for SKB_EXTENSIONS
  Depends on [n]: NET [=n]
  Selected by [y]:
  - KCOV [=y] && ARCH_HAS_KCOV [=y] && (CC_HAS_SANCOV_TRACE_PC [=y] || GCC_PLUGINS [=n])

Fixes: 6370cc3bbd8a ("net: add kcov handle to skb extensions")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Aleksandr Nogikh <nogikh@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20201110175746.11437-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1869,7 +1869,7 @@ config KCOV
 	depends on CC_HAS_SANCOV_TRACE_PC || GCC_PLUGINS
 	select DEBUG_FS
 	select GCC_PLUGIN_SANCOV if !CC_HAS_SANCOV_TRACE_PC
-	select SKB_EXTENSIONS
+	select SKB_EXTENSIONS if NET
 	help
 	  KCOV exposes kernel code coverage information in a form suitable
 	  for coverage-guided fuzzing (randomized testing).


