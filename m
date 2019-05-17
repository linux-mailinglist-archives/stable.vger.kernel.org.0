Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C21E121B0D
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 17:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfEQP4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 11:56:55 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41035 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729256AbfEQP4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 11:56:54 -0400
Received: by mail-pl1-f194.google.com with SMTP id f12so3534317plt.8
        for <stable@vger.kernel.org>; Fri, 17 May 2019 08:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nrqjUKLpsCtJJ04ErApfFg0RR5DmaSuhMiOpsYm4b/k=;
        b=E7oWj3DDjt+kEdZeewfLumYWCuhjVUc/osh0djljunRfkteN7XJXNs5MS+RX5GI/Lq
         Puj3Z3HgxCD/6AC6HOECerm430xm+nTSbJv05r7At57ftXWvGwRJYxFFEUoVKbSOr4Gr
         iBqixCpWNw+8db7SWpOHdiN1vkT5zH1by9VEE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nrqjUKLpsCtJJ04ErApfFg0RR5DmaSuhMiOpsYm4b/k=;
        b=IKety8rt2UfnqYXdjwgW/XyGiVTrO7BUwhtbm6I6yaJfe36x/QCu/YOtldWYGN9TFH
         bKM6fOZAUQ1zP0RjWg9bhU/sMYLB0o0lZaU+4+hqlLIaQtslUl18CW6yZprDwu3vaIj4
         DrAkZ/wQvmNKRxUTl+UGesZY7ww7SjKRAy2ndPCA/NWNPl0sDaXpWHqxi4jnfZIhlQ37
         //hxfhxjT7r1CvYfMRbILgXnFhMuBzy1B2XUvp4l3k6OnVMkB+NpkxwiXzLUIUWVrUga
         kHuDK2Jff0Vd/IcUL8JZwjP6hONgZR5Fk6dS1OPeIEB8bInblqnAOjnZENki8cxvVGuy
         CIhg==
X-Gm-Message-State: APjAAAWRlfNoppjUOsBMcASt4bjPOFppE6Jv1Y+kBpHPWyhqAoccQYqR
        A0l4h2XFiY0Eh4YuDyiVXxRSPQ==
X-Google-Smtp-Source: APXvYqx5L1JIW0KgYJL4c2qH5Z+VHBDccN7Wk+p90g4IAEzcge2qHeMGOakMMnS0HM9WEXWMQfyTKA==
X-Received: by 2002:a17:902:2bc9:: with SMTP id l67mr21517345plb.171.1558108614314;
        Fri, 17 May 2019 08:56:54 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 2sm11532199pgc.49.2019.05.17.08.56.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 08:56:53 -0700 (PDT)
Date:   Fri, 17 May 2019 08:56:52 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>,
        stable <stable@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Wilcox <willy@infradead.org>,
        Jeff Smits <jeff.smits@intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libnvdimm/pmem: Bypass CONFIG_HARDENED_USERCOPY overhead
Message-ID: <201905170855.8E2E1AC616@keescook>
References: <155805321833.867447.3864104616303535270.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190517084739.GB20550@quack2.suse.cz>
 <CAPcyv4iZZCgcC657ZOysBP9=1ejp3jfFj=VETVBPrgmfg7xUEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4iZZCgcC657ZOysBP9=1ejp3jfFj=VETVBPrgmfg7xUEw@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 08:08:27AM -0700, Dan Williams wrote:
> As far as I can see it's mostly check_heap_object() that is the
> problem, so I'm open to finding a way to just bypass that sub-routine.
> However, as far as I can see none of the other block / filesystem user
> copy implementations submit to the hardened checks, like
> bio_copy_from_iter(), and iov_iter_copy_from_user_atomic() . So,
> either those need to grow additional checks, or the hardened copy
> implementation is targeting single object copy use cases, not
> necessarily block-I/O. Yes, Kees, please advise.

The intention is mainly for copies that haven't had explicit bounds
checking already performed on them, yes. Is there something getting
checked out of the slab, or is it literally just the overhead of doing
the "is this slab?" check that you're seeing?

-- 
Kees Cook
