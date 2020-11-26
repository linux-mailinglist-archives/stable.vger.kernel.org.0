Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5992C4E86
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 06:52:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732555AbgKZFwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 00:52:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:55866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732436AbgKZFwL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Nov 2020 00:52:11 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 762EC20770;
        Thu, 26 Nov 2020 05:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606369931;
        bh=IEYV5/dpz0HtXMqzO0EaMBZpEvsJUD7kbDPuEfNKPUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NK7N2PQXzDfnMsfgzS5J9UWIf9jH5bufpls7FK7xelQLJuzQmDrd5B7+iCo7iph3U
         xvIDr6YiMUIZ2I3ImebQ2NEx30RWN5HEjWak8Rd08/JwYBL8TrywuP/975ZrJgnauz
         jo3WHB5PqvY5fTT4nDRz88l4mA3IiueCC4nlPzi8=
Date:   Thu, 26 Nov 2020 06:52:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Minchan Kim <minchan@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH] tracing: Fix align of static buffer
Message-ID: <X79Ch+WDwYwqWGk8@kroah.com>
References: <20201125225654.1618966-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201125225654.1618966-1-minchan@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 25, 2020 at 02:56:54PM -0800, Minchan Kim wrote:
> With 5.9 kernel on ARM64, I found ftrace_dump output was broken but
> it had no problem with normal output "cat /sys/kernel/debug/tracing/trace".
> 
> With investigation, it seems coping the data into temporal buffer seems to
> break the align binary printf expects if the static buffer is not aligned
> with 4-byte. IIUC, get_arg in bstr_printf expects that args has already
> right align to be decoded and seq_buf_bprintf says ``the arguments are saved
> in a 32bit word array that is defined by the format string constraints``.
> So if we don't keep the align under copy to temporal buffer, the output
> will be broken by shifting some bytes.
> 
> This patch fixes it.

Does this resolve the issue reported at:
	https://lore.kernel.org/r/20201124223917.795844-1-elavila@google.com
?

thanks,

greg k-h
