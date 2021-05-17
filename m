Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73FA3825AE
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 09:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235430AbhEQHtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 03:49:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40042 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232040AbhEQHtU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 03:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621237684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=foA59rqz8+k7mEgWv3w8jRXhDTqGIHMTsdgHdn6Ncc8=;
        b=Pjv5yGtxHw0DHBUbuotv5I5ImLZiLfL2IuMPNu7+aWW1Vg1HZCVIKUJMc15DUoyNhi6hZt
        juRowiaUyY7qAYTjFAEvq2hOj6c3mgS3b5exlkIr6FDVEue5iLwPe5jfABhscDcS0/m/Dk
        /vt9iLIa0XErQXdfL57wPY+i9bLPdpU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-Zcrz2wQnPxq1YmIQLduuqA-1; Mon, 17 May 2021 03:48:02 -0400
X-MC-Unique: Zcrz2wQnPxq1YmIQLduuqA-1
Received: by mail-wr1-f70.google.com with SMTP id u20-20020a0560001614b02901115c8f2d89so3394919wrb.3
        for <stable@vger.kernel.org>; Mon, 17 May 2021 00:48:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=foA59rqz8+k7mEgWv3w8jRXhDTqGIHMTsdgHdn6Ncc8=;
        b=fSs1QK89pX7I+MLPO2WmisTeuOH+aokmwNCeSgYuwQFImWV4hT1JJbgCSMLe9HDXkI
         Q9TRCpwsDATE0fvfcKvtNlZ5IFAwlm1XS3WFQ3hksh5qUw5Ei13n846HagVitGUZOcoL
         o3XCMtTSKl3c6euBbJWoyRDQvVV2KsePenaO1R/rxN3x64H1/r11rRQ3S4LyTaSZG29/
         f4eg3mARfVbYtrDki5Zr63uk1v4a4qllQVmn81vIIzCr0E7OWpgaENovb5SnOe1XVP5F
         yOC9Sa44ihQ8PzrleaIF/BBiJhvr0QQ8uNxyoKDavZnsQarI1sNx4CThiuenNbQY5oEC
         zEdw==
X-Gm-Message-State: AOAM532Lr233a1u2DF8gIIsvj+JS2M13oqZyK45wOtQmMg57vgAzNS6p
        n4CqeWVZWlMZalIaZbyXbCExV1yBC53z2jp4HqLK9DWc7HEflNMbuihS123NqDByWkyZSAK2tHO
        yXRfLcM6q5ebLjszQ
X-Received: by 2002:a05:600c:19cb:: with SMTP id u11mr18532615wmq.185.1621237681115;
        Mon, 17 May 2021 00:48:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw47pDwBEJD8phNQLjWppTJlyepMn/Rpiw2X1KSg2WbyqaFZMxzBQgT4ZiTKoa+0CGiulFMyA==
X-Received: by 2002:a05:600c:19cb:: with SMTP id u11mr18532597wmq.185.1621237680907;
        Mon, 17 May 2021 00:48:00 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-245-104.dyn.eolo.it. [146.241.245.104])
        by smtp.gmail.com with ESMTPSA id t7sm9832910wrs.87.2021.05.17.00.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 00:48:00 -0700 (PDT)
Message-ID: <12cfe9e36292a94b8492c0747f0d9ce1e781ae20.camel@redhat.com>
Subject: Re: [PATCH 5.10 380/530] udp: never accept GSO_FRAGLIST packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Date:   Mon, 17 May 2021 09:47:59 +0200
In-Reply-To: <20210517065716.GA15967@amd>
References: <20210512144819.664462530@linuxfoundation.org>
         <20210512144832.263718249@linuxfoundation.org> <20210515083717.GD30461@amd>
         <2e1ffc55aedb5d10eacce34cb7a5809138528d03.camel@redhat.com>
         <20210517065716.GA15967@amd>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 2021-05-17 at 08:57 +0200, Pavel Machek wrote:
> From: Paolo Abeni <pabeni@redhat.com>
> > > > 
> > > > [ Upstream commit 78352f73dc5047f3f744764cc45912498c52f3c9 ]
> > > > 
> > > > Currently the UDP protocol delivers GSO_FRAGLIST packets to
> > > > the sockets without the expected segmentation.
> > > > 
> > > > This change addresses the issue introducing and maintaining
> > > > a couple of new fields to explicitly accept SKB_GSO_UDP_L4
> > > > or GSO_FRAGLIST packets. Additionally updates  udp_unexpected_gso()
> > > > accordingly.
> > > > 
> > > > UDP sockets enabling UDP_GRO stil keep accept_udp_fraglist
> > > > zeroed.
> > > 
> > > What is going on here? accept_udp_fraglist variable is read-only.
> > 
> > Thank you for checking this!
> > 
> > The 'accept_udp_fraglist' field is implicitly initilized to zero at UDP
> > socket allocation time (done by sk_alloc).
> > 
> > So this patch effectively force segmentation of SKB_GSO_FRAGLIST
> > packets via the udp_unexpected_gso() helper.
> > 
> > We introduce the above field instead of unconditionally
> > segmenting SKB_GSO_FRAGLIST, because the next patch will use it (to
> > avoid unneeded segmentation for performance's sake for UDP tunnel), as
> > you noted.
> 
> Ok, but there's no follow up patch queued for 5.10...? Do we still
> need it there?

Patch d18931a92a0b5feddd8a39d097b90ae2867db02f is a performance
improvement, I think not worthy/suitable for stable.

For 5.10 78352f73dc5047f3f744764cc45912498c52f3c9 should be enough.

Thanks!

Paolo

