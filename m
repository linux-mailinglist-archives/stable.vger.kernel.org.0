Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89ACD251B0D
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 16:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgHYOmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 10:42:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23012 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbgHYOmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 10:42:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598366528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1PxHK07pzXYHK1FypslTBPNlk/QUqT+EnjfLL/+phFE=;
        b=K4M5BGdKZRQzmlt1VXTTstlktQ9uP8dIhLGjOrpySNbLYq0dyiaH9CXEcuBTjEa4GZkZsh
        W71R2ateE/nWhqLKTf56T46WBoE43U6redlemXwTn5gSi2uum4fHDEtXsFHKj/HxCq/e0i
        +dJGn/J1jLB0Mir1PEAYLGIeFnrGKHI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-q2NyxlsjMWGw2OP_yDv5ZA-1; Tue, 25 Aug 2020 10:42:06 -0400
X-MC-Unique: q2NyxlsjMWGw2OP_yDv5ZA-1
Received: by mail-qk1-f198.google.com with SMTP id k142so9125883qke.7
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 07:42:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1PxHK07pzXYHK1FypslTBPNlk/QUqT+EnjfLL/+phFE=;
        b=onn1xMJOp6wvGCV4wRzFvlrCckNTr+5Art6hCBP6mmo1ArosF8StrHxlfHX+IRYJtY
         5W/pYLWBTSSAnLsdBIdLZtg9YTcQ7XwuipkncyhZ9oCIjLAzxsDj3USnYsSTPVpC0RCD
         HNIRbSoKCWUs8rk80aUG6GIqirMbTf0dhc5fBbmY3EjRsR2sBHix6/mmMN3AS4xr5zH2
         VyKezCG4ew2nSgxK1e2uAn3T8B2um0bjjQAf6JVt1MArmtyrbOmJlglPktEuVMrhMWe6
         dq8FGXt/e1cIpnIOmJ1lrqzbB/WYnVoR4ivrcV5Bcggs+CY+HX0DopISVjyFI4lQ3GLH
         aQwg==
X-Gm-Message-State: AOAM533lod/RBbOivFDqP2066HbiVT3D0vFHLr6Lw1ytAklhmMwhRhsN
        G22hERupnvovkV8cG9xgxf4ivDFMcMZ67VJzsS8oHDJmejBFZE02Wqau80mD+TwLnFxltH74Uro
        Y4y8k98B+XFT1/ksd
X-Received: by 2002:a37:4d13:: with SMTP id a19mr7604501qkb.456.1598366525948;
        Tue, 25 Aug 2020 07:42:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6JqBcCZsWXYyvcmaeETW8DHBr1KnBqsO9L4MFzqfTnOnoaLsPJskqCpzvHf6djk6yAKGTSQ==
X-Received: by 2002:a37:4d13:: with SMTP id a19mr7604480qkb.456.1598366525669;
        Tue, 25 Aug 2020 07:42:05 -0700 (PDT)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-11-70-53-122-15.dsl.bell.ca. [70.53.122.15])
        by smtp.gmail.com with ESMTPSA id q34sm14160230qtk.32.2020.08.25.07.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 07:42:04 -0700 (PDT)
Date:   Tue, 25 Aug 2020 10:42:03 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Alistair Popple <alistair@popple.id.au>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/rmap: Fixup copying of soft dirty and uffd ptes
Message-ID: <20200825144203.GA8235@xz-x1>
References: <20200825064232.10023-1-alistair@popple.id.au>
 <20200825064232.10023-2-alistair@popple.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200825064232.10023-2-alistair@popple.id.au>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 04:42:32PM +1000, Alistair Popple wrote:
> During memory migration a pte is temporarily replaced with a migration
> swap pte. Some pte bits from the existing mapping such as the soft-dirty
> and uffd write-protect bits are preserved by copying these to the
> temporary migration swap pte.
> 
> However these bits are not stored at the same location for swap and
> non-swap ptes. Therefore testing these bits requires using the
> appropriate helper function for the given pte type.
> 
> Unfortunately several code locations were found where the wrong helper
> function is being used to test soft_dirty and uffd_wp bits which leads
> to them getting incorrectly set or cleared during page-migration.
> 
> Fix these by using the correct tests based on pte type.
> 
> Fixes: a5430dda8a3a ("mm/migrate: support un-addressable ZONE_DEVICE page in migration")
> Fixes: 8c3328f1f36a ("mm/migrate: migrate_vma() unmap page from vma while collecting pages")
> Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
> Signed-off-by: Alistair Popple <alistair@popple.id.au>
> Cc: stable@vger.kernel.org

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

