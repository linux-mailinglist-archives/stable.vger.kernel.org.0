Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7D353A4AF0
	for <lists+stable@lfdr.de>; Sat, 12 Jun 2021 00:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbhFKWW6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 18:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230319AbhFKWW5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Jun 2021 18:22:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D94E5613CF;
        Fri, 11 Jun 2021 22:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623450059;
        bh=Yafo506JqOKnjsaULTOPOr2BWRI/1R51DD5cfo8K+HA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fJPq4SEiwWvkQrh7LCDVIFQIxtXAzZu3ooEcSq+G95WxgvpuP1C7ufURv1vyu8lOB
         EmsHqG3sevsVQYKRFKzFBQJZHjFiPWgLV5d2AJHDCq6/YucaeLwdwl7duPpJAbm6m1
         5UUR2pYlOS9zAlott15+baeXd8bxou83F8kNvesfnsYHHcpVDgN5dUOb/Fo/rtQ9Ob
         4P4/tgT6pTWVO6Lp+b8abBKNO6TxR2TtMPkhSdyl5LO4QUKJazwewYo7k2WED00QoY
         SFn2mV64YHy1xShTc3JzvhHPi2Q2npRSEyopgpMvVvk0t+NAZ9fbISLRGEVWasByyU
         Uxv15r+MQajxA==
Message-ID: <74f391de84d957a3d726b0bbb00ab81d0d90d521.camel@kernel.org>
Subject: Re: [PATCH] ceph: fix write_begin optimization when write is beyond
 EOF
From:   Jeff Layton <jlayton@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     ceph-devel@vger.kernel.org, linux-cachefs@redhat.com,
        pfmeec@rit.edu, dhowells@redhat.com, idryomov@gmail.com,
        stable@vger.kernel.org, Andrew W Elble <aweits@rit.edu>
Date:   Fri, 11 Jun 2021 18:20:57 -0400
In-Reply-To: <YMPME0Bey8Tzz37l@casper.infradead.org>
References: <20210611195904.160416-1-jlayton@kernel.org>
         <YMPME0Bey8Tzz37l@casper.infradead.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.1 (3.40.1-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2021-06-11 at 21:48 +0100, Matthew Wilcox wrote:
> On Fri, Jun 11, 2021 at 03:59:04PM -0400, Jeff Layton wrote:
> >  		if ((pos_in_page == 0 && len == PAGE_SIZE) ||
> > -		    (pos >= i_size_read(inode)) ||
> > +		    (index > (i_size_read(inode) / PAGE_SIZE)) ||
> 
> I think that wants to be ((i_size_read(inode) - 1) / PAGE_SIZE)
> 
> If your file is 4096 bytes long, that means bytes 0-4095 contain data.
> Except that i_size can be 0, so ...
> 
> 		if ((offset == 0 && len == PAGE_SIZE) || i_size == 0 ||
> 		    (index > (i_size - 1) / PAGE_SIZE) ||
> 		    (offset == 0 && pos + len >= i_size))
>   			zero_user_segments(page, 0, pos_in_page,
>   					   pos_in_page + len, PAGE_SIZE);
> 

Oh, right -- I'll fix that and send a v2. Sorry for the noise!

-- 
Jeff Layton <jlayton@kernel.org>

