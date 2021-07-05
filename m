Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129603BB5FC
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 05:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbhGEDzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 23:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbhGEDzn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Jul 2021 23:55:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7F3C061762
        for <stable@vger.kernel.org>; Sun,  4 Jul 2021 20:53:07 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 22-20020a17090a0c16b0290164a5354ad0so14011253pjs.2
        for <stable@vger.kernel.org>; Sun, 04 Jul 2021 20:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Wh6fSPpm3oNA6Rdpj7F6yBoenikgqbJzM4BLnsqOaTo=;
        b=TmBQmuvyENG/N+R8sqzWlEbg8WWTU/eMX8c+V7lF7V016KDi9at6XHA+nda9HcCFpJ
         netnSjRpWj+BnoN577G8Glmg3g4nGjcvyCXBj4y+VFz+/IZAbKIMNCLaYko6qzwLhX9s
         GAABjuChvFLYzkJ0clPsMh95QiHc5wqtjkFZE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Wh6fSPpm3oNA6Rdpj7F6yBoenikgqbJzM4BLnsqOaTo=;
        b=Y+j+GCC3LyDthwUi6WcDk3bZDPP6ulmJzo8AWMBRv/X4NEHc+sI751HE4dpUIfF1XC
         NJlROVrkd7aq78iRglMWc5pLP6vhgGZwrGE4+pyYNTp/j/3R6IyW5FAuiBBa4Bmy3Fdg
         zohvIxWus8E1+JVZkRD9EyrWqJLUhrqmAx7cNp1RQj/JyaSCasYbJu1fXoLmvxaf02zR
         ye6A3aLyCeXT888NcFogR344BSaiT8MU/YuMdys69FM1LBIGVrZ9pPtaswQhxYdR4pJo
         0WMo3KNGZdzy2Sieq8p+aVxpPvXRA8xPj+/DyDRSItgztC2mGWf9FvlmnxIKANz+/MvF
         b2Og==
X-Gm-Message-State: AOAM530PRKnZaprvtcO4X64W9ydAFi4Vjdev8fzE9Ej6E34hqv/0IsZc
        PfHdCGdJteCEmbrWty/vTntTtA==
X-Google-Smtp-Source: ABdhPJxMYZMKLUd1BwMaWH0crcvPJ1PeGBWJ65grg52ZlIbXqnL+rqeopnA2EbYh7l7HLmPcJxbe3Q==
X-Received: by 2002:a17:902:e5c1:b029:129:3c05:cea3 with SMTP id u1-20020a170902e5c1b02901293c05cea3mr10712847plf.61.1625457186692;
        Sun, 04 Jul 2021 20:53:06 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:7a3a:c0d1:8813:add3])
        by smtp.gmail.com with ESMTPSA id j3sm11137821pfe.98.2021.07.04.20.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 20:53:06 -0700 (PDT)
Date:   Mon, 5 Jul 2021 12:53:01 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Sergey Senozhatsky <senozhatsky@chromium.org>,
        John Ogness <john.ogness@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] printk/console: Check consistent sequence number when
 handling race in console_unlock()
Message-ID: <YOKCHciF3PrD1Q1c@google.com>
References: <20210629143341.19284-1-pmladek@suse.com>
 <YNs/Vbi2Yt0s10Ye@google.com>
 <YNwkD3bTikepZr+k@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YNwkD3bTikepZr+k@alley>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (21/06/30 09:58), Petr Mladek wrote:
[..]
> > `retry` can be falsely set, console_trylock() does not spin on owner,
> > so the context that just released the lock can grab it again only if
> > it's unlocked. For the context that just has released the console_sem
> > and then acquired it again, because of the race, - console_seq will be
> > valid after it acquires the lock, then it'll jump to `retry` and
> > re-validated the console_seq - prb_read_valid(). If it's valid, it'll
> > print the message; and should another CPU printk that CPU will spin on
> > owner and then the current console_sem owner will yield to it via
> > console_lock_spinning branch.
> 
> I am not sure that I follow it correctly. IMHO, there are two possible
> races. I believe that you are talking about the 2nd scenario:

I guess I was thinking about two scenarios simultaneously, but you
certainly did a much better job describing them.

Thanks a lot for spending time on this!

> 1st scenario: console_unlock() retries but the message has been proceed
>    in the meantime:
[..]
> Result: CPU0 retired just to realize that the message
> 	has already been procceed.

Ack.

> 2nd scenario: printk() caller spins when other process is already
> 	processing it's message
[..]
> Result: CPU1 was spinning just to realize that the message has already
> 	been proceed.

Ack.

> It is not ideal. But the result is always correct.
>
> The races have been there already before. Only the race window in 1st
> scenario was a bit smaller.

Yeah, this was my assertion as well, but I wanted to double check.
