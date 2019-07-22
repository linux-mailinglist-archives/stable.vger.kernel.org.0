Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29D47081D
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 20:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfGVSHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 14:07:50 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:46361 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbfGVSHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 14:07:49 -0400
Received: by mail-vs1-f68.google.com with SMTP id r3so26818555vsr.13
        for <stable@vger.kernel.org>; Mon, 22 Jul 2019 11:07:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cmW+iIJBcAPXYuBJ0X70RuJw3nKWx6Ck24ISTbz4CEs=;
        b=ecr7HpkJ/GPjpuVFLx7tTl5nq1d1iUDbKwdlnIYeT6V8ma1d+wg9/MJjuQwtyKqzih
         QeHMj6zOIBFJhbLoTvcDZGPbJSferveTR0mu/KI/setje9er6O5qXDyom3wHCufV7/Pi
         3UQymcesV8YMc+MJ0dOZcKfviFC5gRKW1JnakN5ef7VDFeCkicby89KgbFRCg0yaM4C/
         o1j3+ySz3Lkbzfti+4RHITgEG9bqsPDppPOfcTvMhnuz7JyPwElNZSI371i7FV0IYolf
         mofl8nmvAiy33e4bbe8MvQ3PZsA+U642zpBMIy3r5E++TuInZ8ltgdP0Mgt+Rbzndl5u
         Ff1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=cmW+iIJBcAPXYuBJ0X70RuJw3nKWx6Ck24ISTbz4CEs=;
        b=gzoUiy62qrT5PTMey4DMD5+pwCra3rRVoMaD5oylJSJY/w56OikoeuA6+q24d3rmsP
         3l8yPFwkErK+/eZYfDNN8IX20hVEvPHtDiKuAxeeWyD1ULLcEQMfsKChGvQj5owJZG6E
         Wo/WGyOA1d+ShIslO+S2GxBa251X55iWNx2ufBNm9SnPeuYFVSG3mwh1GJS/QIDRKEue
         +yohZjZyguoFcWGapQ7fx9C/k52CrGOnMDvLQRM8OFA0LJNIEDMdyrHvtokfFlaO2rGJ
         E5xIE6UE6iKyNLwzjISFhsRDQ9zQj3RarNP10oRH3WeDgqVxTMLAnt9v7GnzumoeSP+3
         XvKg==
X-Gm-Message-State: APjAAAXrFptWXnzUbfuN7t0bb6gt4AR4x7+a/Q1aVJQ/s3D0PnnFu4AY
        JwHz0o2O39ZlRlRxo5cqSgu8uA==
X-Google-Smtp-Source: APXvYqx5Od80W34I1fDAgrOP6mzw1I8zF4ZN9uUihErCnhuyEo+zpkg3qx27zyPVZSVitQtTLpxDGg==
X-Received: by 2002:a67:eb93:: with SMTP id e19mr44004699vso.208.1563818868687;
        Mon, 22 Jul 2019 11:07:48 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id u8sm15170119vke.34.2019.07.22.11.07.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Jul 2019 11:07:48 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hpciw-0002TP-Hf; Mon, 22 Jul 2019 15:07:46 -0300
Date:   Mon, 22 Jul 2019 15:07:46 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Selvin Xavier <selvin.xavier@broadcom.com>
Cc:     linux-rdma@vger.kernel.org, dledford@redhat.com,
        linux-nvme@lists.infradead.org, stable@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>
Subject: Re: [PATCH for-rc] RDMA/bnxt_re: Honor vlan_id in GID entry
 comparison
Message-ID: <20190722180746.GA9441@ziepe.ca>
References: <20190715091913.15726-1-selvin.xavier@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715091913.15726-1-selvin.xavier@broadcom.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 15, 2019 at 05:19:13AM -0400, Selvin Xavier wrote:
> GID entry consist of GID, vlan, netdev and smac.
> Extend GID duplicate check companions to consider vlan_id as well
> to support IPv6 VLAN based link local addresses. Introduce
> a new structure (bnxt_qplib_gid_info) to hold gid and vlan_id information.
> 
> The issue is discussed in the following thread
> https://www.spinics.net/lists/linux-rdma/msg81594.html
> 
> Fixes: 823b23da7113 ("IB/core: Allow vlan link local address based RoCE GIDs")
> Cc: <stable@vger.kernel.org> # v5.2+
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Co-developed-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
> Tested-by: Yi Zhang <yi.zhang@redhat.com>
> Reviewed-By: Leon R...
> Tested-by: Leon R...
> ---
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c  |  7 +++++--
>  drivers/infiniband/hw/bnxt_re/qplib_res.c | 13 +++++++++----
>  drivers/infiniband/hw/bnxt_re/qplib_res.h |  2 +-
>  drivers/infiniband/hw/bnxt_re/qplib_sp.c  | 14 +++++++++-----
>  drivers/infiniband/hw/bnxt_re/qplib_sp.h  |  7 ++++++-
>  5 files changed, 30 insertions(+), 13 deletions(-)

Applied to for-rc, thanks

Please also fix that sketchy use of the gid_index

Jason
