Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB14613CCA5
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 19:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgAOS6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 13:58:18 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40620 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgAOS6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 13:58:17 -0500
Received: by mail-pj1-f67.google.com with SMTP id bg7so335660pjb.5;
        Wed, 15 Jan 2020 10:58:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=viW5lUxcta83gnrt+PjYRxoac+oGqhs+xUeSRvnZmTQ=;
        b=CYSt8+RNsbNv8nhdw2VzG2Im59kpDOIKJlD44SJBT+dIJ/uHz2uOIajgLTzBtm/Ggg
         zvujyncpq9VAS6w4YTBIwx+olglDb4XAhjs2BVUeYhmctnKl36tPa0UabFy0bCWw0JJM
         1auljMvtqzovmb0KksdNMNmnEc2CZNzyz5zhGZFuMkCP6s2EqVZUDw7LPBTTO20t2Z1h
         I4NTVxg35dGwetuVfQxaAZ9JFtgszPLse3P1H6Tyk/HXkeM4vTodCi696JWiSIAnNQA/
         IZuhoyYwjCSrazHZfFhYdZT3xQbDD51wE3SLyfeJFAb/iDn3TfNswGAtkb0tyiy86G2r
         7pdQ==
X-Gm-Message-State: APjAAAX2hMUtwAkQHf8E8Xq13JT17VNqbH383OmOuh4tln77U7lO5/nK
        IagunJIHGPTCAJHzqTqm/qI=
X-Google-Smtp-Source: APXvYqyek9crS8Ai2SG0u0WO2iiBAHirV2VbSsqt3LTDaCmmNae9Bi3hRdfGWwno4Yvqe/UlPABj0g==
X-Received: by 2002:a17:90a:26ab:: with SMTP id m40mr1624578pje.42.1579114696566;
        Wed, 15 Jan 2020 10:58:16 -0800 (PST)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id v9sm504680pja.26.2020.01.15.10.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 10:58:14 -0800 (PST)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 7338E40244; Wed, 15 Jan 2020 18:58:12 +0000 (UTC)
Date:   Wed, 15 Jan 2020 18:58:12 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jari Ruusu <jari.ruusu@gmail.com>
Cc:     Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        johannes.berg@intel.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Andy Lutomirski <luto@kernel.org>
Subject: Re: Fix built-in early-load Intel microcode alignment
Message-ID: <20200115185812.GH11244@42.do-not-panic.com>
References: <CACMCwJK-2DHZDA_F5Z3wsEUEKJSc3uOwwPD4HRoYGW7A+kA75w@mail.gmail.com>
 <20200113154739.GB11244@42.do-not-panic.com>
 <CACMCwJL8tu+GHPeRADR_12xhcYSiDv+Yxdy=yLqMxEsn=P9zFA@mail.gmail.com>
 <20200115021545.GD11244@42.do-not-panic.com>
 <CACMCwJLJCA2iXS0QMKKAWQv252oUcmfsNvwDNP5+4Z_9VB-rTg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACMCwJLJCA2iXS0QMKKAWQv252oUcmfsNvwDNP5+4Z_9VB-rTg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 15, 2020 at 08:46:04PM +0200, Jari Ruusu wrote:
> On 1/15/20, Luis Chamberlain <mcgrof@kernel.org> wrote:
> > On Mon, Jan 13, 2020 at 09:58:25PM +0200, Jari Ruusu wrote:
> >> Before that 16-byte alignment patch was applied, my only one
> >> microcode built-in BLOB was "accidentally" 16-byte aligned.
> >
> > How did it accidentially get 16-byte aligned?
> 
> Old code aligned it to 8-bytes.
> There is 50/50-chance of it also being 16-byte aligned.

But *how? Why is there a 50/50 chance of it being aligned to
16 bytes if 8 bytes are currently specified?

> So it ended up being both 8-byte and 16-byte aligned.

What do you mean both? How can it be aligned to both?

> > Also, how do you *know* something is broken right now?
> 
> I haven't spotted brokenness in Linux microcode loader other
> than that small alignment issue.
> 
> However, I can confirm that there are 2 microcode updates newer
> than what my laptop computer's latest BIOS includes. Both newer
> ones (20191115 and 20191112) are unstable on my laptop computer
> i5-7200U (fam 6 model 142 step 9 pf 0x80). Hard lockups with both
> of them. Back to BIOS microcode for now.

I was more interested in how you are *certain*, other than manualcode
inspection, and that a spec indicates we should use 16 bytes for Intel
microcode -- that the 8 byte alignment *does* not allow users to
currently update their Intel CPU microcode for built-in firmware.                                      

From what I gather so far we have no case yet reported where we know for
sure it fails right now with the 8 byte alignment on 64-bit.
										                                                                                
This information would just be useful for the commit log.

  Luis
