Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FE3132D55
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 18:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728407AbgAGRpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 12:45:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgAGRpO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 12:45:14 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7AD992087F;
        Tue,  7 Jan 2020 17:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578419114;
        bh=M513xx9aW4iTXzxgBQtHXhndgn/SODuepiJRUK+eM7I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YbkRh/JoQJSbTUir4FFdQGp2dTetaYhozBWn1KLHijLhjGocJSnXGTWmIXpssfckn
         LKfYzP3x4Sa4MC3IMDOShFVS85iurs1AZtc2GpxehTzUHVG32MTJbf1okn+fAtFII6
         kX0aRor1c/IMgN9KHEVY1m4OXGNi5jBEo0ArixDE=
Date:   Tue, 7 Jan 2020 17:45:09 +0000
From:   Will Deacon <will@kernel.org>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Amanieu d'Antras <amanieu@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        keescook@chromium.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 2/7] arm64: Implement copy_thread_tls
Message-ID: <20200107174508.GC32009@willie-the-truck>
References: <20200102172413.654385-1-amanieu@gmail.com>
 <20200102172413.654385-3-amanieu@gmail.com>
 <20200102180130.hmpipoiiu3zsl2d6@wittgenstein>
 <20200106173953.GB9676@willie-the-truck>
 <CA+y5pbSBYLvZ46nJP0pSYZnRohtPxHitOHPEaLXq23-QrPKk2g@mail.gmail.com>
 <20200107090219.jl4py4u2zvofwnbh@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200107090219.jl4py4u2zvofwnbh@wittgenstein>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 07, 2020 at 10:02:27AM +0100, Christian Brauner wrote:
> [Cc Kees in case he knows something about where arch specific tests live
>  or whether we have a framework for this]
> 
> On Mon, Jan 06, 2020 at 07:03:32PM +0100, Amanieu d'Antras wrote:
> > On Mon, Jan 6, 2020 at 6:39 PM Will Deacon <will@kernel.org> wrote:
> > > I also ran the native and compat selftests but, unfortunately, they all
> > > pass even without this patch. Do you reckon it would be possible to update
> > > them to check the tls pointer?
> > 
> > Here's the program I used for testing on arm64. I considered adding it
> > to the selftests but there is no portable way of reading the TLS
> > register on all architectures.
> 
> I'm not saying you need to do this right now.

Agreed, these patches should be merged in their current state and my ack
stands for that.

> It feels like we must've run into the "this is architecture
> specific"-and-we-want-to-test-this issue before... Do we have a place
> where architecture specific selftests live?

For arch-specific selftests there are tools/testing/selftests/$ARCH
directories, although in this case maybe it's better to have an #ifdef
in a header so that architectures with __builtin_thread_pointer can use
that.

Will
