Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 649F1182E2
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 02:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfEIAjw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 May 2019 20:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726709AbfEIAjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 May 2019 20:39:52 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D72C620863;
        Thu,  9 May 2019 00:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557362391;
        bh=8Dqo7ID/B/CIwsN9jxTVpjR1pzNJfNt8P4RvYfYg+lo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EfiEtOcugO5SeYOu+Dksv1fTEXbXVbbQ63LtZNPs5mJXRzGHOBMR3060b2iUZulIQ
         mjebw+ljElN6+cDeKJuxTL4WJ5qJ+vVRRkLltyvvwqO3ANyDXnsHO29b3WaIyMmBii
         2TZNnzd3g2JubhnSBimmOOKZNkQyKxRPjxY931mM=
Date:   Wed, 8 May 2019 20:39:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Chris Brandt <chris.brandt@renesas.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ARM: 8680/1: boot/compressed: fix inappropriate Thumb2
 mnemonic for __nop
Message-ID: <20190509003949.GO1747@sasha-vm>
References: <20190508185951.41148-1-chris.brandt@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190508185951.41148-1-chris.brandt@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 08, 2019 at 01:59:51PM -0500, Chris Brandt wrote:
>From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
>[ Upstream commit 60ce2858514ed9ccaf00dc7e9f4dc219537e9855 ]
>
>Commit 06a4b6d009a1 ("ARM: 8677/1: boot/compressed: fix decompressor
>header layout for v7-M") fixed an issue in the layout of the header
>of the compressed kernel image that was caused by the assembler
>emitting narrow opcodes for 'mov r0, r0', and for this reason, the
>mnemonic was updated to use the W() macro, which will append the .w
>suffix (which forces a wide encoding) if required, i.e., when building
>the kernel in Thumb2 mode.
>
>However, this failed to take into account that on Thumb2 kernels built
>for CPUs that are also ARM capable, the entry point is entered in ARM
>mode, and so the instructions emitted here will be ARM instructions
>that only exist in a wide encoding to begin with, which is why the
>assembler rejects the .w suffix here and aborts the build with the
>following message:
>
>  head.S: Assembler messages:
>  head.S:132: Error: width suffixes are invalid in ARM mode -- `mov.w r0,r0'
>
>So replace the W(mov) with separate ARM and Thumb2 instructions, where
>the latter will only be used for THUMB2_ONLY builds.
>
>Fixes: 06a4b6d009a1 ("ARM: 8677/1: boot/compressed: fix decompressor ...")
>Reported-by: Arnd Bergmann <arnd@arndb.de>
>Acked-by: Arnd Bergmann <arnd@arndb.de>
>Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>Signed-off-by: Chris Brandt <chris.brandt@renesas.com>
>---
>
>For the 4.9.x tree, commit 7b5407843691 was applied, but that caused
>an issue for CONFIG_THUMB2 builds as you can see in the commit
>message above.
>
>Therefore, this upstream fix (that came 2 weeks later) is also required
>in the 4.9.x tree to make it build again.

I've queued 60ce2858514 for 4.9, thanks!

--
Thanks,
Sasha
