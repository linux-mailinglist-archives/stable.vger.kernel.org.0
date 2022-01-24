Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4EC49A8D7
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356155AbiAYDQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:16:40 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38446 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347526AbiAXTKn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:10:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50D66603DE;
        Mon, 24 Jan 2022 19:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2D2C340E5;
        Mon, 24 Jan 2022 19:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051442;
        bh=gk9HNkOw8giGGMPD+7p+DjpVIM6kP8mjUyFj3QJZWyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QrhU4twLkqiILEAvrVM1EYWORaJArw7eihFUHfGVHeM77RpD1/1CxL189+PMP36Xt
         dyqJC0NuIIm94niBwruduvdwP1Uh4sxj/W0bJ+zDE9aqglyS+K3/rlK3cgia6hNuof
         Z3tiK/rreBc2SU7UtDnpeH8yzH+W4nxxjz1w5fjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Naresh Kamboju <naresh.kamboju@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.14 163/186] powerpc/cell: Fix clang -Wimplicit-fallthrough warning
Date:   Mon, 24 Jan 2022 19:43:58 +0100
Message-Id: <20220124183942.352926189@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

commit e89257e28e844f5d1d39081bb901d9f1183a7705 upstream.

Clang warns:

arch/powerpc/platforms/cell/pervasive.c:81:2: error: unannotated fall-through between switch labels
        case SRR1_WAKEEE:
        ^
arch/powerpc/platforms/cell/pervasive.c:81:2: note: insert 'break;' to avoid fall-through
        case SRR1_WAKEEE:
        ^
        break;
1 error generated.

Clang is more pedantic than GCC, which does not warn when failing
through to a case that is just break or return. Clang's version is more
in line with the kernel's own stance in deprecated.rst. Add athe missing
break to silence the warning.

Fixes: 6e83985b0f6e ("powerpc/cbe: Do not process external or decremeter interrupts from sreset")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211207110228.698956-1-anders.roxell@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/cell/pervasive.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/powerpc/platforms/cell/pervasive.c
+++ b/arch/powerpc/platforms/cell/pervasive.c
@@ -90,6 +90,7 @@ static int cbe_system_reset_exception(st
 	switch (regs->msr & SRR1_WAKEMASK) {
 	case SRR1_WAKEDEC:
 		set_dec(1);
+		break;
 	case SRR1_WAKEEE:
 		/*
 		 * Handle these when interrupts get re-enabled and we take


