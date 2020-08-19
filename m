Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494F324A80D
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 22:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgHSUyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 16:54:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20263 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbgHSUyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 16:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597870460;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HLbcN3vXZ9Y2wTIy0CakALnZtq7aqQjupWdhJYMTw6g=;
        b=Sp9yPMfKm0Uo3wrF9NvLpAq8sqMAGWfDvr32tlW/wg1GUdBHUsQzRqv+sxdJyIXUsJKj/l
        g7IXSea8pQYkXD3fA5Txb676dCeyCH0SuNiXZYTLEcu6EAxEFjobxLM6O8x1d1kEWgHMgA
        xMchL9XH8mKN70Y/sxT/JAPjUBDs8c8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-103-jW2LbNnCMW6xxKBFSCqTtw-1; Wed, 19 Aug 2020 16:54:18 -0400
X-MC-Unique: jW2LbNnCMW6xxKBFSCqTtw-1
Received: by mail-pj1-f69.google.com with SMTP id a6so2130706pjd.1
        for <stable@vger.kernel.org>; Wed, 19 Aug 2020 13:54:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HLbcN3vXZ9Y2wTIy0CakALnZtq7aqQjupWdhJYMTw6g=;
        b=PNLe93VeM3zTX8KB8/DlQ0SevKvEW4YDBakauHX37gYDYCp0AwwimG/L0FICdYCGuN
         uZeuAbwDnljCjmZxHH+j4nZX/49m8H9a1LrtR/PQdtJmQsq6w+KZWq9iUOpEsRHyTgw3
         UQe228fwcz+mSdd5Flc+rCJJMudPR4xKPhQ9lb0jUZpStNbxYrQ3aJiHlahT/RMdfys/
         TnSD2TzQJRz3Eke+fegLXzy7+lqiBTAHX7s70733DNJu9No+70YMxUs0ntCF+SEFV9Fa
         i2Omcboz4Et3R6+L8MG91I2PL6CMyvbXVGJQSulAsm2VvEmMrh5+EwPzBchlXn0/ZXl1
         IJrA==
X-Gm-Message-State: AOAM5324CgnJbMBY0ZKbgEfoeKzm3qnemEGdtqt/+Sy3mrDr6WNZdA0a
        JGd34zdczlyWkccxdUSed58w39ww+hNYKX9fX8KMG27LCqBgSlWtnmad+CKgiUERO7O1axlzKTR
        aIotM+azg1RAN00YQ
X-Received: by 2002:a63:151c:: with SMTP id v28mr143597pgl.357.1597870457463;
        Wed, 19 Aug 2020 13:54:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywvQDnMQvNa8P+hthAlsp+uhweYcJmFYGtS1L+2LN00W9j3zaiphk/gpzyn1Jn6xogphyN9g==
X-Received: by 2002:a63:151c:: with SMTP id v28mr143580pgl.357.1597870457205;
        Wed, 19 Aug 2020 13:54:17 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id nu14sm3825940pjb.19.2020.08.19.13.54.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 13:54:16 -0700 (PDT)
Date:   Thu, 20 Aug 2020 04:54:05 +0800
From:   Gao Xiang <hsiangkao@redhat.com>
To:     Rafael Aquini <aquini@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Eric Sandeen <esandeen@redhat.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, THP, swap: fix allocating cluster for swapfile by
 mistake
Message-ID: <20200819205405.GB26216@xiangao.remote.csb>
References: <20200819195613.24269-1-hsiangkao@redhat.com>
 <20200819130506.eea076dd618644cd7ff875b6@linux-foundation.org>
 <20200819204405.GB2096425@optiplex-lnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819204405.GB2096425@optiplex-lnx>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Rafael,

On Wed, Aug 19, 2020 at 04:44:05PM -0400, Rafael Aquini wrote:
> On Wed, Aug 19, 2020 at 01:05:06PM -0700, Andrew Morton wrote:
> > On Thu, 20 Aug 2020 03:56:13 +0800 Gao Xiang <hsiangkao@redhat.com> wrote:
> > 
> > > SWP_FS doesn't mean the device is file-backed swap device,
> > > which just means each writeback request should go through fs
> > > by DIO. Or it'll just use extents added by .swap_activate(),
> > > but it also works as file-backed swap device.
> > 
> > This is very hard to understand :(
> > 
> 
> I'll work with Gao to rephrase that message. Sorry!

Sorry about that :( I just finished the test and went through
the related swap code and finally saw this so I think it wouldn't
work entirely for the current swap code... and Sorry about
my limited English.

Kindly feel free to repost the patch with rephrased commit
message. Anyway, I've done this task :)

Thanks,
Gao Xiang

