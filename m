Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B251A7C09
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 15:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgDNNNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 09:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502652AbgDNNNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 09:13:13 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6D6C061A0C
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 06:13:12 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id c138so6050584pfc.0
        for <stable@vger.kernel.org>; Tue, 14 Apr 2020 06:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UG1KyR4eVmutMncH42ZDvZEQRy+Ic0+bhLMfkJGOswE=;
        b=qPgVg2/bt468b4o3OzUFoNMFuzkPLeqjd6HvPIL5Ua77M0xprBF+vegIE3KR9tl1mS
         Uyf1/Qnp4/rtJj3fzlJqTMycqz4emzkf5k0Cs70ZFueU1heinmciH/g7sSoVLujA/PlQ
         GAsCmdCo7U7khlXArFjbc3wzGhkmIPDbQLKMsQwhaVKdzCzrXwRpaGI0RvcYY1MzGQn/
         vvslkq9SkoW5Hd/1A3w9LQIkDX2yFemEqnY0D2bnDRCRaw41gS0piZS2oViSyptp/H53
         EZRufDWlTNrV+d/lzuMnKskrdzu4Ldq2TkAQ0HCSwJCIg+L6qmv3PC/HlsJW1lZewa02
         wo/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UG1KyR4eVmutMncH42ZDvZEQRy+Ic0+bhLMfkJGOswE=;
        b=BqLhkgFVv+/WX1GjuzXbFjeK+aaRjLeRqGylncRUj72oz9OERDlxQO3Ye95wB0Hgsn
         b2c43w07P1K5yTQBDVcoqmLg9p8SIkuN1GS7Gh8ZtAHUi+prIY6ND5lqXiuxZnKk/4dt
         BG8ZLXacaHetGNhUjLlaTFp/EdrDH50zhdGJVyRILdWsdtbzSGXLfGG0e+fPUs4qechZ
         3qvi3e7oJpfOvGZ147vFaJUIH0grgPDAfYdQT6gMgemxlFXqxJVCiBkF9YMQdU0hHpWw
         3JvsuGS5POCKEc96BuvDq+BSD69/+TnfOMci+UsLcOaLdaO2GH9GkvAE9HTlilgxLsXl
         cMuQ==
X-Gm-Message-State: AGi0PuakfdsYpjctZGBO7V7ccgmsYmy+veK2UPqFDFtePtfgQXypid/R
        3/RuFYdeegwWnsaeRWVRZwo2lVZM
X-Google-Smtp-Source: APiQypKuOTicbMNfKJBtmyyC6NWA105A9mq95bSjYkcHRJlxlyleRso+NloTt5CexpxeBtY1fwSOOA==
X-Received: by 2002:a63:904a:: with SMTP id a71mr21836610pge.68.1586869992374;
        Tue, 14 Apr 2020 06:13:12 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:5bbb:c872:f2b1:f53b])
        by smtp.gmail.com with ESMTPSA id c15sm11006021pfo.139.2020.04.14.06.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 06:13:11 -0700 (PDT)
Date:   Tue, 14 Apr 2020 22:13:09 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        stable@vger.kernel.org, Petr Mladek <pmladek@suse.com>
Subject: Re: printk: queue wake_up_klogd irq_work only if per-CPU areas are
 ready
Message-ID: <20200414131309.GE12779@google.com>
References: <20200414120613.GD12779@google.com>
 <20200414121412.GA605766@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414121412.GA605766@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (20/04/14 14:14), Greg KH wrote:
> On Tue, Apr 14, 2020 at 09:06:13PM +0900, Sergey Senozhatsky wrote:
> > Hello,
> > 
> > Commit ab6f762f0f53162d41 Linus' HEAD.
> > 
> > printk_deferred() does not make sure that it's safe to write to
> > per-CPU data, which causes problems when printk_deferred() is
> > invoked "too early", before per-CPU areas are initialized. There
> > are multiple bug reports, e.g.
> > https://bugzilla.kernel.org/show_bug.cgi?id=206847
> > 
> > 	-ss
> 
> So where do you want this commit backported to?

Well,  printk() is affected in all the kernels where
printk_deferred() relies on per-CPU data. Which may
translate to "pretty much all current stable kernels?"
This patch, however, uses printk_safe() bits, so it
won't apply on pre-printk_safe() kernels (not sure if
we have such -stable kernels though).

	-ss
