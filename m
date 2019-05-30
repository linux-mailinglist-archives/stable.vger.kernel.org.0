Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 746422F163
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730675AbfE3DQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:42540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730669AbfE3DQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:16:26 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E3E824598;
        Thu, 30 May 2019 03:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186185;
        bh=jxFEU4hEZfRWH8xSa6TsEgftBEFtYHFMd2kCHP1i7X8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kQdE251QhUQcGPYzLahh3SO2USTdtnMxeIhyMqyeZFFtNvcFXwyl7+SWN8yKgTX2q
         C5EwGuU/kxA0lFKKpRAluawyAZhLKc+RWGujUdiJ509ZXUC4zuRLFXfkm1PV77uvDF
         +481WXRosXEER2+/iUNl6c8PKrLfEzmVuiBB39aM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 052/276] bpftool: exclude bash-completion/bpftool from .gitignore pattern
Date:   Wed, 29 May 2019 20:03:30 -0700
Message-Id: <20190530030528.333890209@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030523.133519668@linuxfoundation.org>
References: <20190530030523.133519668@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit a7d006714724de4334c5e3548701b33f7b12ca96 ]

tools/bpf/bpftool/.gitignore has the "bpftool" pattern, which is
intended to ignore the following build artifact:

  tools/bpf/bpftool/bpftool

However, the .gitignore entry is effective not only for the current
directory, but also for any sub-directories.

So, from the point of .gitignore grammar, the following check-in file
is also considered to be ignored:

  tools/bpf/bpftool/bash-completion/bpftool

As the manual gitignore(5) says "Files already tracked by Git are not
affected", this is not a problem as far as Git is concerned.

However, Git is not the only program that parses .gitignore because
.gitignore is useful to distinguish build artifacts from source files.

For example, tar(1) supports the --exclude-vcs-ignore option. As of
writing, this option does not work perfectly, but it intends to create
a tarball excluding files specified by .gitignore.

So, I believe it is better to fix this issue.

You can fix it by prefixing the pattern with a slash; the leading slash
means the specified pattern is relative to the current directory.

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/.gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/.gitignore b/tools/bpf/bpftool/.gitignore
index 67167e44b7266..8248b8dd89d4b 100644
--- a/tools/bpf/bpftool/.gitignore
+++ b/tools/bpf/bpftool/.gitignore
@@ -1,5 +1,5 @@
 *.d
-bpftool
+/bpftool
 bpftool*.8
 bpf-helpers.*
 FEATURE-DUMP.bpftool
-- 
2.20.1



