Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DEE61810C3
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 07:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgCKGcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 02:32:18 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:54624 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgCKGcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 02:32:17 -0400
Received: by mail-pj1-f66.google.com with SMTP id np16so460433pjb.4;
        Tue, 10 Mar 2020 23:32:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BiqkU0kgudgxfMNr8sz/W+boPzUuPRsY6m8LnajSiSo=;
        b=tEw9CmvkqmKD1kw7YftXNdS1YTJ9GrlgBr89onWa32waQ6bgrJ5VrJJ3B3fTiwNdBf
         CQlZNZNdkF/M2Af2T6zyyY7LlALbyGBeuK/o+F57Z0ja3Kk5r+KeoWLqH54dKEq6wNmJ
         r5AdFMQ9EEQ4pG/adktMLv+vq10X57vAY/zscMdRtRtpuhzhKzZzSU8R2YFFCyZstiHL
         U0KjWlJ9YKSXI805E5QzSXe1O2DUsbTXvTn5dX/J3jvVe7McXZ1HTzgquzlpdhrnjWaC
         zgoGvJm6TMzWohCrMzDe1R7faDKV0XisyjcjUDCDkHNILmUabZPqj7vY2qaI5MCWZ/mB
         iEAA==
X-Gm-Message-State: ANhLgQ2IQbcnsBL2yTQEnT5s8HHD0hfG+JREItfxgtyHsMdi1fYKu1Fu
        gBK9xIK0eVfI9QnM5dXY0qA=
X-Google-Smtp-Source: ADFU+vu2aozRfvpq7dJ9tqoXad3tmaz9u0pW4PSaUrXJ2yr1/AMV0NwtvefPkNd+X86RY8bmQYiHcQ==
X-Received: by 2002:a17:902:b58e:: with SMTP id a14mr813177pls.277.1583908336603;
        Tue, 10 Mar 2020 23:32:16 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id nh4sm4109926pjb.39.2020.03.10.23.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 23:32:15 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 88EB44028E; Wed, 11 Mar 2020 06:32:14 +0000 (UTC)
Date:   Wed, 11 Mar 2020 06:32:14 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Eric Biggers <ebiggers@kernel.org>, NeilBrown <neilb@suse.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>,
        Kees Cook <keescook@chromium.org>, benh@debian.org
Subject: Re: [PATCH] kmod: make request_module() return an error when
 autoloading is disabled
Message-ID: <20200311063214.GM11244@42.do-not-panic.com>
References: <20200310223731.126894-1-ebiggers@kernel.org>
 <20200311043221.GK11244@42.do-not-panic.com>
 <0256C870-590C-426A-B4DF-4C272E46B75F@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0256C870-590C-426A-B4DF-4C272E46B75F@joshtriplett.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 06:55:30AM +0100, Josh Triplett wrote:
> On March 11, 2020 5:32:21 AM GMT+01:00, Luis Chamberlain <mcgrof@kernel.org> wrote:
> >On Tue, Mar 10, 2020 at 03:37:31PM -0700, Eric Biggers wrote: 
> >> However, request_module() should also
> >> correctly return an error when it fails.  So let's make it return
> >> -ENOENT, which matches the error when the modprobe binary doesn't
> >exist.
> >
> >This is a user experience change though, and I wouldn't have on my
> >radar
> >who would use this, and expects the old behaviour. Josh, would you by
> >chance?
> 
> I don't think this affects userspace. But I'd suggest Ben Hutchings (CCed).

It doesn't, so yes no verififcation needed. Thanks the quick response though!

  Luis
