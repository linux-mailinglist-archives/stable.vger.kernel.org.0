Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE5E220EDF
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 20:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfEPSnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 14:43:19 -0400
Received: from mail-lf1-f51.google.com ([209.85.167.51]:36808 "EHLO
        mail-lf1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfEPSnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 14:43:18 -0400
Received: by mail-lf1-f51.google.com with SMTP id y10so3463933lfl.3
        for <stable@vger.kernel.org>; Thu, 16 May 2019 11:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7cZ1i1PlSN05rjwgmeSPBOyRXDYpMKnhLwTSuPaFE/U=;
        b=EfMguayduqZ24ff/F2BHhhOzDjdyonEf/8VAfENfIiKBoB1yeFBf4g99m6HV/ITW75
         ljiBLFVvQ2AmeClpItH1kbP5DUhFgHjF3hBfb0bAa+H9/32UpRA/gA93SgH3F+wg+0iD
         Q4TO8Dsk7hrNYV0eWnI/r80xmPZC2tINDBImE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7cZ1i1PlSN05rjwgmeSPBOyRXDYpMKnhLwTSuPaFE/U=;
        b=WM7k7rj+tQdziZg9fVRmvxd1izS4WWaQyuOJITz7IK9R9gDyYfhO07w2sBGjBF2AIO
         EbIzIQf+WNkG1TiH5d9QHAhxirD39OS9xH1qtPwaPb4L81y4xag71FLTD9WtLZRBxzIJ
         Z55Tb4GlOhFVR6hg5wiDfLbqmxqfio2kw9bivrCtcdX2WqY/kZw/EilBnntg26Wodv8v
         uPVBNwqS+gmegxKuf/4S/M/4oehjUYzSogVKcNtYNcq3msYYwLl7cOM9G7Op+NVkWXZj
         x/uHIZ3QO1AVxxa19fsxSlDvfS/aNwcPkvRxqvM6nzhwX5eVqvUFpH6c8NnwhEr0hfWm
         9GmQ==
X-Gm-Message-State: APjAAAWj6m4UVkw8daPDMsR77nBIulsTzfp7qWaGQDKDJM8d3S/LGXTE
        XEX1UM+uuPV8Hjcl3vzBGkyedJ35CjY=
X-Google-Smtp-Source: APXvYqzSVwb9FPFXIqPlwRBsLEt1lNQwhAZf+fQ6r7jpT+Oib+z/M7bVQhFZ9/NoT8QJJAyXmYcxJQ==
X-Received: by 2002:ac2:41da:: with SMTP id d26mr24594786lfi.34.1558032196483;
        Thu, 16 May 2019 11:43:16 -0700 (PDT)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id u3sm1094500lfc.73.2019.05.16.11.43.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 11:43:16 -0700 (PDT)
Received: by mail-lf1-f42.google.com with SMTP id y19so3438837lfy.5
        for <stable@vger.kernel.org>; Thu, 16 May 2019 11:43:15 -0700 (PDT)
X-Received: by 2002:a19:5015:: with SMTP id e21mr25981649lfb.62.1558032194090;
 Thu, 16 May 2019 11:43:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190516160135.GA45760@gmail.com> <CAHk-=wgtHi5mT7y=0ij-AksQQOBQJqV1apk2bRaH2tfRTxyFcg@mail.gmail.com>
 <20190516183945.GA6659@kroah.com>
In-Reply-To: <20190516183945.GA6659@kroah.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 16 May 2019 11:42:58 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgNFabppzpSQQgt7ajrYqmFjtkn2D3n=RvSEDryCLO+=g@mail.gmail.com>
Message-ID: <CAHk-=wgNFabppzpSQQgt7ajrYqmFjtkn2D3n=RvSEDryCLO+=g@mail.gmail.com>
Subject: Re: [GIT PULL] locking fix
To:     Greg KH <greg@kroah.com>
Cc:     Ingo Molnar <mingo@kernel.org>, stable <stable@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 11:39 AM Greg KH <greg@kroah.com> wrote:
>
> Thanks, I'll work on that later tonight...

Note that it probably is almost entirely impossible to trigger the
problem in practice, so it's not like this is a particularly important
stable back-port.

I just happened to look at it and go "hmm, it's not _marked_ for stable".

                  Linus
