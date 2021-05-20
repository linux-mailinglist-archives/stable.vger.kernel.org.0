Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 240B138A1C0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhETJey (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 05:34:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231929AbhETJce (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:32:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC745613EE;
        Thu, 20 May 2021 09:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621502905;
        bh=0ZKD8rf3+Vc1wjaTNw560g8nRWwhJ9F1LguEY8wn3Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UT+6c45r9KVwTm1yCwEW3B8afyg3JKCukW6AVcs/fWaq0GSu51aDwANCHccoqWtRD
         x/z4Ckcz1n4C+vHw21anR9MyEbNg6NhGHLmWYxUHgZ2n9APK3te3BA8w7KeNUA8/5M
         TBLhinA+xcWgLi4kASEngI74G13RwVEoyzKF+SF8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/37] pinctrl: ingenic: Improve unreachable code generation
Date:   Thu, 20 May 2021 11:22:27 +0200
Message-Id: <20210520092052.474597254@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092052.265851579@linuxfoundation.org>
References: <20210520092052.265851579@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josh Poimboeuf <jpoimboe@redhat.com>

[ Upstream commit d6d43a92172085a2681e06a0d06aac53c7bcdd12 ]

In the second loop of ingenic_pinconf_set(), it annotates the switch
default case as unreachable().  The annotation is technically correct,
because that same case would have resulted in an early function return
in the previous loop.

However, the compiled code is suboptimal.  GCC seems to work extra hard
to ensure that the unreachable code path triggers undefined behavior.
The function would fall through to start executing whatever function
happens to be next in the compilation unit.

This is problematic because:

  a) it adds unnecessary 'ensure undefined behavior' logic, and
     corresponding i-cache footprint; and

  b) it's less robust -- if a bug were to be introduced, falling through
     to the next function would be catastrophic.

Yet another issue is that, while objtool normally understands
unreachable() annotations, there's one special case where it doesn't:
when the annotation occurs immediately after a 'ret' instruction.  That
happens to be the case here because unreachable() is immediately before
the return.

Remove the unreachable() annotation and replace it with a comment.  This
simplifies the code generation and changes the unreachable error path to
just silently return instead of corrupting execution.

This fixes the following objtool warning:

  drivers/pinctrl/pinctrl-ingenic.o: warning: objtool: ingenic_pinconf_set() falls through to next function ingenic_pinconf_group_set()

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://lore.kernel.org/r/bc20fdbcb826512cf76b7dfd0972740875931b19.1582212881.git.jpoimboe@redhat.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ingenic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 61e7d938d4c5..91596eee0bda 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -1846,7 +1846,8 @@ static int ingenic_pinconf_set(struct pinctrl_dev *pctldev, unsigned int pin,
 			break;
 
 		default:
-			unreachable();
+			/* unreachable */
+			break;
 		}
 	}
 
-- 
2.30.2



