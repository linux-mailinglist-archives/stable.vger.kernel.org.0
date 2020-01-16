Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE26C13D47C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 07:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgAPGoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 01:44:46 -0500
Received: from mail-pj1-f50.google.com ([209.85.216.50]:51404 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgAPGop (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jan 2020 01:44:45 -0500
Received: by mail-pj1-f50.google.com with SMTP id d15so1075216pjw.1
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 22:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ho/ewm07CGJce0VRV5f1Zp9BvvqWMhIZJJysfPQahVA=;
        b=K/HzM2GiA0OOMmCA86f6+S1PG6jEbmFcjSQU5PoU5RS2kpfM5AEwb/lAW9iHTFjZtI
         tFrDyiPG39384UyZfv8NdL9BzwJ+bHxaElW1hbEW1siW/O3jI5cPhH0eMLDvg7eY4nIU
         CPJ+IvFnhZsIr8oPuz/kMU9RmTTrmns+7MtXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ho/ewm07CGJce0VRV5f1Zp9BvvqWMhIZJJysfPQahVA=;
        b=HTt4m4Lzv9pNDydk1l0NpTESxaGS7qbrx4Kmm+abeWXX/gUVAdwYWsphLXDQmHelrQ
         GmWW+vY7mN+0J6HvNFEmd/cxVrjspbO26WAD9HmV4sIIVUDc8hPkzQ8MP30TEhx306lp
         kUnoqxRt3uCYZbLU05IstbQHzc1YVdDcSA09ooZLy9p1yUBlgvkp0i+2jqkmY9EtOZsK
         V92BBhTjWn27BK7cQH0jZe5LA/xXTQKPvWq7DYnZpdOxNilKqe4K0WKN57zPbvDbsuz8
         Xk1dP5SApJHScymHt5ZVUleH791KvjREAm5IsclDOUNwED+WtqIW9gerdNwno1TjsEkm
         Wgwg==
X-Gm-Message-State: APjAAAUC8lbc4o98QNuAMece3dqCgemgY3sqx0agDeS5mnOVeOn70X3I
        PhHf3oY52PH47lsMmtIWFHQbtQ==
X-Google-Smtp-Source: APXvYqw8Z4Du11Noj0rJNBAruiDoW3vfFGs7bdrPKqs3+PLN/qL8xRDc8i0m9PFgrYISl/EdHOHFAA==
X-Received: by 2002:a17:902:6ac3:: with SMTP id i3mr30433090plt.111.1579157085077;
        Wed, 15 Jan 2020 22:44:45 -0800 (PST)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id o2sm1935296pjo.26.2020.01.15.22.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 22:44:44 -0800 (PST)
Date:   Wed, 15 Jan 2020 22:44:40 -0800
From:   Zubin Mithra <zsm@chromium.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        christian.koenig@amd.com, michel.daenzer@amd.com,
        Jerry.Zhang@amd.com, ray.huang@amd.com, alexander.deucher@amd.com
Subject: Re: ac1e516d5a4c ("drm/ttm: fix start page for huge page check in
 ttm_put_pages()")
Message-ID: <20200116064439.GA62849@google.com>
References: <20200116035501.GA39586@google.com>
 <20200116062954.GA1172661@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200116062954.GA1172661@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 16, 2020 at 07:29:54AM +0100, Greg KH wrote:
> On Wed, Jan 15, 2020 at 07:55:02PM -0800, Zubin Mithra wrote:
> > Hello,
> > 
> > The patch :
> > a66477b0efe5 ("drm/ttm: fix out-of-bounds read in ttm_put_pages() v2")
> > 
> > has been applied to linux-4.19.y. However, 2 follow-up fixes have not been applied.
> 
> How did you figure out that they were "follow-up" fixes?

CVE-2019-19927 references commits a66477b0efe5, ac1e516d5a4c and
453393369dc9.
The patch author(Christian König) confirmed that if the patches were being backported,
then all three of them need to be.

Thanks,
- Zubin


> 
> > 
> > Could the following two fixes be applied to linux-4.19.y? These commits are present
> > in linux-5.4.y. These patches do not have to be applied to linux-4.14.y.
> > 
> > ac1e516d5a4c ("drm/ttm: fix start page for huge page check in ttm_put_pages()")
> > 453393369dc9 ("drm/ttm: fix incrementing the page pointer for huge pages")
> 
> Both now queued up, thanks for letting me know.
> 
> greg k-h
