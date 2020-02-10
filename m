Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A651157884
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:08:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729447AbgBJMjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:39:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:37606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729440AbgBJMje (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:39:34 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84D8E20733;
        Mon, 10 Feb 2020 12:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338373;
        bh=U0zQcrD8B/Cl5/bp3cWObm1nBR8sbM5Dlvaf0yc0KW8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AHv9/lkKgN3NaIDnLka7tMJ+ERAUucSNanYc8mvoJg8xK7eqJqqYMkiN8tkI9j65l
         9qwvkb/tthLtAjdByRWGTUYDTcMPGZ9nBCSs4LyT7hV5M2usCG8qNFcR1bUfZHuIm6
         zQrGi27CJiMltGlGGoLjLJXwOM6dItEcKXFnGGfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 5.5 046/367] objtool: Silence build output
Date:   Mon, 10 Feb 2020 04:29:19 -0800
Message-Id: <20200210122428.290777184@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
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
@@ -48,5 +48,3 @@ check arch/x86/include/asm/inat.h     '-
 check arch/x86/include/asm/insn.h     '-I "^#include [\"<]\(asm/\)*inat.h[\">]"'
 check arch/x86/lib/inat.c             '-I "^#include [\"<]\(../include/\)*asm/insn.h[\">]"'
 check arch/x86/lib/insn.c             '-I "^#include [\"<]\(../include/\)*asm/in\(at\|sn\).h[\">]" -I "^#include [\"<]\(../include/\)*asm/emulate_prefix.h[\">]"'
-
-cd -


