Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF0C19E657
	for <lists+stable@lfdr.de>; Sat,  4 Apr 2020 18:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDDQGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Apr 2020 12:06:34 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33586 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgDDQGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Apr 2020 12:06:33 -0400
Received: by mail-lj1-f194.google.com with SMTP id f20so10153792ljm.0
        for <stable@vger.kernel.org>; Sat, 04 Apr 2020 09:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JRGsKivxe9j13Vrd41+3vZjk/D6J0Gm5H+Vo+RNnIsM=;
        b=u4VBZf8DWGri/CJMWdVajTa0xQcpmwrb+zk6ESFEMFIjPcYc7GaaSQI52drILyLNiN
         H0vEw6qLWWZAhN1c4ou2EZlKI9Of30F0J5hxr9BOAG/OlJGMPmfMu5b8PRH2Xdk7e7Jt
         wj1IwuHfmIesbu6AM5K5flkC9Y/cTvAoRJe//WGVL3r2TlRIvPcMYnBmz8L5Z2iWBXZU
         JIsmfsNl0WLCwXOuqxWSz2B6ihRBWbevfP/o81JCvUxx3NFYp2zvQw3EK0ONTqSmn79s
         xMTSqirmJJ2FlE0SXQyXWzUYQsNa1psjDxAUVnjP2mRiGwo8wzamf1q9k0sobnjbA5g3
         tNvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JRGsKivxe9j13Vrd41+3vZjk/D6J0Gm5H+Vo+RNnIsM=;
        b=qnPmmt/i1tI2XfcVx6fmn1fx5N1QOYswurcEa0q/uC+xnnOfNORVtLVGKkvdY2uisR
         XUL5C//XKohHyMmb2wLciC/SlVzMRMFuWlKWvijsh5FpCsDwSHsNorefPSGdUQVsn3/5
         7ruynouAi8/Y7Wp4L0sVGFavV8dx4VDMabZeHcVkq71C9VNZG979WcVqje6eIlCpRbTo
         qnthwnuQmvbRLFPKckU8YPbJuyApu7RqFyNol29F+WzKsbO+PXjivU4z6ekVKbeQ5xfa
         woZVpY63jBAI3mywDkpuEfok5YJwAW7aAGkgVw/YoeaRv7L5E6UYtR+XQo7A1W+RiVIy
         RDQQ==
X-Gm-Message-State: AGi0PubPHdKgsumuva+qBhxQ1jhOUQ7sw106Ba+hHCplzVVPWpQIf1FZ
        V6mM082SRi3X+f42tOoASUSPpQ==
X-Google-Smtp-Source: APiQypIxW1eygGjnq/xOojjEUtOkk5jCDkQIz/ZzxBIqBHtRYYpksysAGE43MzcbDGuPRZjIEHHdOw==
X-Received: by 2002:a2e:82d0:: with SMTP id n16mr7945847ljh.174.1586016391180;
        Sat, 04 Apr 2020 09:06:31 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id x29sm5236114lfn.64.2020.04.04.09.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 09:06:30 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 5519C101B5B; Sat,  4 Apr 2020 19:06:31 +0300 (+03)
Date:   Sat, 4 Apr 2020 19:06:31 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux- stable <stable@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        William Kucharski <william.kucharski@oracle.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Michal Hocko <mhocko@kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkft-triage@lists.linaro.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        LTP List <ltp@lists.linux.it>
Subject: Re: mm/mremap.c : WARNING: at mm/mremap.c:211
 move_page_tables+0x5b0/0x5d0
Message-ID: <20200404160631.7eny3swsqn665m2p@box>
References: <CA+G9fYs1xStrrsvGbW7bc4h1a0Kjfz0_zn4c7LL7-bGZb0GH6g@mail.gmail.com>
 <20200402133849.mmkvekzx37kw4nsj@box>
 <CA+G9fYv0xNtnD=eBmxVqYqEoYTbMk6mdn04WmgSUasDw2L7uFg@mail.gmail.com>
 <20200403133252.ivdqoppxhc6w5b47@box>
 <CA+G9fYsnD0vkCpSH98Lpsi6nxXBS+JYbSPhTnNE16CrQ4s4QhQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsnD0vkCpSH98Lpsi6nxXBS+JYbSPhTnNE16CrQ4s4QhQ@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 04, 2020 at 08:10:42PM +0530, Naresh Kamboju wrote:
> On Fri, 3 Apr 2020 at 19:02, Kirill A. Shutemov <kirill@shutemov.name> wrote:
> >
> > On Fri, Apr 03, 2020 at 12:56:57AM +0530, Naresh Kamboju wrote:
> > > [  734.876355] old_addr: 0xbfe00000, new_addr: 0xbfc00000, old_end: 0xc0000000
> >
> > The ranges are overlapping. We don't expect it. mremap(2) never does this.
> >
> > shift_arg_pages() only moves range downwards. It should be safe.
> >
> > Could you try this:
> 
> Applied the patch and tested and still getting kernel warning.
> CONFIG_HIGHMEM64G=y is still enabled.
> 
> [  790.041040] ------------[ cut here ]------------
> [  790.045664] WARNING: CPU: 3 PID: 3195 at mm/mremap.c:212
> move_page_tables+0x7a7/0x840

Are you sure the patch is applied? The line number in the warning supposed
to change.

-- 
 Kirill A. Shutemov
