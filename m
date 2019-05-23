Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0D242847F
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 19:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731156AbfEWRGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 13:06:40 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34576 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730867AbfEWRGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 13:06:40 -0400
Received: by mail-qt1-f195.google.com with SMTP id h1so7629832qtp.1;
        Thu, 23 May 2019 10:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tzAHR5rmfh/TFIXYIHzSw6buL7+70H5Ot5Wu7FBJYBo=;
        b=jDsWohnysffIeI5APcrXrgR6fZ5MhkH09iEGmhgZ7kCViXYEOhyCd7y91chqUmipEt
         2FrDCGIeKkQFN1tObQUQrbWMrtirnRaUkr3eft07i55kERGDhIXgXnq0/6wLFc/CGQ3/
         AtEyxF4daRvXgqxCj1agF+7krmG7CUq9ytikxiGSnwjEdB5pT8o0YTyYjGUAga0mCfwF
         zpfVTtCw46jMJpmznBtD3FNtoie2Jar4l4RqUs01Xgg+fD5e3Oi5nn6VHFgaclmYRENo
         1OQ1EuP9DHtDkIqJpJfAQPZBoW08gQ3valir3Kb3v7KhHTcFpL/eVEFwSCfwZQ58zypp
         vrvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tzAHR5rmfh/TFIXYIHzSw6buL7+70H5Ot5Wu7FBJYBo=;
        b=EcAehFuc8COPYiTh2d4jWkJvUtFCsTC1S+mbkaCdHpt2MK6GdYxc2V302DsmDJKqjd
         Q4B+XCsrbDgKVv+sxDAyXV5qRiOtX2SlFrei6rg2/BybCSywJWefFSONRVxieHL2ZBTD
         5bTZxMkYbJu8bxHI8YHYoDqtY5+jmyDW4BgybbgXPM1SE8NI1g4REZP1m87+WCYS54Ia
         P6loP8VbNSasdZhKh5JXU4kQfH/vOn7ra3+zJ+1wNawO9+/BhVvkJEfPAOieEA0n6wJ/
         ycLWyrWCD9NRapD6cOuE6ixkrVDMEtSrHh7+y09l5T3adqCkQOjffjeX7vncpCUa3rov
         AT/A==
X-Gm-Message-State: APjAAAXuPFuxmRu2HoVn14RGrtKtVcidVVZk8xwsgEgvW3py6byE9jV+
        hvONXEO9aB6lBZQSTcvGGpaLY3F4cOGnXjtSTXA=
X-Google-Smtp-Source: APXvYqyoqxK6/SVoOZtsXHuNMWFHMGBI1KxeWNxGegcBVtTenide+MA2bCnqDhY+dBeXRgVq/5iUc/zWBy6uAqEpyTE=
X-Received: by 2002:ac8:16a4:: with SMTP id r33mr54894808qtj.118.1558631199474;
 Thu, 23 May 2019 10:06:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190520220911.25192-1-gpiccoli@canonical.com>
 <CAPhsuW6KayaNR-0eFHpvPG-LVuPFL_1OFjvZpOcnapVFe2vC9Q@mail.gmail.com> <3e583b2d-742a-3238-69ed-7a2e6cce417b@canonical.com>
In-Reply-To: <3e583b2d-742a-3238-69ed-7a2e6cce417b@canonical.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 23 May 2019 10:06:28 -0700
Message-ID: <CAPhsuW7o9bj5DYnUDkCqDeW7NnfNTSBBWJC5_ZVxhoomDEEJcg@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] block: Fix a NULL pointer dereference in generic_make_request()
To:     "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Cc:     linux-block@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>, dm-devel@redhat.com,
        Jens Axboe <axboe@kernel.dk>,
        Gavin Guo <gavin.guo@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        "Guilherme G. Piccoli" <kernel@gpiccoli.net>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>,
        Eric Ren <renzhengeek@gmail.com>, hch@infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 23, 2019 at 7:36 AM Guilherme G. Piccoli
<gpiccoli@canonical.com> wrote:
>
> On 21/05/2019 02:59, Song Liu wrote:
> >
> > Applied both patches! Thanks for the fix!
>
> Hi Song, sorry for the annoyance, but the situation of both patches is a
> bit confused for me heheh
>
> You mention you've applied both patches - I couldn't find your tree.
> Also, Christoph noticed Ming's series fixes both issues and suggested to
> drop both my patches in favor of Ming's clean-up, or at least make them
> -stable only.
>
> So, what is the current status of the patches? Can we have them on
> -stable trees at least? If so, how should I proceed?
>
> Thanks in advance for the clarification!
> Cheers,
>
>
> Guilherme

Sorry for the confusion and delay. I will send patches to stable@.

Song
