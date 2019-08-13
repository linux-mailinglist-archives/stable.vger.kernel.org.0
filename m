Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4918B412
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 11:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727811AbfHMJ1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 05:27:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39514 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfHMJ1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 05:27:32 -0400
Received: by mail-wm1-f66.google.com with SMTP id i63so827763wmg.4
        for <stable@vger.kernel.org>; Tue, 13 Aug 2019 02:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=android.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Qb/NP/52zEK5PNxPMnXLw+XaNrKng1Uv0nlxkfu6WDI=;
        b=jCWRzcaGkDKOkrHs54r/2Iwg1e7W2380CPMiJi3sIolpj8Szd6M59k2esnkxI+sR01
         sHe23sej4qoNNPAW/Cns0W2WXN+7lgQz5L5NKNKd/tFlsxNmcSs5k9mUwDsBDhzpDpn8
         lkpbdtZ80wmpdVvEXANg/rvduif+7iGEl7oXeKjMmQ1hc6m2dUNb+fsM51r87O06q0Dv
         YLaubrEXEMPNYregryyPwutcqOY2OupwHEIjpWNgASYukqLiriFti7GNwVT2bN1TUw3X
         mlBXGvRO4pwB2qkmvGqapzD4ikfsJDO+T1d+34kKmf3tSuIO60qx+rH1D1gr2nC4DdTQ
         sbew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Qb/NP/52zEK5PNxPMnXLw+XaNrKng1Uv0nlxkfu6WDI=;
        b=a3a0HUd4Q+z90CgT3Lnztr+XZen1Akh059kLpdNk+diVVJ4ememtY+XtjVwAR9i6rv
         A7QGDLzIAt8eRGWyMorqRD+/dOF5wH+/BL8AM1xN4uhlhgpiiV17hSBfH74hgsEvJ/lm
         NzjZ32EJDLnpAWdsLXNHRmwYA77ymSkfL8Vphher4PeoSYFdF+S1RDBuLWqelH3WEBcd
         AIJEfzMPeLPCn7CQyXEF7mj1NfojtjTlaBNTdrtUP/DNpyRMPnmZxLxg8WDAGI5z1430
         UTqa1WtcCSHdMXxAw69+rhEPnoXWKusqPpmc8KVRmDPL2tkdDo5uzvMierJzBVshkIvd
         R5Sw==
X-Gm-Message-State: APjAAAV/xNxvxgpS9Z9lj4ep6M8R/0TQfqmy3IvBqG94Eq20W/h14oHR
        IVC/bWyGs+BF6HfnMxhDA9jp8A==
X-Google-Smtp-Source: APXvYqzLotVVunbMioY5PLRWqpTro+w0pf/dFhcJ71pCniUVebL9qaV6BQcV2U40becIcQa9c0ELGw==
X-Received: by 2002:a1c:6641:: with SMTP id a62mr1927540wmc.175.1565688450282;
        Tue, 13 Aug 2019 02:27:30 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:e751:37a0:1e95:e65d])
        by smtp.gmail.com with ESMTPSA id x20sm235928251wrg.10.2019.08.13.02.27.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 02:27:29 -0700 (PDT)
Date:   Tue, 13 Aug 2019 10:27:28 +0100
From:   Alessio Balsini <balsini@android.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "hange-folder>?" <toggle-mailboxes@google.com>
Subject: Re: [PATCH 4.9.y 4.14.y] IB/mlx5: Fix leaking stack memory to
 userspace
Message-ID: <20190812160714.GA246269@google.com>
References: <20190812105136.151840-1-balsini@android.com>
 <20190812105503.153253-1-balsini@android.com>
 <20190812142316.GA12869@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812142316.GA12869@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Oops, you are totally right, I was still looking at the latest
mlx5_ib_create_qp_resp struct while backporting these patches :)

Sorry for that,
Alessio

On Mon, Aug 12, 2019 at 04:23:16PM +0200, Greg KH wrote:
> On Mon, Aug 12, 2019 at 11:55:03AM +0100, Alessio Balsini wrote:
> > From: Jason Gunthorpe <jgg@mellanox.com>
> > 
> > commit 0625b4ba1a5d4703c7fb01c497bd6c156908af00 upstream.
> > 
> > mlx5_ib_create_qp_resp was never initialized and only the first 4 bytes
> > were written.
> > 
> > Fixes: 41d902cb7c32 ("RDMA/mlx5: Fix definition of mlx5_ib_create_qp_resp")
> 
> This commit only showed up in the following kernel releases:
> 	4.17 4.18.7 4.19
> 
> so why is this "fix" commit needed in anything older than 4.17?
> 
> That's why I did not backport it to older kernels, as I do not think it
> is needed there.  Do you?
> 
> thanks,
> 
> greg k-h
