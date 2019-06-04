Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB3F934097
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 09:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfFDHq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 03:46:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726637AbfFDHq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 03:46:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60D1B24C98;
        Tue,  4 Jun 2019 07:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559634386;
        bh=urzh/xDYEkBK23VDNPCtMBq+mujqArs+fOmkoAeT0H8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E1bb0IxBNIZ594TsygB7KkKwwLXkgLaN46EykQ+vzsNlsRVtl1fxjCGoBOjfjuCdf
         MreLfF+CPghCIaZ9mzXHvlINJtqZfOUe+6ubKxE6/c2pj1tTBCu2VZQlZtgbn3EhYZ
         zgDmyq7jKZnn56rZjL7MM+LJSPEZmyrm02ns1heI=
Date:   Tue, 4 Jun 2019 09:46:24 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Zubin Mithra <zsm@chromium.org>, stable <stable@vger.kernel.org>,
        groeck@chromium.org, Gen Zhang <blackgod016574@gmail.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap
 1:1 mapping code")
Message-ID: <20190604074624.GA6840@kroah.com>
References: <20190603223851.GA162395@google.com>
 <CAKv+Gu8VioGy1h8n0zKAqj+m_PBZdRU+BmJDH7=D7=iEiKRpgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8VioGy1h8n0zKAqj+m_PBZdRU+BmJDH7=D7=iEiKRpgw@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 04, 2019 at 09:38:27AM +0200, Ard Biesheuvel wrote:
> On Tue, 4 Jun 2019 at 00:38, Zubin Mithra <zsm@chromium.org> wrote:
> >
> > Hello,
> >
> > CVE-2019-12380 was fixed in the upstream linux kernel with the commit :-
> > * 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1 mapping code")
> >
> > Could the patch be applied in order to v4.19.y?
> >
> > Tests run:
> > * Chrome OS tryjob
> >
> 
> Unless I am missing something, it seems to me that there is some
> inflation going on when it comes to CVE number assignments.
> 
> The code in question only affects systems that are explicitly booted
> with efi=old_map, and the memory allocation occurs so early during the
> boot sequence that even if we fail and handle it gracefully, it is
> highly unlikely that we can get to a point where the system is usable
> at all.
> 
> Does Chrome OS boot in EFI mode? Does it use efi=old_map? Is the
> kernel built with 5 level paging enabled? Did you run it on 5 level
> paging hardware?
> 
> Or is this just a tick the box exercise?
> 
> Also, I am annoyed (does it show? :-))  that nobody mentioned the CVE
> at any point when the patch was under review (not even privately)

CVEs are almost always asked for _after_ the patch is merged, as the
average fix-to-CVE request timeframe is -100 days.

Also, for the kernel, CVEs almost mean nothing, so if this really isn't
an issue, I'll not backport this.

And I really doubt that any chromeos device has 5 level page tables just
yet :)

thanks,

greg k-h
