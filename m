Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE86F382B4D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 13:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236824AbhEQLkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 07:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:39930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236786AbhEQLkR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 07:40:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8145061073;
        Mon, 17 May 2021 11:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621251540;
        bh=vZTDngKbFASGBAu2APMNFPARzCXSAPsBkDehUWO9lb8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yr1ILUltrsbawOLLxozXd3OjcpDL/XVP0nPOFP1TS5BDrbGj+8dyyTcH8DbO9ni/B
         VOAWrkg8LcDz9VMeTU+wZYA22w9wJmGW9i+8v16aDcKjkCdgapM00vpqCOeDh6wUCz
         v3BkEUCUFFcAGtVKFHACbB8jGtg0QvO1AmvK2QLg=
Date:   Mon, 17 May 2021 13:38:57 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for 4.4 and 4.9] dm ioctl: fix out of bounds array access
 when no devices
Message-ID: <YKJV0YDAt/lM7QtR@kroah.com>
References: <20210513094552.266451-1-nobuhiro1.iwamatsu@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210513094552.266451-1-nobuhiro1.iwamatsu@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 13, 2021 at 06:45:52PM +0900, Nobuhiro Iwamatsu wrote:
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> commit 4edbe1d7bcffcd6269f3b5eb63f710393ff2ec7a upstream.
> 
> If there are not any dm devices, we need to zero the "dev" argument in
> the first structure dm_name_list. However, this can cause out of
> bounds write, because the "needed" variable is zero and len may be
> less than eight.
> 
> Fix this bug by reporting DM_BUFFER_FULL_FLAG if the result buffer is
> too small to hold the "nl->dev" value.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> [iwamatsu: Adjust context]
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> ---
>  drivers/md/dm-ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
