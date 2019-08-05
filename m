Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77594811BC
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfHEFpF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:45:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:39790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbfHEFpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 01:45:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CAA820679;
        Mon,  5 Aug 2019 05:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564983904;
        bh=+/7GAYdBTvoe+DdJ1pTP7FOLkMyX2Uh5QzREr4X/EVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JV+5WlG3BUZJhCxYRfVHqENDleN9S5nhfBy1BLYOOaNwa6OXKKodln21uvarpGjDZ
         xccezCttKjYWILl/N1VHWiSLCDOjlyLnwfoZVVtmeoG4ck+ldx+NoDArrFZ+MoMNvu
         pKaOuzMbI1bzkbt8yz+4PXoBjEQkXicMvHC6kaOk=
Date:   Mon, 5 Aug 2019 07:44:23 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: Re: [PATCH 5.1.x] kconfig: Clear "written" flag to avoid data loss
Message-ID: <20190805054423.GA30534@kroah.com>
References: <20190805053513.29629-1-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805053513.29629-1-yamada.masahiro@socionext.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 02:35:13PM +0900, Masahiro Yamada wrote:
> From: "M. Vefa Bicakci" <m.v.b@runbox.com>
> 
> commit 0c5b6c28ed68becb692b43eae5e44d5aa7e160ce upstream.
> 
> Prior to this commit, starting nconfig, xconfig or gconfig, and saving
> the .config file more than once caused data loss, where a .config file
> that contained only comments would be written to disk starting from the
> second save operation.
> 
> This bug manifests itself because the SYMBOL_WRITTEN flag is never
> cleared after the first call to conf_write, and subsequent calls to
> conf_write then skip all of the configuration symbols due to the
> SYMBOL_WRITTEN flag being set.
> 
> This commit resolves this issue by clearing the SYMBOL_WRITTEN flag
> from all symbols before conf_write returns.
> 
> Fixes: 8e2442a5f86e ("kconfig: fix missing choice values in auto.conf")
> Cc: linux-stable <stable@vger.kernel.org> # 4.19+
> Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---
>  scripts/kconfig/confdata.c | 4 ++++
>  1 file changed, 4 insertions(+)

5.1.y is end-of-life, so no need for this backport.

thanks,

greg k-h
