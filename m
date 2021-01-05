Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551CA2EA581
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 07:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbhAEGjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 01:39:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbhAEGjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jan 2021 01:39:05 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FC7C061574
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 22:38:24 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id be12so15848763plb.4
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 22:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :mime-version;
        bh=3sjuTKIficA6uJfUjyIxt+DwJMX1GvcA2AN2cEABIEk=;
        b=PbsrgUS29EJUbYU31T+aGulT6TqIxDIVTG6QKq/9TPDiggLumFl6Fj56SnqQfCU8PG
         5s3O4Ck3oFw3wEN61/LrPHEwuBKpoQlbtRTEAL9Mhk6sh/veRfW1cvCQNV+JFDBbW6Le
         qbP+gMmpX85kWcghlG6x/JPlTws9qjLEy0eYH226CBtYE2eZc5ikLYPrPbweavsH8x9l
         UHdjO9LAwu+gxofbIC+T8bvX7fDDf83G5jvVbScPvPjI2PBzUDN6A8n7oH4BUMHlNUoy
         oIlV85ogLsgsyHFQLWyyhQhmalAnDYmD8pxnQyDoGnpEHY3wBCASZE7MoSV7LWs90Fq7
         hyaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:mime-version;
        bh=3sjuTKIficA6uJfUjyIxt+DwJMX1GvcA2AN2cEABIEk=;
        b=ZRWeM3XM+PDPJYnrmwnCSaEZDUs6UcMhDELvZWUqucRX9GSKyboxsYcoqUdUIQjoY4
         ucNan8fOY1rNHtCFcnnSe54RZCV6+fEb1qhbXoMFWoiJLnDlhTP4SGeZXNFtGHXo8QeM
         Mw/hn1gRN1qt98TdAUhbI1miGh6lmKumCFL4QdUV7FydOYaALE52yVhL5mD3dyUleUIp
         Ix90xs8ocSExAGGPMoL2SsWtYmSpLba3vpxdAofZZgwPA7AEfCuGXau7PM2a4JU5T2k3
         mRj7EBnqPcwGTUZJVdHViRKo4uRiXptEJVJv+3mrUQE2bUWyyN+PQdSqTiTjIZwzoG4a
         i/gQ==
X-Gm-Message-State: AOAM5333P9vTptOsJAI0787EjwfVkJ4Uy859pxLSYaAwDsLYzAV/0CrI
        lrf83HcOnXSmmMQREPTkfaA+pg==
X-Google-Smtp-Source: ABdhPJyG1tMAnc1bkEtsB3ybISNKVgP9c/q+Eya6DW0aTW2miabNLUMapotRlDYuPZkPqVDJqodhKQ==
X-Received: by 2002:a17:902:7291:b029:dc:c69:e985 with SMTP id d17-20020a1709027291b02900dc0c69e985mr52893964pll.33.1609828704185;
        Mon, 04 Jan 2021 22:38:24 -0800 (PST)
Received: from [2620:15c:17:3:4a0f:cfff:fe51:6667] ([2620:15c:17:3:4a0f:cfff:fe51:6667])
        by smtp.gmail.com with ESMTPSA id c199sm59003852pfb.108.2021.01.04.22.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 22:38:23 -0800 (PST)
Date:   Mon, 4 Jan 2021 22:38:22 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Greg KH <greg@kroah.com>
cc:     Peter Gonda <pgonda@google.com>, stable@vger.kernel.org,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Christoph Hellwig <hch@lst.de>, nsaenzjulienne@suse.de,
        geert@linux-m68k.org, sjhuang@iluvatar.ai
Subject: Re: [PATCH 00/30 for 5.4] Backport unencrypted non-blocking DMA
 allocations
In-Reply-To: <X/QAGHyUfBcsIChZ@kroah.com>
Message-ID: <1da58ef-5995-a928-9b14-f0c064ea64fe@google.com>
References: <20200925161916.204667-1-pgonda@google.com> <20201005130729.GD827657@kroah.com> <CAMkAt6qgbO4CqQVxLKU_Tf6bN3numdJHdkc-rck26V68+Y1j9Q@mail.gmail.com> <alpine.DEB.2.23.453.2010061100120.51232@chino.kir.corp.google.com> <X/MRdPz/POas6FFf@kroah.com>
 <ef6fed57-cbb7-ed8b-6925-cea0fd55df85@google.com> <X/QAGHyUfBcsIChZ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Jan 2021, Greg KH wrote:

> > I think it can be considered a bug fix.
> > 
> > Today, if you boot an SEV encrypted guest running 5.4 and it requires 
> > atomic DMA allocations, you'll get the "sleeping function called from 
> > invalid context" bugs.  We see this in our Cloud because there is a 
> > reliance on atomic allocations through the DMA API by the NVMe driver.  
> > Likely nobody else has triggered this because they don't have such driver 
> > dependencies.
> > 
> > No previous kernel version worked properly since SEV guest support was 
> > introduced in 4.14.
> 
> So since this has never worked, it is not a regression that is being
> fixed, but rather, a "new feature".  And because of that, if you want it
> to work properly, please use a new kernel that has all of these major
> changes in it.
> 

Hmm, maybe :)  AMD shipped guest support in 4.14 and host support in 4.16 
for the SEV feature.  In turns out that a subset of drivers (for Google, 
NVMe) would run into scheduling while atomic bugs because they do 
GFP_ATOMIC allocations through the DMA API and that uses 
set_memory_decrypted() for SEV which can block.  I'd argue that's a bug in 
the SEV feature for a subset of configs.

So this never worked correctly for a subset of drivers until I added 
atomic DMA pools in 5.7, which was the preferred way of fixing it.  But 
SEV as a feature works for everybody not using this subset of drivers.  I 
wouldn't say that the fix is a "new feature" because it's the means by 
which we provide unencrypted DMA memory for atomic allocators that can't 
make the transition from encrypted to unecrypted during allocation because 
of their context; it specifically addresses the bug.

> What distro that is based on 5.4 that follows the upstream stable trees
> have not already included these patches in their releases?  And what
> prevents them from using a newer kernel release entirely for this new
> feature their customers are requesting?
> 

I'll defer this to Peter who would have a far better understanding of the 
base kernel versions that our customers use with SEV.

Thanks
