Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71EAE1F510
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 15:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfEONI2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 09:08:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:39722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfEONI2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 09:08:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CED420843;
        Wed, 15 May 2019 13:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557925708;
        bh=P/T1WxbT7QsT7n7T6kKsFUprJ4xg3X1OufDN3pOJn6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NaTpMBcwvLyk0lxuChYO5NCNr6wrhTgRpvZ3Te9tvINP1yrMpr8UTn0dGzFkqQbPh
         dyIQga3BTA4d9o+md+t0r51V1Pj+KITYxqtB4BAnmeSHiUy0pFJqe13Iv2rRP47qHt
         wrrz+EgagCu310C8uIhsaCn2RElw6r2qgoVZDYmU=
Date:   Wed, 15 May 2019 15:08:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, erhard_f@mailbox.org,
        Michael Neuling <mikey@neuling.org>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH stable 4.9] powerpc/lib: fix book3s/32 boot failure due
 to code patching
Message-ID: <20190515130825.GA3794@kroah.com>
References: <629c2acb1fcd09c2d2e3352370c3d9853372cf39.1557902321.git.christophe.leroy@c-s.fr>
 <20190515082931.GA28349@kroah.com>
 <9e58348f-da2d-34bc-d016-7817b3566e01@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9e58348f-da2d-34bc-d016-7817b3566e01@c-s.fr>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 02:35:36PM +0200, Christophe Leroy wrote:
> 
> 
> Le 15/05/2019 à 10:29, Greg KH a écrit :
> > On Wed, May 15, 2019 at 06:40:47AM +0000, Christophe Leroy wrote:
> > > [Backport of upstream commit b45ba4a51cde29b2939365ef0c07ad34c8321789]
> > > 
> > > On powerpc32, patch_instruction() is called by apply_feature_fixups()
> > > which is called from early_init()
> > > 
> > > There is the following note in front of early_init():
> > >   * Note that the kernel may be running at an address which is different
> > >   * from the address that it was linked at, so we must use RELOC/PTRRELOC
> > >   * to access static data (including strings).  -- paulus
> > > 
> > > Therefore init_mem_is_free must be accessed with PTRRELOC()
> > > 
> > > Fixes: 1c38a84d4586 ("powerpc: Avoid code patching freed init sections")
> > > Link: https://bugzilla.kernel.org/show_bug.cgi?id=203597
> > > Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
> > > 
> > > ---
> > > Can't apply the upstream commit as such due to several other unrelated stuff
> > > like for instance STRICT_KERNEL_RWX which are missing.
> > > So instead, using same approach as for commit 252eb55816a6f69ef9464cad303cdb3326cdc61d
> > 
> > Now queued up, thanks.
> > 
> 
> Should go to 4.4 as well since the commit it fixes is now queued for 4.4
> ([PATCH 4.4 056/266] powerpc: Avoid code patching freed init sections)

Ok, can someone send me a backport that actually applies there?

thanks,

greg k-h
