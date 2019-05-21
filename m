Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEC0256D7
	for <lists+stable@lfdr.de>; Tue, 21 May 2019 19:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbfEURiP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 May 2019 13:38:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48670 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729051AbfEURiP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 May 2019 13:38:15 -0400
Received: from mail-wm1-f71.google.com ([209.85.128.71])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1hT8iL-0006rU-1i
        for stable@vger.kernel.org; Tue, 21 May 2019 17:38:13 +0000
Received: by mail-wm1-f71.google.com with SMTP id h8so999590wmf.1
        for <stable@vger.kernel.org>; Tue, 21 May 2019 10:38:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fcNXBZFJb+DLhnDXLU3vOO28yF5WtLq1sqqHjjzYzVE=;
        b=P3211D+4G36p65bWP7C46Bt/t3iwiwgG20kzIXhHdFSa05qm1Awo7qlKajsdCqNw1k
         iR78kXmmZeJSVkLZ64hpxZ8YBfbk7T4zn4dG8CuIXNTHrJ2ZUO018oxZKWsPodXSCI7r
         oByeXNtTLUhzlI0tywdnB5P6mKxXd7hC+4ZVUjlSfmW/1uZHAsrq5skoTj8ZrkdgXqyE
         Jrl0krFpVtFgWhHoaFFNq61aiqP6YsuWLSqWbfgbxxEI4sQAdI4gJxouVBY4kxPRJmAh
         LMoUnR2+jcC2GuvK1CUep1+XF87AhP2Kjyco9PlN+iFzuurcOjCEUhdFmwb4jn/pkD0z
         oq+Q==
X-Gm-Message-State: APjAAAUp1FlYMBhLzVwj+L9SQ+Eae0rJ2D8J9KMCTKSUv8DKNLBiRY5p
        2C7odn4Nywf0u4xVLetlyQs6v7WS6zVkTpgfceaIzTprp/C8GwNWfsP1YNiVYGWODNf9qPACN2J
        Xl6xYCOjQ/r0piDQSEMpsDRY8bg20heD2mNlSYWYV5+GYkffm2g==
X-Received: by 2002:a7b:cd0e:: with SMTP id f14mr4127764wmj.127.1558460292789;
        Tue, 21 May 2019 10:38:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw81v2o+MMfWEy/WTk62q4WO4dG0iEhjtk0hLe0Eaytx5oKhO+Tt7BlfcmAgqlKnhfh6p/m/uVVK26fQg8gQI8=
X-Received: by 2002:a7b:cd0e:: with SMTP id f14mr4127752wmj.127.1558460292640;
 Tue, 21 May 2019 10:38:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190520220911.25192-1-gpiccoli@canonical.com>
 <20190520220911.25192-2-gpiccoli@canonical.com> <20190521125634.GB16799@infradead.org>
 <CAHD1Q_z23AO+NRid1xYTeke_5GAe6hPianEZKBf5P30FrfZGFg@mail.gmail.com> <20190521172258.GA32702@infradead.org>
In-Reply-To: <20190521172258.GA32702@infradead.org>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Tue, 21 May 2019 14:37:36 -0300
Message-ID: <CAHD1Q_zgBxE-nD6zY4koJGJC9K53+6d6-xGpEpA6W4sudu0Pgg@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] md/raid0: Do not bypass blocking queue entered for
 raid0 bios
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        axboe@kernel.dk, Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        Ming Lei <ming.lei@redhat.com>,
        Song Liu <liu.song.a23@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 21, 2019 at 2:23 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Tue, May 21, 2019 at 11:10:05AM -0300, Guilherme Piccoli wrote:
> > Hi Christoph, thanks for looking into this.
> > You're right, this series fixes both issues. The problem I see though
> > is that it relies
> > on legacy IO path removal - for v5.0 and beyond, all fine. But
> > backporting that to
> > v4.17-v4.20 stable series will be quite painful.
> >
> > My fixes are mostly "oneliners". If we could get both approaches upstream,
> > that'd be perfect!
>
> But they basically just fix code that otherwise gets removed.  And the way
> this patches uses the ENTERED flag from the md code looks slightly
> sketchy to me.  Maybe we want them as stable only patches.

OK, it makes sense to me, if that is a possibility. The fist one is
clearly a small
and non-intrusive fix. The 2nd indeed is more invasive heh

Please let me know how to proceed to have that added at least in stable trees;
this would help a lot the distro side of the world hehe

Cheers,


Guilherme
