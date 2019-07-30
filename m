Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 530AE7AC57
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 17:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731631AbfG3P13 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 11:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730358AbfG3P13 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 11:27:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BABE206E0;
        Tue, 30 Jul 2019 15:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564500448;
        bh=ARWovAtvDYFgdCMxhR0wGmJLh08PeKXgvSRjCyUtfi0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l0Zz+PVUY6FoxzZtz+A4dN6q0ZKkFHQ/TA7SaDehdEnhVWL0iSitVi3VKLP9tMFOv
         EBwzsZhYQJHqGYcDwETj4QzXpUXUy53PyYhSXeo1fFpFCN0HHc7Qj+iKK4nYJpbjTv
         VO2EdX9oTlziH1vKYCBInWp8fpwM362GwV8E5Eb8=
Date:   Tue, 30 Jul 2019 17:27:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     "Souza, Jose" <jose.souza@intel.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Pandiyan, Dhinakaran" <dhinakaran.pandiyan@intel.com>
Subject: Re: [Intel-gfx] [PATCH stable v5.2] drm/i915/vbt: Fix VBT parsing
 for the PSR section
Message-ID: <20190730152724.GB31590@kroah.com>
References: <20190719004526.B0CC521850@mail.kernel.org>
 <20190722231325.16615-1-dhinakaran.pandiyan@intel.com>
 <20190724120657.GG3244@kroah.com>
 <05339e812e35a4cf1811f26a06bd5a4d1d652407.camel@intel.com>
 <20190724174029.GC30776@intel.com>
 <20190730151908.GA21970@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190730151908.GA21970@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 30, 2019 at 08:19:08AM -0700, Rodrigo Vivi wrote:
> Hi Greg,
> 
> On Wed, Jul 24, 2019 at 10:40:29AM -0700, Rodrigo Vivi wrote:
> > On Wed, Jul 24, 2019 at 05:27:42PM +0000, Souza, Jose wrote:
> > > On Wed, 2019-07-24 at 14:06 +0200, Greg KH wrote:
> > > > On Mon, Jul 22, 2019 at 04:13:25PM -0700, Dhinakaran Pandiyan wrote:
> > > > > A single 32-bit PSR2 training pattern field follows the sixteen
> > > > > element
> > > > > array of PSR table entries in the VBT spec. But, we incorrectly
> > > > > define
> > > > > this PSR2 field for each of the PSR table entries. As a result, the
> > > > > PSR1
> > > > > training pattern duration for any panel_type != 0 will be parsed
> > > > > incorrectly. Secondly, PSR2 training pattern durations for VBTs
> > > > > with bdb
> > > > > version >= 226 will also be wrong.
> > > > > 
> > > > > Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > > > > Cc: José Roberto de Souza <jose.souza@intel.com>
> > > > > Cc: stable@vger.kernel.org
> > > > > Cc: stable@vger.kernel.org #v5.2
> > > > > Fixes: 88a0d9606aff ("drm/i915/vbt: Parse and use the new field
> > > > > with PSR2 TP2/3 wakeup time")
> > > > > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111088
> > > > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204183
> > > > > Signed-off-by: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
> > > > > Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > > Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
> > > > > Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > > > > Tested-by: François Guerraz <kubrick@fgv6.net>
> > > > > Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > > > > Link: 
> > > > > https://patchwork.freedesktop.org/patch/msgid/20190717223451.2595-1-dhinakaran.pandiyan@intel.com
> > > > > (cherry picked from commit
> > > > > b5ea9c9337007d6e700280c8a60b4e10d070fb53)
> > > > 
> > > > There is no such commit in Linus's kernel tree :(
> > 
> > not yet... It is queued for 5.3 on drm-intel-next-queued.
> > 
> > This line is automatically added by "dim" tool when
> > cherry-picking queued stuff for our drm-intel fixes branches.
> 
> What do you need her from us to accept this patch?

Um, you have read the stable kernel rules, right?
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

That's what I need for it to go into a stable kernel release.

thanks,

greg k-h
