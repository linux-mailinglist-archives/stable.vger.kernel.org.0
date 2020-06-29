Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E2C20E51C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgF2Vcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:32:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728668AbgF2SlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:41:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38031233A0;
        Mon, 29 Jun 2020 09:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593421865;
        bh=uQOX+GkrsHDobAGd6ILyyZoNcTVsAss7SxTAoUPHhsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dFZySqfI2H+49SgN7Fe+j5ckSNxhTHIoo1/aoOOBZaAme4xS+z90JQOmm5Fg0YI1v
         j3W0NKEjemCarw1AWIZdmTFzIzpAFVsgp1U1/ly+hN0xVMldogznACBHcNQB8CW8bY
         RrrfZGP1tWBn5MtLsRJiclS2aveKf24YxCoI4Aso=
Date:   Mon, 29 Jun 2020 11:10:56 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Gao Xiang <hsiangkao@aol.com>
Cc:     Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
        Hongyu Jin <hongyu.jin@unisoc.com>,
        Chao Yu <yuchao0@huawei.com>
Subject: Re: [PATCH 4.19.y] erofs: fix partially uninitialized misuse in
 z_erofs_onlinepage_fixup
Message-ID: <20200629091056.GA1359328@kroah.com>
References: <20200625051939.32454-1-hsiangkao.ref@aol.com>
 <20200625051939.32454-1-hsiangkao@aol.com>
 <20200629003309.GA27377@hsiangkao-HP-ZHAN-66-Pro-G1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200629003309.GA27377@hsiangkao-HP-ZHAN-66-Pro-G1>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 29, 2020 at 08:33:13AM +0800, Gao Xiang wrote:
> Hi Greg, Sasha
> 
> On Thu, Jun 25, 2020 at 01:19:39PM +0800, Gao Xiang via Linux-erofs wrote:
> > From: Gao Xiang <hsiangkao@redhat.com>
> > 
> > commit 3c597282887fd55181578996dca52ce697d985a5 upstream.
> > 
> > Hongyu reported "id != index" in z_erofs_onlinepage_fixup() with
> > specific aarch64 environment easily, which wasn't shown before.
> > 
> > After digging into that, I found that high 32 bits of page->private
> > was set to 0xaaaaaaaa rather than 0 (due to z_erofs_onlinepage_init
> > behavior with specific compiler options). Actually we only use low
> > 32 bits to keep the page information since page->private is only 4
> > bytes on most 32-bit platforms. However z_erofs_onlinepage_fixup()
> > uses the upper 32 bits by mistake.
> > 
> > Let's fix it now.
> > 
> > Reported-and-tested-by: Hongyu Jin <hongyu.jin@unisoc.com>
> > Fixes: 3883a79abd02 ("staging: erofs: introduce VLE decompression support")
> > Cc: <stable@vger.kernel.org> # 4.19+
> > Reviewed-by: Chao Yu <yuchao0@huawei.com>
> > Link: https://lore.kernel.org/r/20200618234349.22553-1-hsiangkao@aol.com
> > Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
> > ---
> > This fix has been merged into Linus's tree just now (today).
> > Since the patch could not directly be applied to 4.19, manually handle this.
> 
> Could this patch be applied to all next version stable
> versions (4.19, 5.4 as well as 5.7) after 5.8-rc3 is out...
> 
> It's some important fix on specific compiler options
> and should be fixed ASAP.
> 
> Without this patch, unexpected behaviors would happen
> conditionally and break the filesystem from working.
> Apart from 4.19 patch, both 5.4 and 5.7 patches are
> quite trivial ones (can be cherry-picked directly).
> 
> Could kindly consider this and it's just a little
> heads-up... Sorry for the noise if it's already in queue...

Please let us catch up on patches, there's been a lot of them recently
for some reason...

greg k-h
