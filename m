Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF69154B4F
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 19:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727662AbgBFSli (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 13:41:38 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38550 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgBFSli (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 13:41:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Q08ftOUoyei97FPuiT9NtyQjBazlRzN9kuWqUvxH82M=; b=Sd/l60BDPZrpNVJCH76HWt2KQY
        78r8ovu9yE0ts3Mz5ukvQXOuWS3r0hgZxMaUc24m2fEPFebomk2RCZf3C+pSzcetpwtHSymx6UANj
        lXil3ylWqN9fg6idv8CR7oaUduchmPwqz3y/8RyeQl0T5hUcbW0gC1kgW0scwiLWmO//7aKNR66OL
        fHvC3P7rn2pAOdtT2k1NNxcOlST5pjzUiwWt271ez9wE0mhwhRbheZCD+CjjdZKhVW84cZ3OnA1n6
        8OzcWKOweAPV8HJ05OUTwV8usk/MeJbt9RscmKrhorxWx9qHFPBjRyljZiFJL5iv+UgSoypMnqAcC
        421RZmBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1izm5m-0004hy-Gd; Thu, 06 Feb 2020 18:41:34 +0000
Date:   Thu, 6 Feb 2020 10:41:34 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        "Yang, Fei" <fei.yang@intel.com>,
        Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Thinh Nguyen <thinhn@synopsys.com>,
        Tejas Joglekar <tejas.joglekar@synopsys.com>,
        Jack Pham <jackp@codeaurora.org>, Todd Kjos <tkjos@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC][PATCH 0/2] Avoiding DWC3 transfer stalls/hangs when using
 adb over f_fs
Message-ID: <20200206184134.GA11027@infradead.org>
References: <20200122222645.38805-1-john.stultz@linaro.org>
 <ef64036f-7621-50d9-0e23-0f7141a40d7a@collabora.com>
 <02E7334B1630744CBDC55DA8586225837F9EE280@ORSMSX102.amr.corp.intel.com>
 <87o8uu3wqd.fsf@kernel.org>
 <02E7334B1630744CBDC55DA8586225837F9EE335@ORSMSX102.amr.corp.intel.com>
 <87lfpy3w1g.fsf@kernel.org>
 <CALAqxLUQ0ciJTLrmEAu9WKCJHAbpY9szuVm=+VapN2QWWGnNjA@mail.gmail.com>
 <20200206074005.GA28365@infradead.org>
 <87ftfn602u.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ftfn602u.fsf@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 08:29:45PM +0200, Felipe Balbi wrote:
> > No, it shoudn't.  dma_map_sg returns the number of mapped segments,
> > and the callers need to remember that.
> 
> We _do_ remember that:

That helps :)

> that req->request.num_mapped_sgs is the returned value. So you're saying
> we should test for i == num_mapped_sgs, instead of using
> sg_is_last(). Is that it?

Yes.

> Fair enough. Just out of curiosity, then, when *should* we use
> sg_is_last()?

Outside of sg_next/sg_last it really shoud not be used at all as far
as I'm concerned. 
