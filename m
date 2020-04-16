Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261AA1ABC54
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 11:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501905AbgDPJLl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 05:11:41 -0400
Received: from foss.arm.com ([217.140.110.172]:57146 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502322AbgDPIcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 04:32:22 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89B2BC14;
        Thu, 16 Apr 2020 01:32:08 -0700 (PDT)
Received: from gaia (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88A2D3F68F;
        Thu, 16 Apr 2020 01:32:07 -0700 (PDT)
Date:   Thu, 16 Apr 2020 09:32:05 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, broonie@kernel.org,
        szabolcs.nagy@arm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: Always force a branch protection
 mode when the" failed to apply to 5.6-stable tree
Message-ID: <20200416083204.GA19241@gaia>
References: <158694980415630@kroah.com>
 <20200416015121.GV1068@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200416015121.GV1068@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 09:51:21PM -0400, Sasha Levin wrote:
> On Wed, Apr 15, 2020 at 01:23:24PM +0200, gregkh@linuxfoundation.org wrote:
> > The patch below does not apply to the 5.6-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > ------------------ original commit in Linus's tree ------------------
> > 
> > From b8fdef311a0bd9223f10754f94fdcf1a594a3457 Mon Sep 17 00:00:00 2001
> > From: Mark Brown <broonie@kernel.org>
> > Date: Tue, 31 Mar 2020 20:44:59 +0100
> > Subject: [PATCH] arm64: Always force a branch protection mode when the
> > compiler has one
> > 
> > Compilers with branch protection support can be configured to enable it by
> > default, it is likely that distributions will do this as part of deploying
> > branch protection system wide. As well as the slight overhead from having
> > some extra NOPs for unused branch protection features this can cause more
> > serious problems when the kernel is providing pointer authentication to
> > userspace but not built for pointer authentication itself. In that case our
> > switching of keys for userspace can affect the kernel unexpectedly, causing
> > pointer authentication instructions in the kernel to corrupt addresses.
> > 
> > To ensure that we get consistent and reliable behaviour always explicitly
> > initialise the branch protection mode, ensuring that the kernel is built
> > the same way regardless of the compiler defaults.
> > 
> > Fixes: 7503197562567 (arm64: add basic pointer authentication support)
> > Reported-by: Szabolcs Nagy <szabolcs.nagy@arm.com>
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Cc: stable@vger.kernel.org
> > [catalin.marinas@arm.com: remove Kconfig option in favour of Makefile check]
> > Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> I don't think that this is needed anywhere without 74afda4016a7 ("arm64:
> compile the kernel with ptrauth return address signing")?

Good point. Mark, is the Fixes line above correct or it should have been
the one Sasha mentions?

-- 
Catalin
