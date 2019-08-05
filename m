Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F318881132
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 06:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbfHEE4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 00:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbfHEE4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 00:56:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25D02205F4;
        Mon,  5 Aug 2019 04:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564981004;
        bh=P56BqoX10JB8lrevzh3ZYngCk33rejYoH+aau1pzIGI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m7sVjrZQ6FSNAxb3g01qB5/xfE+0E9qCDpV2IoFkOeZ4bHNZvrbUnE0mbpglYyrnD
         1SEs2NIGVzAHII9IGJTHW5orMn09jN83gdWmrWKWiuyEuMGk/oKsAMgr7mHOxjQoti
         /ihntIkICCyNLShZQo+GFP25IT0VcOKDsgrG+SPU=
Date:   Mon, 5 Aug 2019 06:56:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "M. Vefa Bicakci" <m.v.b@runbox.com>
Subject: Re: [PATCH 4.19.x] kconfig: Clear "written" flag to avoid data loss
Message-ID: <20190805045642.GA31896@kroah.com>
References: <20190805022143.8657-1-yamada.masahiro@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805022143.8657-1-yamada.masahiro@socionext.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 11:21:43AM +0900, Masahiro Yamada wrote:
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

Thanks for the backport, now queued up.

greg k-h
