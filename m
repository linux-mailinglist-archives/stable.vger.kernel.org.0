Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF4766C1AF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbjAPOOw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232590AbjAPOOE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:14:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A749D23336;
        Mon, 16 Jan 2023 06:05:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16EA660FDE;
        Mon, 16 Jan 2023 14:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B568C433EF;
        Mon, 16 Jan 2023 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877919;
        bh=wGOzJL29GJYJd5eJYqgiIGm2R4h4WfIptHWTivlXHO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dquRjyJ47tIP2Xks8UxNQqxkjZwxg1MQL72AfBvr3TPnO/VHR7WhavBZ0p3nwvYAG
         0Q3DAYLVRW1Gat6VIwde3y6ADVKEJckx3gws+Tyyi6fBydiP7uM9epL51JdAyeQGtY
         0kuq4+/oW97mRFIEBPm/QrbNhFVxDwAFamCEVRrUTkfTyq9hNXy9/73cjHXg2NKl2V
         XyzJmBS5hrvvWry4YsqFh5aVpmTf7oNuunAnQIoh4HN20o4+cVWZTQqm3n8GC2NFuF
         +V+HEYpgl9AIA+4pY8KtUza6wmFC8w/TZMco9qAC3CauuuFWzEsBgfsuvbDv2Q8E1Y
         s1OnqXGLwK9AA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mateusz Guzik <mjguzik@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, ubizjak@gmail.com
Subject: [PATCH AUTOSEL 5.10 17/17] lockref: stop doing cpu_relax in the cmpxchg loop
Date:   Mon, 16 Jan 2023 09:04:48 -0500
Message-Id: <20230116140448.116034-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140448.116034-1-sashal@kernel.org>
References: <20230116140448.116034-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit f5fe24ef17b5fbe6db49534163e77499fb10ae8c ]

On the x86-64 architecture even a failing cmpxchg grants exclusive
access to the cacheline, making it preferable to retry the failed op
immediately instead of stalling with the pause instruction.

To illustrate the impact, below are benchmark results obtained by
running various will-it-scale tests on top of the 6.2-rc3 kernel and
Cascade Lake (2 sockets * 24 cores * 2 threads) CPU.

All results in ops/s.  Note there is some variance in re-runs, but the
code is consistently faster when contention is present.

  open3 ("Same file open/close"):
  proc          stock       no-pause
     1         805603         814942       (+%1)
     2        1054980        1054781       (-0%)
     8        1544802        1822858      (+18%)
    24        1191064        2199665      (+84%)
    48         851582        1469860      (+72%)
    96         609481        1427170     (+134%)

  fstat2 ("Same file fstat"):
  proc          stock       no-pause
     1        3013872        3047636       (+1%)
     2        4284687        4400421       (+2%)
     8        3257721        5530156      (+69%)
    24        2239819        5466127     (+144%)
    48        1701072        5256609     (+209%)
    96        1269157        6649326     (+423%)

Additionally, a kernel with a private patch to help access() scalability:
access2 ("Same file access"):

  proc          stock        patched      patched
                                         +nopause
    24        2378041        2005501      5370335  (-15% / +125%)

That is, fixing the problems in access itself *reduces* scalability
after the cacheline ping-pong only happens in lockref with the pause
instruction.

Note that fstat and access benchmarks are not currently integrated into
will-it-scale, but interested parties can find them in pull requests to
said project.

Code at hand has a rather tortured history.  First modification showed
up in commit d472d9d98b46 ("lockref: Relax in cmpxchg loop"), written
with Itanium in mind.  Later it got patched up to use an arch-dependent
macro to stop doing it on s390 where it caused a significant regression.
Said macro had undergone revisions and was ultimately eliminated later,
going back to cpu_relax.

While I intended to only remove cpu_relax for x86-64, I got the
following comment from Linus:

    I would actually prefer just removing it entirely and see if
    somebody else hollers. You have the numbers to prove it hurts on
    real hardware, and I don't think we have any numbers to the
    contrary.

    So I think it's better to trust the numbers and remove it as a
    failure, than say "let's just remove it on x86-64 and leave
    everybody else with the potentially broken code"

Additionally, Will Deacon (maintainer of the arm64 port, one of the
architectures previously benchmarked):

    So, from the arm64 side of the fence, I'm perfectly happy just
    removing the cpu_relax() calls from lockref.

As such, come back full circle in history and whack it altogether.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://lore.kernel.org/all/CAGudoHHx0Nqg6DE70zAVA75eV-HXfWyhVMWZ-aSeOofkA_=WdA@mail.gmail.com/
Acked-by: Tony Luck <tony.luck@intel.com> # ia64
Acked-by: Nicholas Piggin <npiggin@gmail.com> # powerpc
Acked-by: Will Deacon <will@kernel.org> # arm64
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/lockref.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/lib/lockref.c b/lib/lockref.c
index 5b34bbd3eba8..81ac5f355242 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -24,7 +24,6 @@
 		}								\
 		if (!--retry)							\
 			break;							\
-		cpu_relax();							\
 	}									\
 } while (0)
 
-- 
2.35.1

