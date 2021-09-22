Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85393414BF4
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 16:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbhIVOcb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 10:32:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232401AbhIVOca (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 10:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632321060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H9MFwjIYK3NzURsIL5ZeXXjauXt11emCz529o4qozFY=;
        b=EuG47Y/ikTAr49j+3zjGmNyrj3KUAI8/JWlB335KkQp9hRfVqGbYhPK6OmXF8PWA9+rh/A
        ig3qCKKCY3JEYQPsCEMI/YMZTo1gJtMOPTD0uaJQB2rBWcmZ2d1s50vikn/mIe1wZiWK9s
        QMtosJdAZYTW1EJoqN2QrWveLNiz1Yk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-dcRGBCA9Mlm5RHyhWH8zVQ-1; Wed, 22 Sep 2021 10:30:56 -0400
X-MC-Unique: dcRGBCA9Mlm5RHyhWH8zVQ-1
Received: by mail-qv1-f71.google.com with SMTP id a15-20020a0ce34f000000b0037a944f655dso12732563qvm.5
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 07:30:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H9MFwjIYK3NzURsIL5ZeXXjauXt11emCz529o4qozFY=;
        b=2wzfIUPlDk5O1rvqlXfL2HHvWYuL9QcAXWRW0lVGRYQj6qy4YARYNmr90xQoHMqVLb
         rHSJ0mog0RHPTQKQFyhca/nvN4pBdYQ0Ay4e25Zi/3zpRf5ITKixYeypB/pOQbEiGPNR
         JZvhIcMJE673E9v/tpPMpvKj+8nc7sF/bUNJvrpmzFVxo56NOgcAicmG4fGdFA2UPQJA
         UZxJWOqgd+R+vgCpI7JWAq+i3VLs3UJ3dPK9fP+89u9u5U1CJmgSXtHQbNFKjQfPQZeR
         ptgTvsjBCGCWaiZGPOaWoYF63alp8IIt8qg8g4kMFAxQYtWJiMJihe0lxkePv2CM6NI+
         uUPg==
X-Gm-Message-State: AOAM533PXh5W9oOesMUTwXg2AMzWi8Zpx6oAPtgrtH7G/at6x3hc+d2+
        WzDZuZPh8TS/XQV8tedkXnr9imd29lUObeu5bjltCmWCbhL+/G7oF+6H7CJe6aqth5XDGkQvFPc
        KJH+2R32pFELI35Z7
X-Received: by 2002:ac8:1c6:: with SMTP id b6mr32958206qtg.221.1632321056079;
        Wed, 22 Sep 2021 07:30:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyQAVBr6hBwwFSYKO7U1/khHUr5y9tSTMCIoPdoZ894eUZ+OrVYZ3xfOPFjOhJbFSSfttPIFg==
X-Received: by 2002:ac8:1c6:: with SMTP id b6mr32958174qtg.221.1632321055765;
        Wed, 22 Sep 2021 07:30:55 -0700 (PDT)
Received: from t490s ([2607:fea8:56a2:9100::d3ec])
        by smtp.gmail.com with ESMTPSA id f83sm1917615qke.79.2021.09.22.07.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 07:30:55 -0700 (PDT)
Date:   Wed, 22 Sep 2021 10:30:53 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: fix a race between writeprotect and
 exit_mmap()
Message-ID: <YUs+HZOf6mnI6mm2@t490s>
References: <20210921200247.25749-1-namit@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210921200247.25749-1-namit@vmware.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 01:02:47PM -0700, Nadav Amit wrote:
> From: Nadav Amit <namit@vmware.com>
> 
> A race is possible when a process exits, its VMAs are removed
> by exit_mmap() and at the same time userfaultfd_writeprotect() is
> called.
> 
> The race was detected by KASAN on a development kernel, but it appears
> to be possible on vanilla kernels as well.
> 
> Use mmget_not_zero() to prevent the race as done in other userfaultfd
> operations.
> 
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Andrea Arcangeli <aarcange@redhat.com>
> Cc: stable@vger.kernel.org
> Fixes: 63b2d4174c4ad ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Signed-off-by: Nadav Amit <namit@vmware.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

Thanks!

-- 
Peter Xu

