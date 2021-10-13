Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907A242C0A6
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 14:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhJMM5O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 08:57:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40943 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231312AbhJMM5N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 08:57:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634129710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bua+UvhRZx/vtJpW/R79wAmjzbaBOR2FatQ2gYmLKAk=;
        b=imCDhWuWI5hr9wxKRNm+RZyDWnJUNKV39xwKQtw3TkcLGfdCvLzMrnapy3qlT/MV0lN9Yo
        GgkZNr7ehYSNFnKhhWxJ6MthVECACrBxnnuYBMn1i7mTJAuQS8x8m5ZhQYvDXohyqkh67p
        juX97odvt37mrfN0/KE6gNs1Fgz+Z8g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-OiovFOeuPE6VR02dBUklpw-1; Wed, 13 Oct 2021 08:55:09 -0400
X-MC-Unique: OiovFOeuPE6VR02dBUklpw-1
Received: by mail-wr1-f69.google.com with SMTP id f1-20020a5d64c1000000b001611832aefeso1884984wri.17
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 05:55:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bua+UvhRZx/vtJpW/R79wAmjzbaBOR2FatQ2gYmLKAk=;
        b=fPBiq2U6Kn3SjD0o3YAo2sgitaxgY8Kv+2k4fF1kE5iGCWT/SO+RYObchZhkcWb7hq
         7PAM6EPwtOd2rj945WPy01iV4FzN6QpZZc1K93TyHjDtFKSQm8dYKxkypWrpiu5L88re
         zMURZjaeBwUp7cQ3STY5CMu4oRCvw41Nh1xRfj8sqNwU9BekfX5ZXhNNqtfZmiDV9ZTX
         5JFPc9ftFnf18OWzxGPDGs/CvtJb1gYtZeAsFAmY821ffRFocHsXg/7kyG+9G0GNjjEL
         H3ffVgFqIY7RCClrP3+JmeAMR97vFwooCZG/Vsp7v/lemm6Nsq/6FDgF2VmUGUtiQaIV
         OS6Q==
X-Gm-Message-State: AOAM533dKttXOYE6HfPdr//VMkSbNiW2XsSCrhVhj+p+ftSuruWQHFr1
        Sqv/jT/33M3wAEYY+XV1fPy69mrxsxH9pcq4JiWTqA83OfqL6keAexvsVgNxjrpCDn07i0Hqrgl
        +EYAT61BShxgwQoLA
X-Received: by 2002:a1c:22d7:: with SMTP id i206mr13001179wmi.122.1634129708021;
        Wed, 13 Oct 2021 05:55:08 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzUlSBIGEPmkknnlsQTkGPbs0LAOHhsvCUmorYQR19foafC7W/ikoT3XdyrV6wuhDzoeZLiZw==
X-Received: by 2002:a1c:22d7:: with SMTP id i206mr13001158wmi.122.1634129707894;
        Wed, 13 Oct 2021 05:55:07 -0700 (PDT)
Received: from redhat.com ([2.55.30.112])
        by smtp.gmail.com with ESMTPSA id g12sm5445986wme.3.2021.10.13.05.55.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 05:55:07 -0700 (PDT)
Date:   Wed, 13 Oct 2021 08:55:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        markver@us.ibm.com, linux-s390@vger.kernel.org,
        stefanha@redhat.com, Raphael Norwitz <raphael.norwitz@nutanix.com>,
        qemu-devel@nongnu.org
Subject: Re: [PATCH v3 1/1] virtio: write back F_VERSION_1 before validate
Message-ID: <20211013085423-mutt-send-email-mst@kernel.org>
References: <20211011053921.1198936-1-pasic@linux.ibm.com>
 <20211013060923-mutt-send-email-mst@kernel.org>
 <96561e29-e0d6-9a4d-3657-999bad59914e@de.ibm.com>
 <20211013081836-mutt-send-email-mst@kernel.org>
 <87zgrdulwp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zgrdulwp.fsf@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 13, 2021 at 02:52:38PM +0200, Cornelia Huck wrote:
> On Wed, Oct 13 2021, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Wed, Oct 13, 2021 at 01:23:50PM +0200, Christian Borntraeger wrote:
> >> Can we get this kernel patch queued for 5.15 and stable without waiting for the QEMU patch
> >> as we have a regression with 4.14?
> >
> > Probably. Still trying to decide between this and plain revert for 5.15
> > and back. Maybe both?
> 
> Probably better queue this one, in case we have some undiscovered
> problems with the config space access in virtio-net?

So both then. I think you are right. Pushed out to -next. Will do a pull
towards end of the week.

-- 
MST

