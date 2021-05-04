Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B5D373154
	for <lists+stable@lfdr.de>; Tue,  4 May 2021 22:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhEDUXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 May 2021 16:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbhEDUXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 May 2021 16:23:22 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87051C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 13:22:26 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id l13so9139159wru.11
        for <stable@vger.kernel.org>; Tue, 04 May 2021 13:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ycjh+7wRTaiVvAynWJZsr6dZ1wdemd+2LmeWqLGp5WM=;
        b=YjGZH4+zr9RvVar3D2mZdMTRE11KxqBHjAqEVFYqLyGtdm9ttVRaPEPaNNqmVQHZ0U
         XV6G3OPl/UsM9umDZnmIIR2mDhpHcwtf6uFfMa+HCqO5myZM2EgPvKKil4CFBQsVneKt
         f0Nqh9lxC8iplh/7edTI6X0ZJAWIGOnkmnBuePuxsGi5rGhzC20wXiTgS8j3T/msVXEG
         iXgMh0UJaf/yObBVc5bbaNK10C2C3GHoRoK+MvApXNT6rOzSaDw2M+qB20dV1uu/qHKp
         0UzyMRU7zSfGT4WM4Wp7RgF2gQjU8fHtqCrLc/s7JsMafaKLdhikfVF3wWgI+BqQ6AjU
         N8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ycjh+7wRTaiVvAynWJZsr6dZ1wdemd+2LmeWqLGp5WM=;
        b=s8l94MHkWLbYZujheJ+YvODLui7fJJMa0B3GRgyy1hgKeLtMWiY3tO1e89unOFmHRj
         OjKv7QplMdEbvk/ew+7thE+2kmdEyqOmT1FFhDz7jaO8Wb4Tf9ao/GnZb65gbStEQ5tP
         XnKlGVp15OWL+qbXqyVjoUP3DGlpVh9bqwaCnsB7o2m8OS33it0nrWXOKpImgDoSeqqy
         wQ9tM4r15GkTh3vp7bbEjscceg3FIDfhJrvu+Dvy1Hsi0xJ71uC8Gfe93TCnbCtSVDa0
         jnJ6gmdKYHesU+YEy6TTNKo8V3MA13QRRkg75Z9DlDZ/D8o7sPr3WaMkzZ//Q1WqHuMP
         kctg==
X-Gm-Message-State: AOAM532cNu0RomgJV+g55C3EVTASkw7bidr6FkeVnrFfuJS3XtvBBhHS
        pzJuJla0SocuAAIQ3dUWCWo02PhUNgSWwhE8zhHqZw==
X-Google-Smtp-Source: ABdhPJwxFivHlZ+c+3LKZHouoeYyyQj/AsvTKMoxWfSx4YzXm/2C4jDp8HmDNnE363wUEBixKHeYA9GnnL50gWtNzMo=
X-Received: by 2002:a5d:5052:: with SMTP id h18mr33235730wrt.365.1620159745051;
 Tue, 04 May 2021 13:22:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210429173315.1252465-1-jxgao@google.com>
In-Reply-To: <20210429173315.1252465-1-jxgao@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Tue, 4 May 2021 13:22:14 -0700
Message-ID: <CAA03e5F5iVA2VYyN7=+XmXA1gHDiOhGNAOYrM3F9KBBfEJ1s7A@mail.gmail.com>
Subject: Re: [PATCH v2 5.10 0/9] preserve DMA offsets when using swiotlb
To:     Jianxiong Gao <jxgao@google.com>
Cc:     stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        sashal@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 29, 2021 at 10:34 AM Jianxiong Gao <jxgao@google.com> wrote:
>
> We observed several NVMe failures when running with SWIOTLB. The root
> cause of the issue is that when data is mapped via SWIOTLB, the address
> offset is not preserved. Several device drivers including the NVMe
> driver relies on this offset to function correctly.
>
> Even though we discovered the error when running using AMD SEV, we have
> reproduced the same error in Rhel 8 without SEV. By adding swiotlb=force
> option to the boot command line parameter, NVMe funcionality is
> impacted. For example formatting a disk into xfs format returns an
> error.

Christoph, are you OK with backporting this patch set to LTS, based on
the rationale in the cover letter above?
Thanks,
Marc
