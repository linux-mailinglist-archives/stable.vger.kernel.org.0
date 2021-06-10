Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD913A26F4
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 10:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhFJI1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 04:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbhFJI1h (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 04:27:37 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C306C0617A6;
        Thu, 10 Jun 2021 01:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OnS/2ehcGiHcLjbKewQz+Ha41vC4MyWtSGk/UFBkrDU=; b=B8wSJz/Q0jDIs9+hr+OC+RIGnZ
        CDUbj2W+Ls9G+Z9ipnrJXFzjBgQyV94hpAU0gD099Mbd0cBcpaEOT983mSI4dl4tk/QWn4AWbNYGP
        fej1hQlbiWI9iyZJdm8H60Zxso/AJK+nWBfYsQk4SX+u+SHpYaD9Vxe9Fu3nCXYJHXb4vUVi7Vx7f
        m0tcj1E1JvShiUwrh3YESMlvPnBivViCsxqDJQViUI+BdybYhounILpF5SLUR/cg3EB+ZkfeCNyET
        50z7/Xonri0qvIPhMQ1Bs2Y2dnwUGwQ1gJqD6vvznGNt3o9Ocls0QGTeldffKUltemOT1+wVDeUjA
        rBVA623Q==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lrG0A-005NZz-11; Thu, 10 Jun 2021 08:25:28 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3B6C5300299;
        Thu, 10 Jun 2021 10:25:28 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E513C233CB080; Thu, 10 Jun 2021 10:25:27 +0200 (CEST)
Date:   Thu, 10 Jun 2021 10:25:27 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [for-linus][PATCH 5/5] recordmcount: Correct st_shndx handling
Message-ID: <YMHMdxpzkuZx12Uf@hirez.programming.kicks-ass.net>
References: <20210610003344.783752614@goodmis.org>
 <20210610003736.777268599@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210610003736.777268599@goodmis.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 09, 2021 at 08:33:49PM -0400, Steven Rostedt wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> One should only use st_shndx when >SHN_UNDEF and <SHN_LORESERVE. When
> SHN_XINDEX, then use .symtab_shndx. Otherwise use 0.
> 
> This handles the case: st_shndx >= SHN_LORESERVE && st_shndx != SHN_XINDEX.
> 
> Link: https://lkml.kernel.org/r/YL9HxEc/l0yrl5o8@hirez.programming.kicks-ass.net
> 
> Cc: stable@vger.kernel.org
> Fixes: 4ef57b21d6fb4 ("recordmcount: support >64k sections")
> Reported-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
> Acked-by: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

This is apperently causing trouble for Stephen in -next. Please hold.
