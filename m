Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5D81FEE71
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 11:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729014AbgFRJRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 05:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgFRJRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 05:17:03 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67440C06174E
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 02:17:03 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id h3so5028872ilh.13
        for <stable@vger.kernel.org>; Thu, 18 Jun 2020 02:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=o9KTE4I9rnxGdbZ3sBml/JNKLPyZZfukPwLd8u9qUcs=;
        b=sCPHwgzGoYKWLT2p4AqJqK0z6sJCF53phRt9T6w08daRSwD5uNdH8dwfRmK4LzMuD+
         4WL0YzIksGfof0ATpS0aKHIgrIQvTXPtHUmzaMKlNQnW4YbCibYi/UsrjevUphGJ/eG/
         dfWP7s8lVnwgJHCrlmURSynbeG+cuNjIO9u9+4BVkqzvR5Jym+icQxA8j0pxDlLPiRdp
         QYJsrXjx0iopWr2Wrk1pMCT89fxh+bQiOr8kq3DsNVdCLbbJfCzpd0vRBauwVFX00ahs
         T3A+8jfgZ9BUMsJvtUZX6GGalTG/CjVd64vjtuJ18leFzmQDlq6p1rtWAiNtcXLTcSDr
         ftsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o9KTE4I9rnxGdbZ3sBml/JNKLPyZZfukPwLd8u9qUcs=;
        b=PL8tm042rpLcxr8TeY5eMmB6VT14es3LFkKcQoY+OosYnoAI40hqpeRh10KVx1jxas
         UOH8BjcEE/MDbNYHK9VIEsVT15YiIqzIzKQy7FVmKH/dq4Ux4pbsN5ll+DCHUvtRey0C
         vtuj/qyTTtH95v6O6j8tXvwY256arJYcQ3EW1POAQEf9haUCrrjW5OTpcFVW2ZGshMNT
         wOlnJLX1TVvTydXKAIqsh36B9VKgZjvf73zdn9q1hJ8XzpnMmvDZ9L4DK14MO21JU87c
         +M9AbT9+mqk1f6hV8QigtNWLQh+akBP/7W1kFBcH1SOCtwcSonsAoe4VFPlUUv9XMQJK
         KZYw==
X-Gm-Message-State: AOAM531pIwuI2XRRSSCb/WWBym6lPZ1bkiQz2rTqaUpKwJcA1NmsKriv
        kKTfDHBbbz1rHg0GC4mdUITvrEv+SLZ0Ve9RWeeXeQ==
X-Google-Smtp-Source: ABdhPJzWh4xEo5DOeDGi/lib6b3d+2grcp16AW75WSsyLbymWFNKfQq2mp7Bw4TeH9ZXg7z7M3g7sCWyCQpHbEaLlxM=
X-Received: by 2002:a92:84d8:: with SMTP id y85mr3169204ilk.241.1592471822487;
 Thu, 18 Jun 2020 02:17:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200608093950.86293-1-gprocida@google.com> <CAGvU0HmbWA5aKZ-8jnYgaQGbfcVzGsGo7pm2Rf+ZfG8dHro_Bw@mail.gmail.com>
 <CAGvU0H=Gd5CUMMW35wBFV=ZaE4u6aiu3VKPCiJNujGcwOvy3WA@mail.gmail.com> <20200618073258.GA3856402@kroah.com>
In-Reply-To: <20200618073258.GA3856402@kroah.com>
From:   Giuliano Procida <gprocida@google.com>
Date:   Thu, 18 Jun 2020 10:16:45 +0100
Message-ID: <CAGvU0HmmV9+bkavHqB7TPbGwgUWvygLfWrCCmLmJ0uVOSHXoQQ@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: sync the update nr_hw_queues with blk_mq_queue_tag_busy_iter
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi.

On Thu, 18 Jun 2020 at 08:33, Greg KH <greg@kroah.com> wrote:
>
>
> A: http://en.wikipedia.org/wiki/Top_post
> Q: Were do I find info about this thing called top-posting?
> A: Because it messes up the order in which people normally read text.
> Q: Why is top-posting such a bad thing?
> A: Top-posting.
> Q: What is the most annoying thing in e-mail?
>
> A: No.
> Q: Should I include quotations after my reply?
>
> http://daringfireball.net/2007/07/on_top
>
> :)

I'm well aware of the above.
Alas, I haven't used mutt properly in about 15 years and I'm still
doing everything with Gmail.
Given that I was referring to the entire email thread, I punted on
finding a place to insert a comment.
BTW, there's a typo in the Q&A above. s/Were/Where/
:)

> On Thu, Jun 18, 2020 at 08:27:55AM +0100, Giuliano Procida wrote:
> > Hi Greg.
> >
> > Is this patch (and the similar one for 4.9) queued?
>
> f5bbbbe4d635 ("blk-mq: sync the update nr_hw_queues with
> blk_mq_queue_tag_busy_iter") is in the following stable releases:
>         4.4.224 4.9.219 4.14.176 4.19
>
> Do you not see it there?

We are referring to different "it"s.

Yours: f5bbbbe4d635 is the upstream patch that went into v4.19-rc1 and
which you back-ported to at least some of these kernels. This is
clearly there.

Mine: the commit sent earlier in this email thread - it's a
re-back-port, as I think the original back-port for 4.14 (and
similarly for 4.9) is incorrect. This has clearly not reached public
git, hence my question about whether the change was queued.

These are the ids of messages containing my commits:

4.14: 20200608093950.86293-1-gprocida@google.com
4.9: 20200608094030.87031-1-gprocida@google.com

> Or is there some other upstream commit you are referring to here?

No.

> thanks,
>
> greg k-h

I hope this clears things up.

Regards,
Giuliano.
