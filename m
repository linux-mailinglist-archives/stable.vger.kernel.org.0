Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1BF21BD1
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 18:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfEQQke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 12:40:34 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:45894 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfEQQkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 12:40:33 -0400
Received: by mail-pl1-f175.google.com with SMTP id a5so3569421pls.12
        for <stable@vger.kernel.org>; Fri, 17 May 2019 09:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4baC9hVmPvCMRjjnr6WrMvdeGCowj8DhAHmgc2PUmc8=;
        b=b9XzwC9QDGBg9qLVMgJWRML5ZZz5Kd9Me3loTz5rnrV+Gm+nteKj0X6uqTPOiPnXUu
         AD7VHIV6giGlxx5J7w4vopdCZSjd47gFjQ9n+/adpvlKujkJMtOb2XKfI408I29n0AnW
         96QnHtqye/BCD+PLwXdbtsaFDBqofGB940e0E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4baC9hVmPvCMRjjnr6WrMvdeGCowj8DhAHmgc2PUmc8=;
        b=FlkWD7radLVZCtt8cOjp7rVWyMsJlAHhVeFAlzQGd9bd9UeXRvX0xE0d5WQp/b8s6N
         mnkDPi/xFGTmlsvLWZ7+ErAWLx/Myo6sodsYN4WB5nutWBLZW1Khx1EzVliH2lvU+ZNb
         7+S+UD9Z0gcWxRrkZdQmMS9bEBGO5imXPZwNEIDllEU3vRuqyWd+vjvVbGMBiyqSxOXl
         6DRCR50Wf/LkhkzfMmvtYzHvm04Zs3VGWm/QcetxwZ8+7sosVHJUA6mGD6Hm1CBUjBcF
         yrTvI209WIFNKbRkfi4pX6K8lDfvVv2UWni+uJjkCCAkYAfbkYq9i/g5zA+WPi8DqoLf
         qrIg==
X-Gm-Message-State: APjAAAV5bsmDNDRC4op/RCqMNE+hQxr89Pb+Vu+av5mwZlGqwbhq1uW3
        /4LuH28S//xA6noT6Y53Nx6/oA==
X-Google-Smtp-Source: APXvYqxT4MWydQqGVRl8y+8BCJCWqRoi8v5dpo8YXASLwcoHuift9vY3I4Y0ejr9OwtLsAO8IKoMAA==
X-Received: by 2002:a17:902:778d:: with SMTP id o13mr1115077pll.275.1558111233247;
        Fri, 17 May 2019 09:40:33 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d186sm14225137pfd.183.2019.05.17.09.40.32
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 09:40:32 -0700 (PDT)
Date:   Fri, 17 May 2019 09:40:31 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Jan Kara' <jack@suse.cz>, Dan Williams <dan.j.williams@intel.com>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Smits <jeff.smits@intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
Message-ID: <201905170938.99AACF0D@keescook>
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
 <2d8b1ba7890940bf8a512d4eef0d99b3@AcuMS.aculab.com>
 <201905170845.1B4E2A03@keescook>
 <ac76e29576b14fcb9a18e5a9e6ab8394@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac76e29576b14fcb9a18e5a9e6ab8394@AcuMS.aculab.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 04:14:03PM +0000, David Laight wrote:
> From: Kees Cook
> > Sent: 17 May 2019 16:54
> ...
> > > I've changed some of our code to use __get_user() to avoid
> > > these stupid overheads.
> > 
> > __get_user() skips even access_ok() checking too, so that doesn't seem
> > like a good idea. Did you run access_ok() checks separately? (This
> > generally isn't recommended.)
> 
> Of course, I'm not THAT stupid :-)

Right, yes, I know. :) I just wanted to double-check since accidents
can happen. The number of underscores on these function is not really
a great way to indicate what they're doing. ;)

-- 
Kees Cook
