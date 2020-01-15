Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07CE413B7A6
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 03:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgAOC1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 21:27:08 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:56226 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgAOC1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 21:27:08 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so6687230pjz.5;
        Tue, 14 Jan 2020 18:27:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eSVEWssYTpiV5Eqi/FIfWIR/4RrREqVoEKeDwn2EhZ8=;
        b=CIVg+EauJZpoibrMdwJkF0laAx6091v9BVb2wt0pGzRRFWQBGrcTdb8Wp6jYAUO3NW
         ASJxCdxJhd3x8vr2qqPSdJYHjf7dRB6d4jAgL8EaoXoyo7jmWFbYVXvIfPJ52L7lvuCO
         itbDzHA9e7dvvf3xFhg9NrmlEQeml8iR0kZo+DwuwrNrj1HLgJ9j6mRH4ssObnaU/Mq8
         31WO/HzBxbZ2xng2ARh0XSMwJ2UOfwXg6Pq6/IbdNc5dXSp5gqR/PNKHkZY58aISJ38x
         1xf0rM0TaN6YUgnOL4YSmpM/NlaQ+JoyVOVqSN6pjgIB1iRRsuW7hzEndqtXe5KMZZ1f
         luCA==
X-Gm-Message-State: APjAAAWoqWNXdIdolRG/hQyiliQkopPhF/ZII6Zny2SJ6LliHAApP9Pi
        0IgiCqWspDud/lSLvogj30g=
X-Google-Smtp-Source: APXvYqwA8P1UPp7Yt28VlX7Q/LJQc3K+r2Av6bWr7o29Ops23yGm6ds4EN4Xj3a8WBMC6Z0IFZUblw==
X-Received: by 2002:a17:90a:9f04:: with SMTP id n4mr32799571pjp.76.1579055227298;
        Tue, 14 Jan 2020 18:27:07 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id c68sm19745446pfc.156.2020.01.14.18.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 18:27:06 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 7DA3940244; Wed, 15 Jan 2020 02:27:05 +0000 (UTC)
Date:   Wed, 15 Jan 2020 02:27:05 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jari Ruusu <jari.ruusu@gmail.com>, Borislav Petkov <bp@alien8.de>,
        Fenghua Yu <fenghua.yu@intel.com>, johannes.berg@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-remoteproc@vger.kernel.org
Subject: Re: Fix built-in early-load Intel microcode alignment
Message-ID: <20200115022705.GE11244@42.do-not-panic.com>
References: <CACMCwJK-2DHZDA_F5Z3wsEUEKJSc3uOwwPD4HRoYGW7A+kA75w@mail.gmail.com>
 <20200113154739.GB11244@42.do-not-panic.com>
 <CAHk-=wja2GChi_JBu0xBkQ96mqXC3TMKUp=YvRhgPy0+1m5YNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wja2GChi_JBu0xBkQ96mqXC3TMKUp=YvRhgPy0+1m5YNw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 13, 2020 at 11:44:25AM -0800, Linus Torvalds wrote:
> On Mon, Jan 13, 2020 at 7:47 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > So I'd like to determine first if we really need this. Then if so,
> > either add a new global config option, and worst comes to worst
> > figure out a way to do it per driver. I don't think we'd need it
> > per driver.
> 
> I really don't think we need to have a config option for some small
> alignment. Increasing the alignment unconditionally to 16 bytes won't
> hurt anybody.

Since you are confident in that, then simply bumping it to 16 bytes
seems fine by me.

> Now, whether there might be other firmware loaders that need even more
> alignment, that might be an interesting question, and if such an
> alignment would be _huge_ we might want to worry about actual memory
> waste.

I can only envision waste being considered due to alignent for remote
proc folks, who I *doubt* use the built-in stuff given the large size of
their blobs... but since you never know, better poke. So I've CC'd them.

> But 16-byte alignment for a fw blob? That's nothing.

Fine by me if we are sure it won't break anything and we hear no
complaints by remote proc folks.

  Luis
