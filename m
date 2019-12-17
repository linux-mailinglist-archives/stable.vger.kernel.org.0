Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B380B1225D0
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 08:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbfLQHuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 02:50:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:49960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbfLQHuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Dec 2019 02:50:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F0A1206D3;
        Tue, 17 Dec 2019 07:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576569007;
        bh=SyMa3sn/LvWHfEJGzJYsrqVgJR2b7ftExMP8XxbUE7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I8a5kFfTPFVzBvdNTCB83JBxTel8eMTiNGI9s/ScDNcWfz4jaBiOrfeHkzuiu3EYh
         D30p7LBHRLknWpV4kJiBG2An9fHtGBbOqsq3dhx9ZanSx4YssDe/3KZNeUT0hSIQ1z
         IBZztOh/9YN5Nk2qWzqVAgS+VOnUnnb9/jfpvtM4=
Date:   Tue, 17 Dec 2019 08:50:05 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tejun Heo <tj@kernel.org>,
        Marcin Pawlowski <mpawlowski@fb.com>,
        "Williams, Gerald S" <gerald.s.williams@intel.com>
Subject: Re: [PATCH 4.19 053/140] workqueue: Fix spurious sanity check
 failures in destroy_workqueue()
Message-ID: <20191217075005.GB2474507@kroah.com>
References: <20191216174747.111154704@linuxfoundation.org>
 <20191216174802.938835002@linuxfoundation.org>
 <20191217043810.xamko46u2g4sdkwp@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217043810.xamko46u2g4sdkwp@toshiba.co.jp>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 17, 2019 at 01:38:10PM +0900, Nobuhiro Iwamatsu wrote:
> On Mon, Dec 16, 2019 at 06:48:41PM +0100, Greg Kroah-Hartman wrote:
> > From: Tejun Heo <tj@kernel.org>
> > 
> > commit def98c84b6cdf2eeea19ec5736e90e316df5206b upstream.
> > 
> > Before actually destrying a workqueue, destroy_workqueue() checks
> > whether it's actually idle.  If it isn't, it prints out a bunch of
> > warning messages and leaves the workqueue dangling.  It unfortunately
> > has a couple issues.
> > 
> > * Mayday list queueing increments pwq's refcnts which gets detected as
> >   busy and fails the sanity checks.  However, because mayday list
> >   queueing is asynchronous, this condition can happen without any
> >   actual work items left in the workqueue.
> > 
> > * Sanity check failure leaves the sysfs interface behind too which can
> >   lead to init failure of newer instances of the workqueue.
> > 
> > This patch fixes the above two by
> > 
> > * If a workqueue has a rescuer, disable and kill the rescuer before
> >   sanity checks.  Disabling and killing is guaranteed to flush the
> >   existing mayday list.
> > 
> > * Remove sysfs interface before sanity checks.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Reported-by: Marcin Pawlowski <mpawlowski@fb.com>
> > Reported-by: "Williams, Gerald S" <gerald.s.williams@intel.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> 
> This commit also requires the following commit:
> 
> commit 8efe1223d73c218ce7e8b2e0e9aadb974b582d7f
> Author: Tejun Heo <tj@kernel.org>
> Date:   Fri Sep 20 13:39:57 2019 -0700
> 
>     workqueue: Fix missing kfree(rescuer) in destroy_workqueue()
> 
>     Signed-off-by: Tejun Heo <tj@kernel.org>
>     Reported-by: Qian Cai <cai@lca.pw>
>     Fixes: def98c84b6cd ("workqueue: Fix spurious sanity check failures in destroy_workqueue()")
> 
> This is also required to 4.4, 4.9, 4.14 and 5.3.

Thank you for this, now queued up everywhere.

greg k-h
