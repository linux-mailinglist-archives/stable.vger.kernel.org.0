Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1EC31A6521
	for <lists+stable@lfdr.de>; Mon, 13 Apr 2020 12:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbgDMIU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Apr 2020 04:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:42982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727971AbgDMIU0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Apr 2020 04:20:26 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5774FC008609;
        Mon, 13 Apr 2020 01:20:26 -0700 (PDT)
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9230A20692;
        Mon, 13 Apr 2020 08:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586766026;
        bh=kzHqKn+GWCgegiJ0Zguzq9Vbi7lSJ5PufV6o8/thN4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/z+tnRq+AR8mYl5YzlvWL3Fnn2ZZorEuOP2usEDvF0o6NaO7lVfLHfisxpQyWiaJ
         6I4XzI7SPOZofWDKWzgLXLF534SIpiTzsJd5RJNgQwfbCDYuMZ49kSzA1xpqfC5Xcg
         u9HM0XvQHif5P+ujd0RvURmNP0K2EtZAwictzMWY=
Date:   Mon, 13 Apr 2020 10:20:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     nobuhiro1.iwamatsu@toshiba.co.jp
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        clew@codeaurora.org, aneela@codeaurora.org,
        bjorn.andersson@linaro.org, lee.jones@linaro.org
Subject: Re: [PATCH 4.14 36/38] rpmsg: glink: Remove chunk size word align
 warning
Message-ID: <20200413082023.GA2792388@kroah.com>
References: <20200411115437.795556138@linuxfoundation.org>
 <20200411115441.303886448@linuxfoundation.org>
 <OSAPR01MB3667845337B13FB2398B8AB892DD0@OSAPR01MB3667.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OSAPR01MB3667845337B13FB2398B8AB892DD0@OSAPR01MB3667.jpnprd01.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 13, 2020 at 05:16:05AM +0000, nobuhiro1.iwamatsu@toshiba.co.jp wrote:
> Hi,
> 
> > -----Original Message-----
> > From: stable-owner@vger.kernel.org [mailto:stable-owner@vger.kernel.org] On Behalf Of Greg Kroah-Hartman
> > Sent: Saturday, April 11, 2020 9:09 PM
> > To: linux-kernel@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; stable@vger.kernel.org; Chris Lew <clew@codeaurora.org>; Arun
> > Kumar Neelakantam <aneela@codeaurora.org>; Bjorn Andersson <bjorn.andersson@linaro.org>; Lee Jones
> > <lee.jones@linaro.org>
> > Subject: [PATCH 4.14 36/38] rpmsg: glink: Remove chunk size word align warning
> > 
> > From: Chris Lew <clew@codeaurora.org>
> > 
> > commit f0beb4ba9b185d497c8efe7b349363700092aee0 upstream.
> > 
> > It is possible for the chunk sizes coming from the non RPM remote procs
> > to not be word aligned. Remove the alignment warning and continue to
> > read from the FIFO so execution is not stalled.
> > 
> > Signed-off-by: Chris Lew <clew@codeaurora.org>
> > Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This commit also seems to require the following commits:
> 
> commit 928002a5e9dab2ddc1a0fe3e00739e89be30dc6b
> Author: Arun Kumar Neelakantam <aneela@codeaurora.org>
> Date:   Wed Oct 3 17:08:20 2018 +0530
> 
>     rpmsg: glink: smem: Support rx peak for size less than 4 bytes
>     
>     The current rx peak function fails to read the data if size is
>     less than 4bytes.
>     
>     Use memcpy_fromio to support data reads of size less than 4 bytes.
>     
>     Cc: stable@vger.kernel.org
>     Fixes: f0beb4ba9b18 ("rpmsg: glink: Remove chunk size word align warning")
>     Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
>     Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> This fixes commit need to apply 4.19.

This fix is already in 4.19.y, so it's only needed for 4.14.y at this
point in time, thanks!

greg k-h
