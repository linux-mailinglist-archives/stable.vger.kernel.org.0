Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75584240353
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 10:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgHJIVH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 10 Aug 2020 04:21:07 -0400
Received: from mga07.intel.com ([134.134.136.100]:26236 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725846AbgHJIVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 04:21:07 -0400
IronPort-SDR: ypDB3n7jei/ZvesZ85Aa8R2rF9BvtiLHPEkJcdy7fpGlCp5+//ConiDHss0XdfeDpUmZbNKHX/
 mjEmWJZqT28Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9708"; a="217835171"
X-IronPort-AV: E=Sophos;i="5.75,457,1589266800"; 
   d="scan'208";a="217835171"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 01:20:49 -0700
IronPort-SDR: WvpZDOMWzYWGf+fT0WgbLG/tj2t0mDpbX/dcZ77WSwnbgHBmAO1HpylnapqyTiku2cXGwAMka8
 yw+bBK2dTpBg==
X-IronPort-AV: E=Sophos;i="5.75,457,1589266800"; 
   d="scan'208";a="494719354"
Received: from unknown (HELO localhost) ([10.249.44.171])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 01:20:45 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Sam Ravnborg <sam@ravnborg.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        dri-devel <dri-devel@lists.freedesktop.org>, armijn@tjaldur.nl,
        Gerd Hoffmann <kraxel@redhat.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        Dave Airlie <airlied@redhat.com>,
        stable <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Emil Velikov <emil.velikov@collabora.com>
Subject: Re: WTF: patch "[PATCH] drm/mgag200: Remove declaration of mgag200_mmap() from header" was seriously submitted to be applied to the 5.8-stable tree?
In-Reply-To: <20200808093708.GA14702@ravnborg.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <159680700523135@kroah.com> <a92e73b9-c3da-76f6-9405-b2456fe68ce6@suse.de> <CAKMK7uFJVzm1avAOZd0kPAzRUQkTQv3LtrjafjpjXh4K8TaAHg@mail.gmail.com> <20200808093708.GA14702@ravnborg.org>
Date:   Mon, 10 Aug 2020 11:20:42 +0300
Message-ID: <87tuxaj4it.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 08 Aug 2020, Sam Ravnborg <sam@ravnborg.org> wrote:
> Hi Daniel.
>
> On Sat, Aug 08, 2020 at 11:13:54AM +0200, Daniel Vetter wrote:
>> On Fri, Aug 7, 2020 at 3:54 PM Thomas Zimmermann <tzimmermann@suse.de> wrote:
>> >
>> > Hi
>> >
>> > Am 07.08.20 um 15:30 schrieb gregkh@linuxfoundation.org:
>> > > The patch below was submitted to be applied to the 5.8-stable tree.
>> > >
>> > > I fail to see how this patch meets the stable kernel rules as found at
>> > > Documentation/process/stable-kernel-rules.rst.
>> > >
>> > > I could be totally wrong, and if so, please respond to
>> > > <stable@vger.kernel.org> and let me know why this patch should be
>> > > applied.  Otherwise, it is now dropped from my patch queues, never to be
>> > > seen again.
>> >
>> > Sorry for the noise. There's no reason this should go into stable.
>> 
>> We have a little script in our maintainer toolbox for bugfixes, which
>> generates the Fixes: line, adds everyone from the original commit to
>> the cc: list and also adds Cc: stable if that sha1 the patch fixes is
>> in a release already.
>> 
>> I guess we trained people a bit too much on using Fixes: tags like
>> that with the tooling, since they often do that for checkpatch stuff
>> and spelling fixes like this here too. I think the autoselect bot also
>> loves Fixes: tags a bit too much for its own good.
>> 
>> Not sure what to do, since telling people to "please sprinkle less
>> Fixes: tags" doesn't sound great either.
>
> We know that at lot of the drm people uses "dim fixes".
> So maybe teach them a litte here?
>
> diff --git a/dim b/dim
> index e4f4d2e..d4fd310 100755
> --- a/dim
> +++ b/dim
> @@ -2428,6 +2428,10 @@ function dim_fixes
>  
>  	sha1=${1:?$usage}
>  
> +	echo ""
> +	echo "Note: Patch must meet the stable-kernel-rules criterias (Documentation/process/stable-kernel-rules.rst)"
> +	echo ""
> +

I don't think this is right, because we also use Fixes: to refer to
commits that haven't even been merged upstream yet, i.e. commits that
are in the -next feature branches, and the stable kernel rules do not
apply.

BR,
Jani.





>  	cd $DIM_PREFIX/$DIM_REPO
>  	echo "Fixes: $(dim_cite $sha1)"
>  
>
> Output would then look like this:
>
> $ dim fixes 1d8d42ba365101fa68d210c0e2ed2bc9582fda6c
>
> Note: Patch must meet the stable-kernel-rules criterias (Documentation/process/stable-kernel-rules.rst)
>
> Fixes: 1d8d42ba3651 ("drm/mgag200: Remove declaration of mgag200_mmap() from header file")
> Cc: Thomas Zimmermann <tzimmermann@suse.de>
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Krzysztof Kozlowski <krzk@kernel.org>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "Noralf Trønnes" <noralf@tronnes.org>
> Cc: Armijn Hemel <armijn@tjaldur.nl>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: Emil Velikov <emil.velikov@collabora.com>
> Cc: <stable@vger.kernel.org> # v5.3+
> Cc: Lyude Paul <lyude@redhat.com>
>
> No guarantee that people will look up the rules outlined in
> stable-kernel-rules.rst - but at least a reminder.
>
> 	Sam
>
>> I also don't want to tell
>> people to use the maintainer toolbox less, the autogenerated cc: list
>> is generally the right thing to do. Maybe best if the stable team
>> catches the obvious ones before adding them to the stable queue, if
>> you're ok with that Greg?
>> 
>> Also adding dri-devel here in case this becomes a bigger discussion.
>> 
>> Cheers, Daniel
>> 
>> >
>> > Best regards
>> > Thomas
>> >
>> > >
>> > > thanks,
>> > >
>> > > greg k-h
>> > >
>> > > ------------------ original commit in Linus's tree ------------------
>> > >
>> > > From 1d8d42ba365101fa68d210c0e2ed2bc9582fda6c Mon Sep 17 00:00:00 2001
>> > > From: Thomas Zimmermann <tzimmermann@suse.de>
>> > > Date: Fri, 5 Jun 2020 15:57:50 +0200
>> > > Subject: [PATCH] drm/mgag200: Remove declaration of mgag200_mmap() from header
>> > >  file
>> > > MIME-Version: 1.0
>> > > Content-Type: text/plain; charset=UTF-8
>> > > Content-Transfer-Encoding: 8bit
>> > >
>> > > Commit 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
>> > > removed the implementation of mgag200_mmap(). Also remove the declaration.
>> > >
>> > > Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> > > Acked-by: Sam Ravnborg <sam@ravnborg.org>
>> > > Fixes: 94668ac796a5 ("drm/mgag200: Convert mgag200 driver to VRAM MM")
>> > > Cc: Gerd Hoffmann <kraxel@redhat.com>
>> > > Cc: Dave Airlie <airlied@redhat.com>
>> > > Cc: Krzysztof Kozlowski <krzk@kernel.org>
>> > > Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
>> > > Cc: Sam Ravnborg <sam@ravnborg.org>
>> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> > > Cc: Thomas Gleixner <tglx@linutronix.de>
>> > > Cc: "Noralf Trønnes" <noralf@tronnes.org>
>> > > Cc: Armijn Hemel <armijn@tjaldur.nl>
>> > > Cc: Alex Deucher <alexander.deucher@amd.com>
>> > > Cc: Emil Velikov <emil.velikov@collabora.com>
>> > > Cc: <stable@vger.kernel.org> # v5.3+
>> > > Link: https://patchwork.freedesktop.org/patch/msgid/20200605135803.19811-2-tzimmermann@suse.de
>> > >
>> > > diff --git a/drivers/gpu/drm/mgag200/mgag200_drv.h b/drivers/gpu/drm/mgag200/mgag200_drv.h
>> > > index 47df62b1ad29..92b6679029fe 100644
>> > > --- a/drivers/gpu/drm/mgag200/mgag200_drv.h
>> > > +++ b/drivers/gpu/drm/mgag200/mgag200_drv.h
>> > > @@ -198,6 +198,5 @@ void mgag200_i2c_destroy(struct mga_i2c_chan *i2c);
>> > >
>> > >  int mgag200_mm_init(struct mga_device *mdev);
>> > >  void mgag200_mm_fini(struct mga_device *mdev);
>> > > -int mgag200_mmap(struct file *filp, struct vm_area_struct *vma);
>> > >
>> > >  #endif                               /* __MGAG200_DRV_H__ */
>> > >
>> >
>> > --
>> > Thomas Zimmermann
>> > Graphics Driver Developer
>> > SUSE Software Solutions Germany GmbH
>> > Maxfeldstr. 5, 90409 Nürnberg, Germany
>> > (HRB 36809, AG Nürnberg)
>> > Geschäftsführer: Felix Imendörffer
>> >
>> 
>> 
>> -- 
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> http://blog.ffwll.ch
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Jani Nikula, Intel Open Source Graphics Center
