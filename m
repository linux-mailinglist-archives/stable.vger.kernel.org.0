Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61852181958
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:13:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgCKNNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:13:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbgCKNNP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 09:13:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E2E322464;
        Wed, 11 Mar 2020 13:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583932394;
        bh=1oMyqZhhouDDxXXOvmwgcXgxgUJvVopRYYmca3y7TKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qxxNTPn7MlwKwTypoj3+toFl5CVBiuIbgmaxMRvo9wEkhDAEr9ZveGaTfHuY4+nZD
         htik0wu7e/K8QusJBFTZpVQD2ljJwL4xnxoY0DWyVQQHDVRK38Xqf4bguvDSo1OXcf
         frcmSmNL4rOhMQiW1Kvw2vDuscYgJCE/Znn75HRw=
Date:   Wed, 11 Mar 2020 14:13:11 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4.19 84/86] efi/x86: Handle by-ref arguments covering
 multiple pages in mixed mode
Message-ID: <20200311131311.GA3858095@kroah.com>
References: <20200310124530.808338541@linuxfoundation.org>
 <20200310124535.409134291@linuxfoundation.org>
 <20200311130106.GB7285@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200311130106.GB7285@duo.ucw.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 02:01:07PM +0100, Pavel Machek wrote:
> Hi!
> 
> > Currently, the mixed mode runtime service wrappers require that all by-ref
> > arguments that live in the vmalloc space have a size that is a power of 2,
> > and are aligned to that same value. While this is a sensible way to
> > construct an object that is guaranteed not to cross a page boundary, it is
> > overly strict when it comes to checking whether a given object violates
> > this requirement, as we can simply take the physical address of the first
> > and the last byte, and verify that they point into the same physical
> > page.
> 
> Dunno. If start passing buffers that _sometime_ cross page boundaries,
> we'll get hard to debug failures. Maybe original code is better
> buecause it catches problems earlier?
> 
> Furthermore, all existing code should pass aligned, 2^n size buffers,
> so we should not need this in stable?

For some crazy reason you cut out the reason I applied this patch to the
stable tree.  From the changelog text:
	Fixes: f6697df36bdf0bf7 ("x86/efi: Prevent mixed mode boot corruption with CONFIG_VMAP_STACK=y")


