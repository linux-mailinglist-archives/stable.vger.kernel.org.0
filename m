Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01ADC3BA1F4
	for <lists+stable@lfdr.de>; Fri,  2 Jul 2021 16:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhGBOJA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 10:09:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232606AbhGBOJA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 10:09:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625234788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m6Mna86YdcQ7UWi1VsRKdRyxdiO+RtsBgfouscqciX0=;
        b=BOs6S/kffhh7kHs3M9Nym2dAsBSk2DvMm6qUt+afuS0r87xvq5enXPAlpFBla3jQjbvG/W
        c1oRwTC3kNtDSeSd7HVR9OMh5cUriBr3zBflqVGYpb/8GDNJbAcRzqg+D6qA411KlfauxK
        CtHsF7yuFYvILKZjAQE6LHKSRBMcepo=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-YaM_2GyVOsWJ_QPkI-h5Mw-1; Fri, 02 Jul 2021 10:06:27 -0400
X-MC-Unique: YaM_2GyVOsWJ_QPkI-h5Mw-1
Received: by mail-wm1-f70.google.com with SMTP id h14-20020a05600c350eb02901dfc071c176so3553489wmq.3
        for <stable@vger.kernel.org>; Fri, 02 Jul 2021 07:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=m6Mna86YdcQ7UWi1VsRKdRyxdiO+RtsBgfouscqciX0=;
        b=Uot6s3VK/0PcWeSmetOMimxQIyBQxSP/bs7ZoDeGNpFPYsj8Qz6qyElBYyS+R3nwR8
         r47TehdaQB71upaIT9yj7BgNkrQAQxdmnjk/9L8BtjYt6OQbmT7W4sSSdtYlZxyZcWIV
         3LO+6KDlYUxioZ4/1A8l2od+M6u8S8NSLk5zSURHYKvUHew/XO2NYWRuG7G+e77+Bk67
         5zLGsqcULz5tt0KNXqDbGbzwp0btiartPC0MxIeTyhJ/D5FxHvbtnG4cyHHRuvsT9Q9o
         jWzCMmBSOaImJrJdeK/QUg8/SW2JUVi4D2jKCCX09I5IjB8UpFJ/9QkD7J/rLOYHQ4CR
         1vgQ==
X-Gm-Message-State: AOAM530ECNiDF2lP7vDJ1d5JWoIszCfPwMOQINPgUhAHfPaF6FF+MG/s
        92+gB4NZCIh0t8yoIC7KUNdEZ41t5+pgDJYKZYsb/jkF97wMBTnMxXhlmPUmTuEroBxfb8wol5o
        n62gr5uLKKx6GYk59
X-Received: by 2002:a5d:4a8d:: with SMTP id o13mr6117830wrq.241.1625234786021;
        Fri, 02 Jul 2021 07:06:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwA9TE3RJu3zzU4nu2KP8KMTfpIvvr1FHhaBi2SGdvArpcNv2wIeUwcMCsHztpsb/Ars/QDNw==
X-Received: by 2002:a5d:4a8d:: with SMTP id o13mr6117786wrq.241.1625234785778;
        Fri, 02 Jul 2021 07:06:25 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-171.dyn.eolo.it. [146.241.112.171])
        by smtp.gmail.com with ESMTPSA id p7sm3337907wrr.68.2021.07.02.07.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 07:06:25 -0700 (PDT)
Message-ID: <6c6eee2832c658d689895aa9585fd30f54ab3ed9.camel@redhat.com>
Subject: Re: [regression] UDP recv data corruption
From:   Paolo Abeni <pabeni@redhat.com>
To:     Matthias Treydte <mt@waldheinz.de>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>, stable@vger.kernel.org,
        netdev@vger.kernel.org, regressions@lists.linux.dev,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Date:   Fri, 02 Jul 2021 16:06:24 +0200
In-Reply-To: <20210702143642.Horde.PFbG3LFNTZ3wp0TYiBRGsCM@mail.your-server.de>
References: <20210701124732.Horde.HT4urccbfqv0Nr1Aayuy0BM@mail.your-server.de>
         <38ddc0e8-ba27-279b-8b76-4062db6719c6@gmail.com>
         <CA+FuTSc3POcZo0En3JBqRwq2+eF645_Cs4U-4nBmTs9FvjoVkg@mail.gmail.com>
         <20210702143642.Horde.PFbG3LFNTZ3wp0TYiBRGsCM@mail.your-server.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Fri, 2021-07-02 at 14:36 +0200, Matthias Treydte wrote:
> And to answer Paolo's questions from his mail to the list (@Paolo: I'm  
> not subscribed, please also send to me directly so I don't miss your mail)

(yup, that is what I did ?!?)

> > Could you please:
> > - tell how frequent is the pkt corruption, even a rough estimate of the
> > frequency.
> 
> # journalctl --since "5min ago" | grep "Packet corrupt" | wc -l
> 167
> 
> So there are 167 detected failures in 5 minutes, while the system is receiving
> at a moderate rate of about 900 pkts/s (according to Prometheus' node exporter
> at least, but seems about right)

Intersting. The relevant UDP GRO features are already off, and this
happens infrequently. Something is happening on a per packet basis, I
can't guess what.

It looks like you should be able to collect more info WRT the packet
corruption enabling debug logging at ffmpeg level, but I guess that
will flood the logfile.

If you have the kernel debuginfo and the 'perf' tool available, could
you please try:

perf probe -a 'udp_gro_receive sk sk->__sk_common.skc_dport'
perf probe -a 'udp_gro_receive_segment'

# neet to wait until at least a pkt corruption happens, 10 second
# should be more then enough
perf record -a -e probe:udp_gro_receive -e probe:udp_gro_receive_segment sleep 10

perf script | gzip > perf_script.gz

and share the above? I fear it could be too big for the ML, feel free
to send it directly to me.

> Next I'll try to capture some broken packets and reply in a separate mail,
> I'll have to figure out a good way to do this first.

Looks like there is corrupted packet every ~2K UDP ones. If you capture
a few thousends consecutive ones, than wireshark should probably help
finding the suspicious ones.

Thanks!

Paolo

