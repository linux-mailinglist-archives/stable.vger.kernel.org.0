Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A9D24EDDB
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 17:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgHWPMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 11:12:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbgHWPMc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 23 Aug 2020 11:12:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C2A02067C;
        Sun, 23 Aug 2020 15:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598195551;
        bh=FGoaCSIX4ECmGEmLd7xZKV4f1E5QyxkP1d/xsP/BO4o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=omjzM7yvmI4MH3adpW0r5YOaQcSlwjqHqXypFT2fUjyBYvNfr+kbhDapxDV2hr9gX
         oTt3fs827o+xXASeuBzHMdVi/iG1fzkBS8ar6JRAM2dV2wKR41C6tyWBTulwiQDoGP
         1YKeeEWVsjt7Gr6br+PEx1HDkWGe0NYX2QhuG7BE=
Date:   Sun, 23 Aug 2020 17:12:51 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mathias Nyman <mathias.nyman@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, Ding Hui <dinghui@sangfor.com.cn>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 3/3] xhci: Always restore EP_SOFT_CLEAR_TOGGLE even if ep
 reset failed
Message-ID: <20200823151251.GA2914810@kroah.com>
References: <20200821091549.20556-1-mathias.nyman@linux.intel.com>
 <20200821091549.20556-4-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821091549.20556-4-mathias.nyman@linux.intel.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 21, 2020 at 12:15:49PM +0300, Mathias Nyman wrote:
> From: Ding Hui <dinghui@sangfor.com.cn>
> 
> Some device drivers call libusb_clear_halt when target ep queue
> is not empty. (eg. spice client connected to qemu for usb redir)
> 
> Before commit f5249461b504 ("xhci: Clear the host side toggle
> manually when endpoint is soft reset"), that works well.
> But now, we got the error log:
> 
>     EP not empty, refuse reset
> 
> xhci_endpoint_reset failed and left ep_state's EP_SOFT_CLEAR_TOGGLE
> bit still set
> 
> So all the subsequent urb sumbits to the ep will fail with the
> warn log:
> 
>     Can't enqueue URB while manually clearing toggle
> 
> We need to clear ep_state EP_SOFT_CLEAR_TOGGLE bit after
> xhci_endpoint_reset, even if it failed.
> 
> Fixes: f5249461b504 ("xhci: Clear the host side toggle manually when endpoint is soft reset"

Nit, you forgot the trailing ')' here...
