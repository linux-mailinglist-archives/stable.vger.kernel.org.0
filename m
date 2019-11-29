Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 126D310DA6C
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 21:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfK2UHi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Nov 2019 15:07:38 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51881 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfK2UHi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Nov 2019 15:07:38 -0500
Received: by mail-wm1-f65.google.com with SMTP id g206so15322171wme.1
        for <stable@vger.kernel.org>; Fri, 29 Nov 2019 12:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fGUxfHWifQKWfd7lhEhXsro+4xySkC5/5k8k7RLW60s=;
        b=XJoWJ10+eDXtobkg01prbR7FDcbY+AQMM3Pg0Xh2IR59KB9ytIvzZgBIsG0g2v6Adc
         iXxY2C7J65E78R3b6gwSbg2GuaagdfE7yt1cBLmsRv384pbbFv+XClJCNOyPmjLKaNg2
         rSOeS53iiudcRZ2j5r3KGWX7+ocgbegBDOlrs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fGUxfHWifQKWfd7lhEhXsro+4xySkC5/5k8k7RLW60s=;
        b=QcLnnnM5AlrFXk1SXY+y35l/UR5G89qs2a5aH9Ow96Fv1T4I3vwVKvgEqQBnvD3egD
         MUkWVOlVFUOEbGMs0JzH9SU1b7ovtpiH5Tz1+be6VD3HEScgjrb9LhnIaJa27gHQ1DyO
         aiKV0TiEdzSWa+PBn5XuKP8wF73rYmJvXwpS4vXLfDNlkj28eb/k27UAmiEsaDUsinAh
         fX5yxm/XcMlOFjGuU0Q04Z9l2WWYiq8vFq9DPwEeXCPo5WMjOdulpZFx9h70U1bHmhx3
         zg1NpZ4NGX/sSQ4ylxPoUsmHixEY0UIDmEfgY6lbEgRhK7E5oNagipnzx9OQnbVC3fe0
         hV4w==
X-Gm-Message-State: APjAAAX5rq5zRytAgoUSzWkeeZiAUI45V6bfSmehAdWUpI5Q8ONyF0mk
        PjoPbXJgX3cLdDDMWXkLP7aKMg==
X-Google-Smtp-Source: APXvYqyPjdGpaQpUCdcjZzbGPsNTm4l1FlBP5fcGPk8zEHVqlZE9Xs9bKG3w5NTMN6h3qnct69yvsQ==
X-Received: by 2002:a1c:a906:: with SMTP id s6mr16931349wme.125.1575058056177;
        Fri, 29 Nov 2019 12:07:36 -0800 (PST)
Received: from phenom.ffwll.local (212-51-149-96.fiber7.init7.net. [212.51.149.96])
        by smtp.gmail.com with ESMTPSA id k8sm6431399wrl.3.2019.11.29.12.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 12:07:35 -0800 (PST)
Date:   Fri, 29 Nov 2019 21:07:33 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Steven Price <steven.price@arm.com>
Cc:     Boris Brezillon <boris.brezillon@collabora.com>,
        Rob Herring <robh+dt@kernel.org>,
        dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Alyssa Rosenzweig <alyssa.rosenzweig@collabora.com>
Subject: Re: [PATCH 2/8] drm/panfrost: Fix a race in panfrost_ioctl_madvise()
Message-ID: <20191129200733.GQ624164@phenom.ffwll.local>
References: <20191129135908.2439529-1-boris.brezillon@collabora.com>
 <20191129135908.2439529-3-boris.brezillon@collabora.com>
 <dd8a946c-5666-a7b8-f7bc-06647e0d0bbc@arm.com>
 <20191129153310.2f9c80e1@collabora.com>
 <b159591d-1dd4-1ac7-e924-c02be1d8b1f3@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b159591d-1dd4-1ac7-e924-c02be1d8b1f3@arm.com>
X-Operating-System: Linux phenom 5.3.0-2-amd64 
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 29, 2019 at 02:40:34PM +0000, Steven Price wrote:
> On 29/11/2019 14:33, Boris Brezillon wrote:
> > On Fri, 29 Nov 2019 14:24:48 +0000
> > Steven Price <steven.price@arm.com> wrote:
> > 
> >> On 29/11/2019 13:59, Boris Brezillon wrote:
> >>> If 2 threads change the MADVISE property of the same BO in parallel we
> >>> might end up with an shmem->madv value that's inconsistent with the
> >>> presence of the BO in the shrinker list.  
> >>
> >> I'm a bit worried from the point of view of user space sanity that you
> >> observed this - but clearly the kernel should be robust!
> > 
> > It's not something I observed, just found the race by inspecting the
> > code, and I thought it was worth fixing it.
> 
> Good! ;) Your cover letter referring to a "debug session" made me think
> you'd actually hit all these.

Time for some igt to make sure this is actually correct?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
