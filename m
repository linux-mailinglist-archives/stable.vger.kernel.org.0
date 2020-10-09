Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A1D288A4A
	for <lists+stable@lfdr.de>; Fri,  9 Oct 2020 16:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgJIOHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Oct 2020 10:07:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726471AbgJIOHg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Oct 2020 10:07:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 111CF22261;
        Fri,  9 Oct 2020 14:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602252455;
        bh=sq2waC0U+tisX8JUjtvFPBYY+EjYiABm1eQ6Wv5pd+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=y8nFwjimOlr+EjDZuxTkkQx7tUySa48Vn8KT4/tM+fyqYwmVJO38NlS0zMqxx2HoU
         dsHpHdwg91FNA55jNAEGwCPs7sl7q2+4nfHbMXRzFLVEj1r7R4FLd3PvZetC0aajbG
         cYy4o1JCl5OBemQOj8WlOMO+/PTFt+l1kG2+jEdY=
Date:   Fri, 9 Oct 2020 16:08:21 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jean Delvare <jdelvare@suse.de>
Cc:     stable@vger.kernel.org, volker.ruemelin@googlemail.com,
        wsa@kernel.org
Subject: Re: [PATCH] i2c: i801: Exclude device from suspend direct complete
 optimization
Message-ID: <20201009140821.GC573779@kroah.com>
References: <20201005173931.3c40f15d@endymion>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201005173931.3c40f15d@endymion>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 05, 2020 at 05:39:31PM +0200, Jean Delvare wrote:
> commit 845b89127bc5458d0152a4d63f165c62a22fcb70 upstream.
> 
> By default, PCI drivers with runtime PM enabled will skip the calls
> to suspend and resume on system PM. For this driver, we don't want
> that, as we need to perform additional steps for system PM to work
> properly on all systems. So instruct the PM core to not skip these
> calls.
> 
> Fixes: a9c8088c7988 ("i2c: i801: Don't restore config registers on runtime PM")
> Reported-by: Volker Rümelin <volker.ruemelin@googlemail.com>
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Wolfram Sang <wsa@kernel.org>
> ---
> This is the backported version for kernel trees 5.4 and 4.19. The
> difference with the upstream commit is that DPM_FLAG_NEVER_SKIP is used
> instead of DPM_FLAG_NO_DIRECT_COMPLETE, which did not exist back then.

Thanks, now queue dup.

greg k-h
