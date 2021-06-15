Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BAA3A762E
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 06:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhFOE6W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 00:58:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:48348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhFOE6V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Jun 2021 00:58:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 188AC613DA;
        Tue, 15 Jun 2021 04:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623732977;
        bh=NRGdtYDLvpCd+/uSyt1rDy8DtVDlYObyw/BBM2ESELg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mLnV0J1JV2NotD7G0fMaeniEAsvdI/ryPu6oPWnXY2U3InxqVUGCzWWJkd4NBmOSE
         2HR/FqST6AgnTIQxs/4s9cneWaaIcqzo6w8d2oZdJbgtqPQyx8TJTkQY3K058Pn4Fx
         AngERUkdeTtZ1abv0L4JQVVWtv/edwywvFqeZe3c=
Date:   Tue, 15 Jun 2021 06:56:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Siddharth Gupta <sidgup@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v3 1/4] remoteproc: core: Move cdev add before device add
Message-ID: <YMgy7eg3wde0eVfe@kroah.com>
References: <1623723671-5517-1-git-send-email-sidgup@codeaurora.org>
 <1623723671-5517-2-git-send-email-sidgup@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623723671-5517-2-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 07:21:08PM -0700, Siddharth Gupta wrote:
> When cdev_add is called after device_add has been called there is no
> way for the userspace to know about the addition of a cdev as cdev_add
> itself doesn't trigger a uevent notification, or for the kernel to
> know about the change to devt. This results in two problems:
>  - mknod is never called for the cdev and hence no cdev appears on
>    devtmpfs.
>  - sysfs links to the new cdev are not established.
> 
> The cdev needs to be added and devt assigned before device_add() is
> called in order for the relevant sysfs and devtmpfs entries to be
> created and the uevent to be properly populated.

So this means no one ever ran this code on a system that used devtmpfs?

How was it ever tested?

