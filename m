Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 546F9E62BA
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 14:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726898AbfJ0NuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 09:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbfJ0NuS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 09:50:18 -0400
Received: from localhost (unknown [77.241.229.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 993F4222BD;
        Sun, 27 Oct 2019 13:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572184218;
        bh=v1tTEbU8VyN9fz+96r4Gc6HAeYNRODRPhxochdoNREE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fyr60KSwpaHWwxbSfU4WElBe+XHerKpi4vgaMZSIshmSo5Sd4fCs1s7CaBNKWjpDB
         wjtG6ev5DR5yL9whA94eLglSlBNwfuObhM6SYyAOB4fJ/a7jJb9dPSFUJ2t9DAHKwm
         c8VrPp7shN5DIleuTJ0N5+83W5f9zD6OPYovKZbY=
Date:   Sun, 27 Oct 2019 14:50:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc:     stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH 4.4 1/2] x86/vdso: Remove direct HPET mapping into
 userspace
Message-ID: <20191027135013.GA2232759@kroah.com>
References: <157183247628.2324.16440279839073827980.stgit@buzz>
 <00665546-4ad7-758c-d205-02f2fdca7e6e@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00665546-4ad7-758c-d205-02f2fdca7e6e@yandex-team.ru>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 23, 2019 at 04:05:47PM +0300, Konstantin Khlebnikov wrote:
> On 23/10/2019 15.07, Konstantin Khlebnikov wrote:
> > commit 1ed95e52d902035e39a715ff3a314a893a96e5b7 upstream.
> > 
> > Commit d96d87834d5b870402a4a5b565706a4869ebc020 in v4.4.190 which is
> > backport of upstream commit 1ed95e52d902035e39a715ff3a314a893a96e5b7
> > removed only HPET access from vdso but leaved HPET mapped in "vvar".
> > So userspace still could read HPET directly and confuse hardware.
> > 
> > This patch removes mapping HPET page into userspace.
> > 
> > Fixes: d96d87834d5b ("x86/vdso: Remove direct HPET access through the vDSO") # v4.4.190
> > Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> > Link: https://lore.kernel.org/lkml/6fd42b2b-e29a-1fd6-03d1-e9da9192e6c5@yandex-team.ru/
> > ---
> >   arch/x86/entry/vdso/vma.c |   14 --------------
> >   1 file changed, 14 deletions(-)
> > 
> > diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
> > index 6b46648588d8..cc0a3c16a95d 100644
> > --- a/arch/x86/entry/vdso/vma.c
> > +++ b/arch/x86/entry/vdso/vma.c
> > @@ -18,7 +18,6 @@
> >   #include <asm/vdso.h>
> >   #include <asm/vvar.h>
> >   #include <asm/page.h>
> > -#include <asm/hpet.h>
> >   #include <asm/desc.h>
> >   #include <asm/cpufeature.h>
> > @@ -159,19 +158,6 @@ static int map_vdso(const struct vdso_image *image, bool calculate_addr)
> >   	if (ret)
> >   		goto up_fail;
> > -#ifdef CONFIG_HPET_TIMER
> > -	if (hpet_address && image->sym_hpet_page) {
> 
> Probably this patch is not required.
> It seems after removing symbol "hpet_page" from vdso code
> image->sym_hpet_page always is NULL and this branch never executed.

Ok, so these two patches are not needed?  I'll drop them from my
todo-queue, thanks.

greg k-h
