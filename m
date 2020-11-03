Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3F72A5068
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 20:48:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729382AbgKCTr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 14:47:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49630 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726660AbgKCTr7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 14:47:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604432877;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CHQ3/bBc5WxHfN8LaH/bQM7T7VaD4uRFaJUk/wKN6nw=;
        b=V/53gMnjlQwcfEkf1wAVDNwedSiEa6r9cEf7jBixRKSHZ9+X3uoZU9GO92nWoLQspGLlH/
        ka8QPcyOIkfO2LeaQgnLkU4tPc2kb28YYwJEikemRlM1jnTrExmk4Ds4x5A7xSArwgWRaE
        Ab1v5UR+3D3IarMPGBciBzM0iY8xNFQ=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-SZf0-klSOSSGUtHA_cWjvA-1; Tue, 03 Nov 2020 14:47:55 -0500
X-MC-Unique: SZf0-klSOSSGUtHA_cWjvA-1
Received: by mail-qk1-f198.google.com with SMTP id j20so11513839qkl.7
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 11:47:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=CHQ3/bBc5WxHfN8LaH/bQM7T7VaD4uRFaJUk/wKN6nw=;
        b=aZVT5edA3dBq+oVkm2CRuyYSMX4N94qcqs/x783Fq0W3Hj+SqRUhvtH+xYIMLthoSQ
         PKY7Nik1ASUx4mf61kP2Wz2Bg8NjqJkzxKX0p+amgAKST+nGVi2pbmpSOXGbjHehxE8P
         fpXKDSQo4wRWsZ2zN0b1MOkir0weoJAbRzyVEhqArXBpB7raVTAULy5f/F97WJUlpxXo
         3iD0B2LCeUoPN5XGD5vGvVivG1Wgk7RpYILL6bfYcpgOq0R6+/MNKLze3V2hjFI5SjTx
         QlgCVZSWJ2tOFQ6pqltS45pU5TzkF23L7bZ94f/rvdK9umL09k2/lXs64rbQKIaRpoiJ
         bl1Q==
X-Gm-Message-State: AOAM5328wf4HEVb28E7QPPhRBsJNi/vLZgIDfYbhxDkUZQkvRPQ1Laah
        dh5r54qUkkQmrBCJbR8HWCYdTnzAg/UxyLffe67COm9GiRUmHQ/VDBlJY3XOYFS4PH4uKfWN+9s
        l1GCVu/pfy8GIHjFg
X-Received: by 2002:a37:47c2:: with SMTP id u185mr17010909qka.63.1604432875487;
        Tue, 03 Nov 2020 11:47:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0D0CC36lHqdD9IBGL0B2j1EjIRDVnCjR6y7CDfrhuUmcd3BPaRc4m50PeZvW+nAg9DESoqA==
X-Received: by 2002:a37:47c2:: with SMTP id u185mr17010888qka.63.1604432875262;
        Tue, 03 Nov 2020 11:47:55 -0800 (PST)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id x75sm11687361qka.59.2020.11.03.11.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 11:47:54 -0800 (PST)
Message-ID: <8d15a513bd38a01b3607e5c75b5754cc599fe33c.camel@redhat.com>
Subject: Re: [PATCH] drm/edid: Fix uninitialized variable in drm_cvt_modes()
From:   Lyude Paul <lyude@redhat.com>
Reply-To: lyude@redhat.com
To:     Ilia Mirkin <imirkin@alum.mit.edu>
Cc:     dri-devel <dri-devel@lists.freedesktop.org>,
        Leon Romanovsky <leon@kernel.org>,
        David Airlie <airlied@linux.ie>, Chao Yu <chao@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "# 3.9+" <stable@vger.kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>
Date:   Tue, 03 Nov 2020 14:47:53 -0500
In-Reply-To: <CAKb7UvhfWA6ijoQnq2Mvrx8jfn57EC-P5KBkYR3HmrBUrntJhg@mail.gmail.com>
References: <20201022165450.682571-1-lyude@redhat.com>
         <CAKb7UvhfWA6ijoQnq2Mvrx8jfn57EC-P5KBkYR3HmrBUrntJhg@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry! Thought I had responded to this but apparently not, comments down below

On Thu, 2020-10-22 at 14:04 -0400, Ilia Mirkin wrote:
> On Thu, Oct 22, 2020 at 12:55 PM Lyude Paul <lyude@redhat.com> wrote:
> > 
> > Noticed this when trying to compile with -Wall on a kernel fork. We
> > potentially
> > don't set width here, which causes the compiler to complain about width
> > potentially being uninitialized in drm_cvt_modes(). So, let's fix that.
> > 
> > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > 
> > Cc: <stable@vger.kernel.org> # v5.9+
> > Fixes: 3f649ab728cd ("treewide: Remove uninitialized_var() usage")
> > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > ---
> >  drivers/gpu/drm/drm_edid.c | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> > index 631125b46e04..2da158ffed8e 100644
> > --- a/drivers/gpu/drm/drm_edid.c
> > +++ b/drivers/gpu/drm/drm_edid.c
> > @@ -3094,6 +3094,7 @@ static int drm_cvt_modes(struct drm_connector
> > *connector,
> > 
> >         for (i = 0; i < 4; i++) {
> >                 int width, height;
> > +               u8 cvt_aspect_ratio;
> > 
> >                 cvt = &(timing->data.other_data.data.cvt[i]);
> > 
> > @@ -3101,7 +3102,8 @@ static int drm_cvt_modes(struct drm_connector
> > *connector,
> >                         continue;
> > 
> >                 height = (cvt->code[0] + ((cvt->code[1] & 0xf0) << 4) + 1) *
> > 2;
> > -               switch (cvt->code[1] & 0x0c) {
> > +               cvt_aspect_ratio = cvt->code[1] & 0x0c;
> > +               switch (cvt_aspect_ratio) {
> >                 case 0x00:
> >                         width = height * 4 / 3;
> >                         break;
> > @@ -3114,6 +3116,10 @@ static int drm_cvt_modes(struct drm_connector
> > *connector,
> >                 case 0x0c:
> >                         width = height * 15 / 9;
> >                         break;
> > +               default:
> 
> What value would cvt->code[1] have such that this gets hit?
> 
> Or is this a "compiler is broken, so let's add more code" situation?
> If so, perhaps the code added could just be enough to silence the
> compiler (unreachable, etc)?

I mean, this information comes from the EDID which inherently means it's coming
from an untrusted source so the value could be literally anything as long as the
EDID has a valid checksum. Note (assuming I'm understanding this code
correctly): 

drm_add_edid_modes() → add_cvt_modes() → drm_for_each_detailed_block() →
do_cvt_mode() → drm_cvt_modes()

So afaict this isn't a broken compiler but a legitimate uninitialized variable.
> 
>   -ilia
> 

-- 
Sincerely,
   Lyude Paul (she/her)
   Software Engineer at Red Hat
   
Note: I deal with a lot of emails and have a lot of bugs on my plate. If you've
asked me a question, are waiting for a review/merge on a patch, etc. and I
haven't responded in a while, please feel free to send me another email to check
on my status. I don't bite!

