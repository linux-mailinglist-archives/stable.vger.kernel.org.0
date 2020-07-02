Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01494211D26
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 09:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgGBHjQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 03:39:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726362AbgGBHjP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 03:39:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0188220899;
        Thu,  2 Jul 2020 07:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593675555;
        bh=rsnSMgK+PEjc6QpYGFGgd0hifmbtlMKKEoPLUAQc1x4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sIJ0RAGql0Mx/xTWl++iOcsDhPVxYDpNrwoS/BvJaALPeNa1a1K2nE3aaH0pLCa5r
         xaQbqA/USeodfMkstUlZef6talreayt8mLfXsBRpw+DRgEQb/Q7xfmJXEf5qSAVxkb
         4/YDPVj9mNN/TG79ymSjn7PEIBs8lVTAHd9rAyys=
Date:   Thu, 2 Jul 2020 09:39:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Denis Grigorev <d.grigorev@omprussia.ru>, stable@vger.kernel.org
Subject: Re: [PATCH 3.16 00/10] Fix possible crash on L2CAP socket shutdown
Message-ID: <20200702073919.GG1073011@kroah.com>
References: <20200630153641.21004-1-d.grigorev@omprussia.ru>
 <1bf72bc1ace92609fec953daf17342e1d2d48394.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bf72bc1ace92609fec953daf17342e1d2d48394.camel@decadent.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 02, 2020 at 12:31:01AM +0100, Ben Hutchings wrote:
> On Tue, 2020-06-30 at 18:36 +0300, Denis Grigorev wrote:
> > This series of commits fixes a problem with closing l2cap connection
> > if socket has unACKed frames. Due an to an infinite loop in l2cap_wait_ack
> > the userspace process gets stuck in close() and then the kernel crashes
> > with the following report:
> > 
> > Call trace:
> > [<ffffffc000ace0b4>] l2cap_do_send+0x2c/0xec
> > [<ffffffc000acf5f8>] l2cap_send_sframe+0x178/0x260
> > [<ffffffc000acf740>] l2cap_send_rr_or_rnr+0x60/0x84
> > [<ffffffc000acf980>] l2cap_ack_timeout+0x60/0xac
> > [<ffffffc0000b35b8>] process_one_work+0x140/0x384
> > [<ffffffc0000b393c>] worker_thread+0x140/0x4e4
> > [<ffffffc0000b8c48>] kthread+0xdc/0xf0
> > 
> > All kernels below v4.3 are affected.
> [...]
> 
> Thanks for your work, but I'm afraid the 3.16-stable branch is no
> longer being maintained (as of today).

Want me to mark it EOL and remove it from the release table on
kernel.org now?

thanks,

greg k-h
