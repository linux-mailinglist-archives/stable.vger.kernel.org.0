Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B63D012EAFB
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 22:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgABVBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 16:01:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:49544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgABVBW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 16:01:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9854A21655;
        Thu,  2 Jan 2020 21:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577998882;
        bh=OEjdh4GxFJXSSDdvy3z1OTTwU0+yCPN2JFYuGdPQqIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Iqbl5upYX5JvnCIrULmFs5PvaefK1GBk7E11qY3GIBIp4/2yX/Urwg1jDw85yGMGY
         fmoHzh4SCdNDKY3+TbNN6ff7FOfH4zmGiuA3rKeOkh7E0ybLQkYGNgWFlgP5OfFJH7
         7vxd8M7Ecu/w/Hj7A5lFs823bfRTQkWagXfBljpg=
Date:   Thu, 2 Jan 2020 22:01:19 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable <stable@vger.kernel.org>, Stephen Boyd <sboyd@kernel.org>
Subject: Re: Clock related crashes in v5.4.y-queue
Message-ID: <20200102210119.GA250861@kroah.com>
References: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029dab5a-22f5-c4e9-0797-54cdba0f3539@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 01, 2020 at 06:44:08PM -0800, Guenter Roeck wrote:
> Hi,
> 
> I see a number of crashes in the latest v5.4.y-queue; please see below
> for details. The problem bisects to commit 54a311c5d3988d ("clk: Fix memory
> leak in clk_unregister()").
> 
> The context suggests recovery from a failed driver probe, and it appears
> that the memory is released twice. Interestingly, I don't see the problem
> in mainline.
> 
> I would suggest to drop that patch from the stable queue.

That does not look right, as you point out, so I will go drop it now.

The logic of the clk structure lifetimes seems crazy, messing with krefs
and just "knowing" the lifecycle of the other structures seems like a
problem just waiting to happen...

thanks,

greg k-h
