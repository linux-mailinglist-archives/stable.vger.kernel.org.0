Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1681B3FA4
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730826AbgDVKjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbgDVKVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:21:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26ED920776;
        Wed, 22 Apr 2020 10:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550881;
        bh=NaUgTf5CoPckAeswaR8INBW8wgTIhdKbod2hpVowooM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fx5crBn+ageKeDJHkrWlKhHCwSylZiCVv1a4B2FmW623HG7uOfINvh+XZBx+3QmPq
         Q+lhTQsu8V8JGlISHQCmf/09WZxoJ88G/ohs6IYR0xMPMzwNQrXiTv4xMx+gBoB6xj
         IZ1TsdWEuGhcR07WuYGl7N4rcKrX5VLouSil7q+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Liu Yiding <liuyd.fnst@cn.fujitsu.com>,
        Slava Bacherikov <slava@bacher09.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kees Cook <keescook@chromium.org>,
        KP Singh <kpsingh@google.com>, Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 5.6 013/166] kbuild, btf: Fix dependencies for DEBUG_INFO_BTF
Date:   Wed, 22 Apr 2020 11:55:40 +0200
Message-Id: <20200422095049.715550359@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slava Bacherikov <slava@bacher09.org>

commit 7d32e69310d67e6b04af04f26193f79dfc2f05c7 upstream.

Currently turning on DEBUG_INFO_SPLIT when DEBUG_INFO_BTF is also
enabled will produce invalid btf file, since gen_btf function in
link-vmlinux.sh script doesn't handle *.dwo files.

Enabling DEBUG_INFO_REDUCED will also produce invalid btf file,
and using GCC_PLUGIN_RANDSTRUCT with BTF makes no sense.

Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")
Reported-by: Jann Horn <jannh@google.com>
Reported-by: Liu Yiding <liuyd.fnst@cn.fujitsu.com>
Signed-off-by: Slava Bacherikov <slava@bacher09.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: KP Singh <kpsingh@google.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200402204138.408021-1-slava@bacher09.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/Kconfig.debug |    2 ++
 1 file changed, 2 insertions(+)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -241,6 +241,8 @@ config DEBUG_INFO_DWARF4
 config DEBUG_INFO_BTF
 	bool "Generate BTF typeinfo"
 	depends on DEBUG_INFO
+	depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
+	depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
 	help
 	  Generate deduplicated BTF type information from DWARF debug info.
 	  Turning this on expects presence of pahole tool, which will convert


