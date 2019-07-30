Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B3F7AD6D
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 18:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfG3QVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 12:21:33 -0400
Received: from mga06.intel.com ([134.134.136.31]:62654 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726332AbfG3QVd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Jul 2019 12:21:33 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jul 2019 09:21:32 -0700
X-IronPort-AV: E=Sophos;i="5.64,327,1559545200"; 
   d="scan'208";a="174279616"
Received: from rdvivi-losangeles.jf.intel.com (HELO intel.com) ([10.7.196.65])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Jul 2019 09:21:32 -0700
Date:   Tue, 30 Jul 2019 09:22:07 -0700
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Souza, Jose" <jose.souza@intel.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        Jani Nikula <jani.nikula@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Pandiyan, Dhinakaran" <dhinakaran.pandiyan@intel.com>
Subject: Re: [Intel-gfx] [PATCH stable v5.2] drm/i915/vbt: Fix VBT parsing
 for the PSR section
Message-ID: <20190730162207.GA18653@intel.com>
References: <20190719004526.B0CC521850@mail.kernel.org>
 <20190722231325.16615-1-dhinakaran.pandiyan@intel.com>
 <20190724120657.GG3244@kroah.com>
 <05339e812e35a4cf1811f26a06bd5a4d1d652407.camel@intel.com>
 <20190724174029.GC30776@intel.com>
 <20190730151908.GA21970@intel.com>
 <20190730152724.GB31590@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190730152724.GB31590@kroah.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 30, 2019 at 05:27:24PM +0200, Greg KH wrote:
> On Tue, Jul 30, 2019 at 08:19:08AM -0700, Rodrigo Vivi wrote:
> > Hi Greg,
> > 
> > On Wed, Jul 24, 2019 at 10:40:29AM -0700, Rodrigo Vivi wrote:
> > > On Wed, Jul 24, 2019 at 05:27:42PM +0000, Souza, Jose wrote:
> > > > On Wed, 2019-07-24 at 14:06 +0200, Greg KH wrote:
> > > > > On Mon, Jul 22, 2019 at 04:13:25PM -0700, Dhinakaran Pandiyan wrote:
> > > > > > A single 32-bit PSR2 training pattern field follows the sixteen
> > > > > > element
> > > > > > array of PSR table entries in the VBT spec. But, we incorrectly
> > > > > > define
> > > > > > this PSR2 field for each of the PSR table entries. As a result, the
> > > > > > PSR1
> > > > > > training pattern duration for any panel_type != 0 will be parsed
> > > > > > incorrectly. Secondly, PSR2 training pattern durations for VBTs
> > > > > > with bdb
> > > > > > version >= 226 will also be wrong.
> > > > > > 
> > > > > > Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > > > > > Cc: José Roberto de Souza <jose.souza@intel.com>
> > > > > > Cc: stable@vger.kernel.org
> > > > > > Cc: stable@vger.kernel.org #v5.2
> > > > > > Fixes: 88a0d9606aff ("drm/i915/vbt: Parse and use the new field
> > > > > > with PSR2 TP2/3 wakeup time")
> > > > > > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=111088
> > > > > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=204183
> > > > > > Signed-off-by: Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
> > > > > > Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > > > > > Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
> > > > > > Acked-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > > > > > Tested-by: François Guerraz <kubrick@fgv6.net>
> > > > > > Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
> > > > > > Link: 
> > > > > > https://patchwork.freedesktop.org/patch/msgid/20190717223451.2595-1-dhinakaran.pandiyan@intel.com
> > > > > > (cherry picked from commit
> > > > > > b5ea9c9337007d6e700280c8a60b4e10d070fb53)
> > > > > 
> > > > > There is no such commit in Linus's kernel tree :(
> > > 
> > > not yet... It is queued for 5.3 on drm-intel-next-queued.
> > > 
> > > This line is automatically added by "dim" tool when
> > > cherry-picking queued stuff for our drm-intel fixes branches.
> > 
> > What do you need her from us to accept this patch?
> 
> Um, you have read the stable kernel rules, right?
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
>
> That's what I need for it to go into a stable kernel release.

Yes, I have read it. Maybe what I don't understand is just the fact that we will
let customers facing issues for 6 weeks or more while the original patch
doesn't land on Linus tree. :(

> 
> thanks,
> 
> greg k-h
