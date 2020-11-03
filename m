Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEE42A50A2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729645AbgKCUDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:03:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725997AbgKCUDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 15:03:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604433790;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hs/zXGHlz9vLFkghpxlnSjQMAlQ6jTL7a/WUuTWkQUQ=;
        b=ZUgxGEd/tlA/wmWx8gzPY4AOXJvWInTgjf1stqq5FCzS4zlCfzfqN2tXwWUNzHzq52xyI2
        b21eYm4vjGWn1KluDEOQML9QFhjnKUhZqSWffgl9RCyJ73f8AVL8rmv+yDB3x7UFBjXViM
        foXxGO9fonVk0LZkyeBVGbk1RJ4q0Gg=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-fxmvrhk5NNK9jE3daVWGcg-1; Tue, 03 Nov 2020 15:03:04 -0500
X-MC-Unique: fxmvrhk5NNK9jE3daVWGcg-1
Received: by mail-qk1-f197.google.com with SMTP id n23so10506553qkn.1
        for <stable@vger.kernel.org>; Tue, 03 Nov 2020 12:03:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=hs/zXGHlz9vLFkghpxlnSjQMAlQ6jTL7a/WUuTWkQUQ=;
        b=Zz2y6y7A+M7T64Z7mNubPYIWo3XddSuFTQufzARuIt7kMWYOrg9YeQi55YhB6r4GUw
         +NaneYw/Hj5ALeGEzJ1F2u1HrH6JjnRy60FqZFK9QKI9PklYxCO0kUcWouR2MQCes1bI
         BEx8/cFbWlGEZi4RYtiYmi5BfKuL0EuB8+Fs3dXo10+rUTuQ8/7u//VS5UlQdDWSD/7P
         t7CXMxSvqu4Hly/3DrBo6Uy4D1LKOb5YzrcGrLwNvxb/D5nTq+B8V6rKkyflOhKoaAG6
         BvrcQEXjnB0P+yf62oTXbNxYTHBnYerUuJGLNCkE3DzxSiwq3/PvR3x3RHFT+V23uLma
         DPlQ==
X-Gm-Message-State: AOAM531Gw8O9KPUkL5z7U6+LF2+Wr0IZRSar2pVgaNKnTTEyEcbe2Dpg
        A1gkDbGJqlEkIOLMsMD4UC30wRtiuW02Iza5IQL3CpUD/0x1mNQVKq7SopVEy0yAjxG3/pdDr1N
        tYDK3hjDU7qJD3Aqt
X-Received: by 2002:a05:620a:1193:: with SMTP id b19mr8991542qkk.42.1604433784111;
        Tue, 03 Nov 2020 12:03:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz3Uif/P5KpG7c3Wmsy5fgC5l2WzpKVRev2cYaqxmHthv/mJZZ6oxzAqBLM1VOiN/jiyFC7lg==
X-Received: by 2002:a05:620a:1193:: with SMTP id b19mr8991516qkk.42.1604433783827;
        Tue, 03 Nov 2020 12:03:03 -0800 (PST)
Received: from Whitewolf.lyude.net (pool-108-49-102-102.bstnma.fios.verizon.net. [108.49.102.102])
        by smtp.gmail.com with ESMTPSA id o21sm206002qko.9.2020.11.03.12.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 12:03:03 -0800 (PST)
Message-ID: <dd9b5ea4409886e83b87a6769e7ed45c753298cb.camel@redhat.com>
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
Date:   Tue, 03 Nov 2020 15:03:01 -0500
In-Reply-To: <CAKb7UvjJHMbDEAYJRCCdQ=LZfpogb4Z6y+yYFgPYKvbE1mM1ig@mail.gmail.com>
References: <20201022165450.682571-1-lyude@redhat.com>
         <CAKb7UvhfWA6ijoQnq2Mvrx8jfn57EC-P5KBkYR3HmrBUrntJhg@mail.gmail.com>
         <8d15a513bd38a01b3607e5c75b5754cc599fe33c.camel@redhat.com>
         <CAKb7UvjJHMbDEAYJRCCdQ=LZfpogb4Z6y+yYFgPYKvbE1mM1ig@mail.gmail.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 (3.38.1-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-11-03 at 14:53 -0500, Ilia Mirkin wrote:
> On Tue, Nov 3, 2020 at 2:47 PM Lyude Paul <lyude@redhat.com> wrote:
> > 
> > Sorry! Thought I had responded to this but apparently not, comments down
> > below
> > 
> > On Thu, 2020-10-22 at 14:04 -0400, Ilia Mirkin wrote:
> > > On Thu, Oct 22, 2020 at 12:55 PM Lyude Paul <lyude@redhat.com> wrote:
> > > > 
> > > > Noticed this when trying to compile with -Wall on a kernel fork. We
> > > > potentially
> > > > don't set width here, which causes the compiler to complain about width
> > > > potentially being uninitialized in drm_cvt_modes(). So, let's fix that.
> > > > 
> > > > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > > > 
> > > > Cc: <stable@vger.kernel.org> # v5.9+
> > > > Fixes: 3f649ab728cd ("treewide: Remove uninitialized_var() usage")
> > > > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > > > ---
> > > >  drivers/gpu/drm/drm_edid.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
> > > > index 631125b46e04..2da158ffed8e 100644
> > > > --- a/drivers/gpu/drm/drm_edid.c
> > > > +++ b/drivers/gpu/drm/drm_edid.c
> > > > @@ -3094,6 +3094,7 @@ static int drm_cvt_modes(struct drm_connector
> > > > *connector,
> > > > 
> > > >         for (i = 0; i < 4; i++) {
> > > >                 int width, height;
> > > > +               u8 cvt_aspect_ratio;
> > > > 
> > > >                 cvt = &(timing->data.other_data.data.cvt[i]);
> > > > 
> > > > @@ -3101,7 +3102,8 @@ static int drm_cvt_modes(struct drm_connector
> > > > *connector,
> > > >                         continue;
> > > > 
> > > >                 height = (cvt->code[0] + ((cvt->code[1] & 0xf0) << 4) +
> > > > 1) *
> > > > 2;
> > > > -               switch (cvt->code[1] & 0x0c) {
> > > > +               cvt_aspect_ratio = cvt->code[1] & 0x0c;
> > > > +               switch (cvt_aspect_ratio) {
> > > >                 case 0x00:
> > > >                         width = height * 4 / 3;
> > > >                         break;
> > > > @@ -3114,6 +3116,10 @@ static int drm_cvt_modes(struct drm_connector
> > > > *connector,
> > > >                 case 0x0c:
> > > >                         width = height * 15 / 9;
> > > >                         break;
> > > > +               default:
> > > 
> > > What value would cvt->code[1] have such that this gets hit?
> > > 
> > > Or is this a "compiler is broken, so let's add more code" situation?
> > > If so, perhaps the code added could just be enough to silence the
> > > compiler (unreachable, etc)?
> > 
> > I mean, this information comes from the EDID which inherently means it's
> > coming
> > from an untrusted source so the value could be literally anything as long as
> > the
> > EDID has a valid checksum. Note (assuming I'm understanding this code
> > correctly):
> > 
> > drm_add_edid_modes() → add_cvt_modes() → drm_for_each_detailed_block() →
> > do_cvt_mode() → drm_cvt_modes()
> > 
> > So afaict this isn't a broken compiler but a legitimate uninitialized
> > variable.
> 
> The value can be anything, but it has to be something. The switch is
> on "unknown & 0x0c", so only 4 cases are possible, which are
> enumerated in the switch.

oops, you're completely right lol. will figure out what the unreachable macro in
the kernel is and use that in a respin of this patch

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

