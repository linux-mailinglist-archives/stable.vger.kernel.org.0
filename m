Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE06157AC5
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731166AbgBJNZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:25:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:57520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728573AbgBJMg5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:36:57 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFBC824671;
        Mon, 10 Feb 2020 12:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338217;
        bh=mKbHDyqHzQt1bToSX31/M4PiWonwYV2QnRGfpBQxjpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R3Tt2A6IQgvHRg4QAhqXHg+OFDcP4hq0G6gRpA4rVFp1QmKL38RBQPRsew4MRexSJ
         SerKzQqdvdF1sfWOET9jyIPLN7Q8bKQcTbic2qucdqDbYYjwnuP47jVVgoy0EVmdHC
         p9MWB3WHbGHFJHWThNRP73DZoa1Xoql/wBWSULzo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.4 040/309] objtool: Silence build output
Date:   Mon, 10 Feb 2020 04:29:56 -0800
Message-Id: <20200210122409.934379462@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Olof Johansson <olof@lixom.net>

commit 6ec14aa7a58a1c2fb303692f8cb1ff82d9abd10a upstream.

The sync-check.sh script prints out the path due to a "cd -" at the end
of the script, even on silent builds. This isn't even needed, since the
script is executed in our build instead of sourced (so it won't change
the working directory of the surrounding build anyway).

Just remove the cd to make the build silent.

Fixes: 2ffd84ae973b ("objtool: Update sync-check.sh from perf's check-headers.sh")
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/cb002857fafa8186cfb9c3e43fb62e4108a1bab9.1579543924.git.jpoimboe@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/objtool/sync-check.sh |    2 --
 1 file changed, 2 deletions(-)

--- a/tools/objtool/sync-check.sh
+++ b/tools/objtool/sync-check.sh
@@ -47,5 +47,3 @@ check arch/x86/include/asm/inat.h     '-
 check arch/x86/include/asm/insn.h     '-I "^#include [\"<]\(asm/\)*inat.h[\">]"'
 check arch/x86/lib/inat.c             '-I "^#include [\"<]\(../include/\)*asm/insn.h[\">]"'
 check arch/x86/lib/insn.c             '-I "^#include [\"<]\(../include/\)*asm/in\(at\|sn\).h[\">]"'
-
-cd -


