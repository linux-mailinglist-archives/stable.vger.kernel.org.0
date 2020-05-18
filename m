Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F261D8150
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730138AbgERRq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:46:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:47022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730157AbgERRq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:46:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CAED20671;
        Mon, 18 May 2020 17:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824016;
        bh=sYrDc6GAC47/RF3m0aWBOQNtFs0dz+smkd8+AU7MabU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXvstLnMwui0X9RMDkiyewmjkVN+Fc5zMRFi4bdi+1GI/2C7KVqXjtnIYPi2zxC9Y
         sqPA4FsdlbrvAXrQhloAJIVHLHq5eXQ75/GVe2Lo7ZAZRkg0NgXN4Gwwot6NszwVQU
         ydwZ4jMa66Qj177+cfzqmgTEILKLSZcuQ2kk529g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ivan Delalande <colona@arista.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 036/114] scripts/decodecode: fix trapping instruction formatting
Date:   Mon, 18 May 2020 19:36:08 +0200
Message-Id: <20200518173510.136019397@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ivan Delalande <colona@arista.com>

commit e08df079b23e2e982df15aa340bfbaf50f297504 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/decodecode |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/decodecode
+++ b/scripts/decodecode
@@ -99,7 +99,7 @@ faultlinenum=$(( $(wc -l $T.oo  | cut -d
 faultline=`cat $T.dis | head -1 | cut -d":" -f2-`
 faultline=`echo "$faultline" | sed -e 's/\[/\\\[/g; s/\]/\\\]/g'`
 
-cat $T.oo | sed -e "${faultlinenum}s/^\(.*:\)\(.*\)/\1\*\2\t\t<-- trapping instruction/"
+cat $T.oo | sed -e "${faultlinenum}s/^\([^:]*:\)\(.*\)/\1\*\2\t\t<-- trapping instruction/"
 echo
 cat $T.aa
 cleanup


