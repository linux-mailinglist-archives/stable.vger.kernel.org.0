Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77EB54726C7
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbhLMJyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:54:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42924 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237900AbhLMJwQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:52:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01BF9CE0DDE;
        Mon, 13 Dec 2021 09:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A95E1C00446;
        Mon, 13 Dec 2021 09:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389133;
        bh=sg68J44qRYs5VJblzylihmVmIW1LKKXSLtAEAQTYjks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WluRqfAFx55mtpU3iwJGBmXFyyySMx0puXN06NRjiATX98qAoKhPNog3M/LSow51f
         xXyJ9HSNNcrb4fd2qKbcZmuS71BMfDRz1BygZ1TJ10MgvV5igX5NLcuDGuj/Z15CtI
         GVsaWY7aPtErhnFBBlESvtxnMxU+pSiyPKhcqbnA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 5.10 129/132] kbuild: simplify GCC_PLUGINS enablement in dummy-tools/gcc
Date:   Mon, 13 Dec 2021 10:31:10 +0100
Message-Id: <20211213092943.523382782@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit f4c3b83b75b91c5059726cb91e3165cc01764ce7 upstream.

With commit 1e860048c53e ("gcc-plugins: simplify GCC plugin-dev
capability test") applied, this hunk can be way simplified because
now scripts/gcc-plugins/Kconfig only checks plugin-version.h

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/dummy-tools/gcc |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/scripts/dummy-tools/gcc
+++ b/scripts/dummy-tools/gcc
@@ -75,16 +75,12 @@ if arg_contain -S "$@"; then
 	fi
 fi
 
-# For scripts/gcc-plugin.sh
+# To set GCC_PLUGINS
 if arg_contain -print-file-name=plugin "$@"; then
 	plugin_dir=$(mktemp -d)
 
-	sed -n 's/.*#include "\(.*\)"/\1/p' $(dirname $0)/../gcc-plugins/gcc-common.h |
-	while read header
-	do
-		mkdir -p $plugin_dir/include/$(dirname $header)
-		touch $plugin_dir/include/$header
-	done
+	mkdir -p $plugin_dir/include
+	touch $plugin_dir/include/plugin-version.h
 
 	echo $plugin_dir
 	exit 0


