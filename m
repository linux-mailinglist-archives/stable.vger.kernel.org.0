Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9118F12E9E0
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 19:24:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgABSYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 13:24:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42832 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgABSYs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 13:24:48 -0500
Received: from [172.58.107.60] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1in59J-0000wJ-Ex; Thu, 02 Jan 2020 18:24:46 +0000
Date:   Thu, 2 Jan 2020 19:24:41 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Amanieu d'Antras <amanieu@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        stable@vger.kernel.org
Subject: Re: [PATCH 7/7] clone3: ensure copy_thread_tls is implemented
Message-ID: <20200102182439.kzqabfuadph5cvaf@wittgenstein>
References: <20200102172413.654385-1-amanieu@gmail.com>
 <20200102172413.654385-8-amanieu@gmail.com>
 <20200102180901.tgtl7wxtq434h5ny@wittgenstein>
 <CA+y5pbT8yhDEjHnZvGcKM3=H2a+hjY0QOQZOu=YjnvPOJC00Gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+y5pbT8yhDEjHnZvGcKM3=H2a+hjY0QOQZOu=YjnvPOJC00Gg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 07:19:11PM +0100, Amanieu d'Antras wrote:
> On Thu, Jan 2, 2020 at 7:09 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> > I'm in favor of this change. But we need to make sure that any arch
> > which now has ARCH_WANTS_SYS_CLONE3 set but doesn't implement
> > copy_thread_tls() is fixed.
> >
> > Once all architectures have clone3() support - and there are
> > just a few by now (IA64 comes to mind) this means we should also be able
> > to get rid of of copy_thread() completely. That seems desirable to me as
> > it makes the codepaths easier to follow.
> 
> I've already implemented copy_thread_tls for all arches that currently
> have ARCH_WANTS_SYS_CLONE3 in the previous 5 patches. The #error is
> there so that any future arches that wire up clone3 don't forget to
> implement copy_thread_tls as well.

Right, my point is: Once _all_ arches have ARCH_WANT_SYS_CLONE3 they
also must implement copy_thread_tls at which point we can remove:
- ARCH_WANT_SYS_CLONE3 ifdefines
- copy_thread()
We can't do this right now because e.g. IA64 does not set
ARCH_WANT_SYS_CLONE3 and also does not select HAVE_COPY_THREAD_TLS.

Christian
