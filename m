Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04F07154359
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 12:45:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727586AbgBFLpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 06:45:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgBFLpu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 6 Feb 2020 06:45:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8774120661;
        Thu,  6 Feb 2020 11:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580989549;
        bh=ZUspsdQ2rs6/9aUC6SF8t5aeGHcSFv/ALBv58PC074A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uPu+d4vFDSdAjFUF/tQ0LAF3L/O/1K+Wya4hC1we2RMSNaLBOfN7bTDcX1Y/4sAmb
         7vCdKTxYPQDvZZuDKriQwSwAFg2dDj3uBqB//6HbKKnNBAZ3WToabUMmBu11AK8rGn
         GDVXyBRKyP5nuKmcDwhl6i33qbnO2cQ6gIHNNIPg=
Date:   Thu, 6 Feb 2020 11:45:46 +0000
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Jakub Nantl <jn@forever.cz>, Jonathan Olds <jontio@i4free.co.nz>,
        Michael Dreher <michael@5dot1.de>, linux-usb@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: serial: ch341: fix receiver regression
Message-ID: <20200206114546.GA3275679@kroah.com>
References: <20200206111819.20829-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200206111819.20829-1-johan@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 06, 2020 at 12:18:19PM +0100, Johan Hovold wrote:
> While assumed not to make a difference, not using the factor 2 prescaler
> makes the receiver more susceptible to errors.
> 
> Specifically, there have been reports of problems with devices that
> cannot generate a 115200 rate with a smaller error than 2.1% (e.g.
> 117647 bps). But this can also be reproduced with a low-speed RS232
> tranceiver at 115200 when the input rate is close to nominal.
> 
> So whenever possible, enable the factor 2 prescaler and halve the
> divisor in order to use settings closer to that of the previous
> algorithm.
> 
> Fixes: 35714565089e ("USB: serial: ch341: reimplement line-speed handling")
> Cc: stable <stable@vger.kernel.org>	# 5.5
> Reported-by: Jakub Nantl <jn@forever.cz>
> Tested-by: Jakub Nantl <jn@forever.cz>
> Signed-off-by: Johan Hovold <johan@kernel.org>


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
