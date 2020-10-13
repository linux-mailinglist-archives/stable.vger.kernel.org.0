Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6045A28D12D
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 17:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730923AbgJMPY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 11:24:28 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33839 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726657AbgJMPY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 11:24:27 -0400
Received: (qmail 673224 invoked by uid 1000); 13 Oct 2020 11:24:26 -0400
Date:   Tue, 13 Oct 2020 11:24:26 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Pratham Pratap <prathampratap@codeaurora.org>
Cc:     gregkh@linuxfoundation.org, rafael.j.wysocki@intel.com,
        mathias.nyman@linux.intel.com, andriy.shevchenko@linux.intel.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        sallenki@codeaurora.org, mgautam@codeaurora.org,
        jackp@codeaurora.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: core: Don't wait for completion of urbs
Message-ID: <20201013152426.GB670875@rowland.harvard.edu>
References: <1602586022-13239-1-git-send-email-prathampratap@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1602586022-13239-1-git-send-email-prathampratap@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 13, 2020 at 04:17:02PM +0530, Pratham Pratap wrote:
> Consider a case where host is trying to submit urbs to the
> connected device while holding the us->dev_mutex and due to
> some reason it is stuck while waiting for the completion of
> the urbs. Now the scsi error mechanism kicks in and it calls

Are you talking about usb-storage?  You should describe the context 
better -- judging by the patch title, it looks like you're talking 
about a core driver instead.

> the device reset handler which is trying to acquire the same
> mutex causing a deadlock situation.

That isn't supposed to happen.  The SCSI error handler should always 
cancel all the outstanding commands before invoking the device reset 
handler.  Cancelling the commands will cause the URBs to complete.

If you found a test case where this doesn't happen, it probably means 
there's a bug in the SCSI core code or the USB host controller driver.  
That bug should be fixed; don't introduce random timeout values to try 
and work around it.

Alan Stern
