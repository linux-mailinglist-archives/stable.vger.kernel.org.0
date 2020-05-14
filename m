Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401281D3A67
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 20:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgENS4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 14:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:57336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729696AbgENS4Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 May 2020 14:56:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B59B207DA;
        Thu, 14 May 2020 18:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589482584;
        bh=+yB8NAXvhlYkOZe9oqnQrrDCnWaEgp9K7qrE3bWQmbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kNgxYd1RyTGXbxAybQaKCefuacm6bW9fyIznt95F/FcyYtlkJX5mOMfqgH/yCHzm2
         bO/SlpjPuYp3asAUSK8O2pxQZ21kqjVsPAZX7my1vpsAlNMDDIfKiufmfnQbfYab2y
         BZnci5YMOhNhJDaa050zRIdXV0RUXh+xWL1z1h3A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ivan Delalande <colona@arista.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 27/27] scripts/decodecode: fix trapping instruction formatting
Date:   Thu, 14 May 2020 14:55:50 -0400
Message-Id: <20200514185550.21462-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200514185550.21462-1-sashal@kernel.org>
References: <20200514185550.21462-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Delalande <colona@arista.com>

[ Upstream commit e08df079b23e2e982df15aa340bfbaf50f297504 ]

If the trapping instruction contains a ':', for a memory access through
segment registers for example, the sed substitution will insert the '*'
marker in the middle of the instruction instead of the line address:

	2b:   65 48 0f c7 0f          cmpxchg16b %gs:*(%rdi)          <-- trapping instruction

I started to think I had forgotten some quirk of the assembly syntax
before noticing that it was actually coming from the script.  Fix it to
add the address marker at the right place for these instructions:

	28:   49 8b 06                mov    (%r14),%rax
	2b:*  65 48 0f c7 0f          cmpxchg16b %gs:(%rdi)           <-- trapping instruction
	30:   0f 94 c0                sete   %al

Fixes: 18ff44b189e2 ("scripts/decodecode: make faulting insn ptr more robust")
Signed-off-by: Ivan Delalande <colona@arista.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Borislav Petkov <bp@suse.de>
Link: http://lkml.kernel.org/r/20200419223653.GA31248@visor
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/decodecode | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/decodecode b/scripts/decodecode
index d8824f37acce9..aae7a035242b2 100755
--- a/scripts/decodecode
+++ b/scripts/decodecode
@@ -98,7 +98,7 @@ faultlinenum=$(( $(wc -l $T.oo  | cut -d" " -f1) - \
 faultline=`cat $T.dis | head -1 | cut -d":" -f2-`
 faultline=`echo "$faultline" | sed -e 's/\[/\\\[/g; s/\]/\\\]/g'`
 
-cat $T.oo | sed -e "${faultlinenum}s/^\(.*:\)\(.*\)/\1\*\2\t\t<-- trapping instruction/"
+cat $T.oo | sed -e "${faultlinenum}s/^\([^:]*:\)\(.*\)/\1\*\2\t\t<-- trapping instruction/"
 echo
 cat $T.aa
 cleanup
-- 
2.20.1

