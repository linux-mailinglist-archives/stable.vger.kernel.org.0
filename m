Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB45939EA4C
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 01:45:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhFGXrA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 19:47:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhFGXq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 19:46:59 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF46C061787
        for <stable@vger.kernel.org>; Mon,  7 Jun 2021 16:44:51 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id q6so9870531qvb.2
        for <stable@vger.kernel.org>; Mon, 07 Jun 2021 16:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6XCJpSEDadig6sMG+TdcRvTIObt8/yYhSTOVOPCPdvU=;
        b=VbzBYubaVD4swOTb4rPS7L/p9xMaRhJuFVItELtgYh/ORMf1g5fvVelhNSA48Bh89A
         ZJVGc5N0mxVB5nqlpQkReCPPpCHrW0yUYV4VpEKpwFHVuyOihAx84mzKbflnNLCSZE1W
         rzp4ulkMUi20iRcF6psMlPxSVBmZ6gi67TWvm9p0bFUApzq5nkqtLzT0inK+W7E9M9H4
         5wWUImQ77qqlkwOQ/kcjdZ/bJebSkWWWus8q9qwJjTt/+z05cXbb/nYa3DK5wPmyaBvY
         HZ8VikomV53UDTlFWq0zVWjZrHN/Tvwor1m9O+4+7qcXEr6tirya8ogvTi48m4xtTDLt
         FWbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6XCJpSEDadig6sMG+TdcRvTIObt8/yYhSTOVOPCPdvU=;
        b=l3cpDShIxor7krLm6BPUV6Ent0rp3+7bVbePny/CUMUDCDq/yB76dT0Ac8+gaPpzRg
         lqdzen+kXYvoZYJ27LaU7/UbJpiGzCwnC+JwVDDwlmqUFrGpODr8Zw+ISSyxWaCp1BIb
         LdUERdLBfhR+eOEIbxth6oEJveRb6jrd8iKfy+ciM0VondexgO1MV1KEd2JFXVAAE72k
         U9oBjpODw1vdc4ErhGi7/5rfrJRx8MRNvn1dgtaD2OCEUxXy/i6eNIcEgt13fP0Rg1Sp
         leDCdI58w7d3Q6wgpctoQ4RhVW3lWqubyHYYFk3a0Nozi9j5RbycbctO/QXMLMpReqiX
         E/IA==
X-Gm-Message-State: AOAM532PGO8fM+T/NJp9XieHTkBYWWYdDfZ5pL209peUFUdAVvGKXYJx
        TkWYd3+T8xvrgqGVD3IPEJUEKmxm5JkYvQ==
X-Google-Smtp-Source: ABdhPJzZ7oHyaAgt7NfSCX9DX96GkWdRACUbNIvX+6PkpVmenL2OTjkGxU4L0pCUImVKNUN/0Ug2cw==
X-Received: by 2002:ad4:4783:: with SMTP id z3mr20454991qvy.43.1623109490775;
        Mon, 07 Jun 2021 16:44:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-113-94.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.113.94])
        by smtp.gmail.com with ESMTPSA id w3sm10991844qkb.13.2021.06.07.16.44.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 16:44:50 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lqOvJ-003WaD-9Z; Mon, 07 Jun 2021 20:44:49 -0300
Date:   Mon, 7 Jun 2021 20:44:49 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Pavel Skripkin <paskripkin@gmail.com>, dledford@redhat.com,
        shayd@nvidia.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] infiniband: core: fix memory leak
Message-ID: <20210607234449.GP1096940@ziepe.ca>
References: <20210605202051.14783-1-paskripkin@gmail.com>
 <YLxbbwcSli9bCec6@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLxbbwcSli9bCec6@unreal>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 06, 2021 at 08:21:51AM +0300, Leon Romanovsky wrote:
 
> I think that better fix is:
> https://lore.kernel.org/linux-rdma/f72e27d5c82cd9beec7670141afa62786836c569.1622956637.git.leonro@nvidia.com/T/#u

Can you resend that with the bug report in the comment?
 
What is the issue? Some error path missed a restrack_del? which one?

And I still dislike that patch for adding restrack_del and undoing the
previous patch which was trying to get rid of it, but if it actually
fixes a bug...

Jason
