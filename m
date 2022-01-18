Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40F0491F3B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 07:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239971AbiARGDK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 01:03:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55336 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiARGDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 01:03:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F17866134B;
        Tue, 18 Jan 2022 06:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE94FC00446;
        Tue, 18 Jan 2022 06:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642485789;
        bh=5nPliC6xbkGgI2haMXdKcA7mKvgxJ2arJHG9iqwiMF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S8uJt7rC+tg52ImtzSj1gstSam+Edu5ckMk2KVw5+BkzZxZO/tnS5WQgKAdVZm9oK
         ZCwoqUdDPE4D0294/HKl+8ksBt2GoluFcUYfR9r87belX/llTs91Y0XvuIaLF5oHeh
         3z/jIiOEemFM0S9O1W2nuetVApN8VIxr5pFmjmTg=
Date:   Tue, 18 Jan 2022 07:03:06 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lukas Wunner <lukas@wunner.de>, jirislaby@kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 28/29] serial: core: Keep mctrl register
 state and cached copy in sync
Message-ID: <YeZYGvxHxm1O3Ntn@kroah.com>
References: <20220118030822.1955469-1-sashal@kernel.org>
 <20220118030822.1955469-28-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118030822.1955469-28-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 17, 2022 at 10:08:21PM -0500, Sasha Levin wrote:
> From: Lukas Wunner <lukas@wunner.de>
> 
> [ Upstream commit 93a770b7e16772530196674ffc79bb13fa927dc6 ]
> 
> struct uart_port contains a cached copy of the Modem Control signals.
> It is used to skip register writes in uart_update_mctrl() if the new
> signal state equals the old signal state.  It also avoids a register
> read to obtain the current state of output signals.
> 
> When a uart_port is registered, uart_configure_port() changes signal
> state but neglects to keep the cached copy in sync.  That may cause
> a subsequent register write to be incorrectly skipped.  Fix it before
> it trips somebody up.
> 
> This behavior has been present ever since the serial core was introduced
> in 2002:
> https://git.kernel.org/history/history/c/33c0d1b0c3eb
> 
> So far it was never an issue because the cached copy is initialized to 0
> by kzalloc() and when uart_configure_port() is executed, at most DTR has
> been set by uart_set_options() or sunsu_console_setup().  Therefore,
> a stable designation seems unnecessary.

As per the text here, this is not needed in any stable trees, so can you
please drop it from all of your autosel queues now?

thanks,

greg k-h
