Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2225848164
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 13:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfFQL6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 07:58:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:60308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbfFQL6r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 07:58:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E37B21530;
        Mon, 17 Jun 2019 11:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560772726;
        bh=y4eKUuWxQSESIENpjGpXYgdLoKqHEtYzzk8t9YG0LlM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=doVEwKtfwBemoFoFukUTyv/3s5okrpAPvtEjnv1hu5V2HUT1g+O3T9n8sW8o6zC4M
         6zrDPnhBFCn1xnKdU9qPIXt7UI2lEZWFxSxJ6Cc10FCX2r6cTaCgQmSJsi/niDOuLi
         Mj1s+Yn+776xSvS+BzU10ltjP8keI2sALQ2hYYu8=
Date:   Mon, 17 Jun 2019 13:58:41 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     daniel.vetter@ffwll.ch, harish.chegondi@intel.com,
        ilpo.jarvinen@cs.helsinki.fi, pabs3@bonedaddy.net,
        stable@vger.kernel.org, ville.syrjala@linux.intel.com
Subject: Re: FAILED: patch "[PATCH] drm: add fallback override/firmware EDID
 modes workaround" failed to apply to 5.1-stable tree
Message-ID: <20190617115841.GA16403@kroah.com>
References: <156061755857126@kroah.com>
 <877e9kv5z4.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877e9kv5z4.fsf@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 01:52:47PM +0300, Jani Nikula wrote:
> On Sat, 15 Jun 2019, <gregkh@linuxfoundation.org> wrote:
> > The patch below does not apply to the 5.1-stable tree.
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
> > From 48eaeb7664c76139438724d520a1ea4a84a3ed92 Mon Sep 17 00:00:00 2001
> > From: Jani Nikula <jani.nikula@intel.com>
> > Date: Mon, 10 Jun 2019 12:30:54 +0300
> > Subject: [PATCH] drm: add fallback override/firmware EDID modes workaround
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> >
> > We've moved the override and firmware EDID (simply "override EDID" from
> > now on) handling to the low level drm_do_get_edid() function in order to
> > transparently use the override throughout the stack. The idea is that
> > you get the override EDID via the ->get_modes() hook.
> >
> > Unfortunately, there are scenarios where the DDC probe in drm_get_edid()
> > called via ->get_modes() fails, although the preceding ->detect()
> > succeeds.
> >
> > In the case reported by Paul Wise, the ->detect() hook,
> > intel_crt_detect(), relies on hotplug detect, bypassing the DDC. In the
> > case reported by Ilpo Järvinen, there is no ->detect() hook, which is
> > interpreted as connected. The subsequent DDC probe reached via
> > ->get_modes() fails, and we don't even look at the override EDID,
> > resulting in no modes being added.
> >
> > Because drm_get_edid() is used via ->detect() all over the place, we
> > can't trivially remove the DDC probe, as it leads to override EDID
> > effectively meaning connector forcing. The goal is that connector
> > forcing and override EDID remain orthogonal.
> >
> > Generally, the underlying problem here is the conflation of ->detect()
> > and ->get_modes() via drm_get_edid(). The former should just detect, and
> > the latter should just get the modes, typically via reading the EDID. As
> > long as drm_get_edid() is used in ->detect(), it needs to retain the DDC
> > probe. Or such users need to have a separate DDC probe step first.
> >
> > The EDID caching between ->detect() and ->get_modes() done by some
> > drivers is a further complication that prevents us from making
> > drm_do_get_edid() adapt to the two cases.
> >
> > Work around the regression by falling back to a separate attempt at
> > getting the override EDID at drm_helper_probe_single_connector_modes()
> > level. With a working DDC and override EDID, it'll never be called; the
> > override EDID will come via ->get_modes(). There will still be a failing
> > DDC probe attempt in the cases that require the fallback.
> >
> > v2:
> > - Call drm_connector_update_edid_property (Paul)
> > - Update commit message about EDID caching (Daniel)
> >
> > Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=107583
> > Reported-by: Paul Wise <pabs3@bonedaddy.net>
> > Cc: Paul Wise <pabs3@bonedaddy.net>
> > References: http://mid.mail-archive.com/alpine.DEB.2.20.1905262211270.24390@whs-18.cs.helsinki.fi
> > Reported-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
> > Cc: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
> > Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> > References: 15f080f08d48 ("drm/edid: respect connector force for drm_get_edid ddc probe")
> > Fixes: 53fd40a90f3c ("drm: handle override and firmware EDID at drm_do_get_edid() level")
> > Cc: <stable@vger.kernel.org> # v4.15+ 56a2b7f2a39a drm/edid: abstract override/firmware EDID retrieval
> 
> I was hoping this dependency description would suffice; does it not work
> if you pick that up first? Ditto for the other stable kernels.

Ugh, sorry, I missed that.

Now picked up both patches, thanks!

greg k-h
