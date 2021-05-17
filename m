Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795523824C4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 08:51:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhEQGw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 02:52:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35076 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232040AbhEQGw4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 02:52:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621234297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f7qNgC8imSHKbn6li286hRYwuW3Kgkex7BvbIupjpGc=;
        b=L2im/GdJyeCvDavHITZJK9gfie3E3kI7t1TWGb82a/XBAPPFfJZcDSFoHUa0cO1GvZtN/F
        kHFjuIowdmOhoBKc8JvhkO8sh92oXSmEpoxObJ2pvQ9lyYhgy2Nz94YxU4e7E5/l274IF9
        EJSqvYhhneBWPIcCMrxCwINGS9acD7A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-4IfIj7_3PY6xw5dT9flRjA-1; Mon, 17 May 2021 02:51:34 -0400
X-MC-Unique: 4IfIj7_3PY6xw5dT9flRjA-1
Received: by mail-wr1-f71.google.com with SMTP id t5-20020adfb7c50000b029010dd0bb24cfso3384883wre.2
        for <stable@vger.kernel.org>; Sun, 16 May 2021 23:51:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=f7qNgC8imSHKbn6li286hRYwuW3Kgkex7BvbIupjpGc=;
        b=SEWg9sO2KwXA55J8xH3lkCXPxJcEXO23BMsYJ9zPV/JX/dlV+zi+JALvl4miOdE4D7
         E9pOFsT4vX8+zfYiuPGsfPGWF5Ul6oserEh5Gdc9dtgk96aPiNtBM965/5ilbrQ/Xii8
         k07VQUJT/0X/s4/i9WR5ePQOP8CdNWC0jOMtlp43G6krs2dvoGhYb8haspKnNGuJFSS+
         BPlMohBX9brbCJp/31lfpFPyWTpVPTxYRVSIUOh3unVdYv7LBZakujN8zhhwnJxNRFFf
         JvzwoeE9sVhCP3A86JGLT6rih2stFa2FajdW0k05F7PnBqVjgTo64kzZJYjCvUD7OfCx
         1Rig==
X-Gm-Message-State: AOAM532uc+7KPYSb6mvFqGXnNty7Jn1+CxtCL4N1XIbkCQUNjUZa5iik
        5hu1AT2zpJpNu7rwWRhLYLM2c3XUw4dBnEEcxbsRbOlkLy6/WEtTwLEr3NfPeLWZ1oMXv9YyQ6P
        QqJxE1vc/FPBZCURp
X-Received: by 2002:adf:fd82:: with SMTP id d2mr73783375wrr.218.1621234292984;
        Sun, 16 May 2021 23:51:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy9tfRW+YS/gxDEIQCy7gwUfbRmVNS3PFiKPseSRXngi3Mq9CGDyrCDyAFl1I6VqBfyTpMgVQ==
X-Received: by 2002:adf:fd82:: with SMTP id d2mr73783362wrr.218.1621234292843;
        Sun, 16 May 2021 23:51:32 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-245-104.dyn.eolo.it. [146.241.245.104])
        by smtp.gmail.com with ESMTPSA id k7sm16778838wro.8.2021.05.16.23.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 23:51:32 -0700 (PDT)
Message-ID: <2e1ffc55aedb5d10eacce34cb7a5809138528d03.camel@redhat.com>
Subject: Re: [PATCH 5.10 380/530] udp: never accept GSO_FRAGLIST packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Date:   Mon, 17 May 2021 08:51:31 +0200
In-Reply-To: <20210515083717.GD30461@amd>
References: <20210512144819.664462530@linuxfoundation.org>
         <20210512144832.263718249@linuxfoundation.org> <20210515083717.GD30461@amd>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2021-05-15 at 10:37 +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Paolo Abeni <pabeni@redhat.com>
> > 
> > [ Upstream commit 78352f73dc5047f3f744764cc45912498c52f3c9 ]
> > 
> > Currently the UDP protocol delivers GSO_FRAGLIST packets to
> > the sockets without the expected segmentation.
> > 
> > This change addresses the issue introducing and maintaining
> > a couple of new fields to explicitly accept SKB_GSO_UDP_L4
> > or GSO_FRAGLIST packets. Additionally updates  udp_unexpected_gso()
> > accordingly.
> > 
> > UDP sockets enabling UDP_GRO stil keep accept_udp_fraglist
> > zeroed.
> 
> What is going on here? accept_udp_fraglist variable is read-only.

Thank you for checking this!

The 'accept_udp_fraglist' field is implicitly initilized to zero at UDP
socket allocation time (done by sk_alloc).

So this patch effectively force segmentation of SKB_GSO_FRAGLIST
packets via the udp_unexpected_gso() helper.

We introduce the above field instead of unconditionally
segmenting SKB_GSO_FRAGLIST, because the next patch will use it (to
avoid unneeded segmentation for performance's sake for UDP tunnel), as
you noted.

Please let me know if the above clarifies the situation.

Thanks!

Paolo

