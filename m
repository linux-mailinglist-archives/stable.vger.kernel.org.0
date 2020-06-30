Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A1B20F360
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 13:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732813AbgF3LIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 07:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgF3LIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 07:08:11 -0400
X-Greylist: delayed 1084 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 30 Jun 2020 04:08:09 PDT
Received: from puleglot.ru (puleglot.ru [IPv6:2a01:4f8:1c0c:58e8::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D591CC061755;
        Tue, 30 Jun 2020 04:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tsoy.me;
        s=mymail; h=Sender:Content-Transfer-Encoding:MIME-Version:Content-Type:
        References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe
        :List-Post:List-Owner:List-Archive;
        bh=T93SLtnPb6wB9FBMjQial71KQSEtfSKw0717TcvmAh8=; b=J6WB1C5pQWATN7nSRT+Efii6bO
        /7JzRtqiraqSjFjAoUfaqK5gRtm6EBsnDXGXUfonkqWpP0c6zCp9eQr7FvYI/Zf73a5Y+2LwYhlJF
        ACFyPz7hGf8YX5FBxCcosVyPS0QAihfj1L8KXw2ATSGF2XQnUXmNBlOr97O8ELdlxT6E=;
Received: from [10.8.10.223] (helo=work)
        by puleglot.ru with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.93.0.4)
        (envelope-from <puleglot@puleglot.ru>)
        id 1jqDpx-001PGV-MF; Tue, 30 Jun 2020 13:50:01 +0300
Message-ID: <e033669a50b53e439f5071ad12d05c2d02ab6cfc.camel@tsoy.me>
Subject: Re: [PATCH 4.9 026/191] ALSA: usb-audio: Improve frames size
 computation
From:   Alexander Tsoy <alexander@tsoy.me>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>
Date:   Tue, 30 Jun 2020 13:49:50 +0300
In-Reply-To: <20200629154007.2495120-27-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
         <20200629154007.2495120-27-sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

В Пн, 29/06/2020 в 11:37 -0400, Sasha Levin пишет:
> From: Alexander Tsoy <alexander@tsoy.me>
> 
> [ Upstream commit f0bd62b64016508938df9babe47f65c2c727d25c ]
> 
> For computation of the the next frame size current value of fs/fps
> and
> accumulated fractional parts of fs/fps are used, where values are
> stored
> in Q16.16 format. This is quite natural for computing frame size for
> asynchronous endpoints driven by explicit feedback, since in this
> case
> fs/fps is a value provided by the feedback endpoint and it's already
> in
> the Q format. If an error is accumulated over time, the device can
> adjust fs/fps value to prevent buffer overruns/underruns.
> 
> But for synchronous endpoints the accuracy provided by these
> computations
> is not enough. Due to accumulated error the driver periodically
> produces
> frames with incorrect size (+/- 1 audio sample).
> 
> This patch fixes this issue by implementing a different algorithm for
> frame size computation. It is based on accumulating of the remainders
> from division fs/fps and it doesn't accumulate errors over time. This
> new method is enabled for synchronous and adaptive playback
> endpoints.
> 
> Signed-off-by: Alexander Tsoy <alexander@tsoy.me>
> Link: 
> https://lore.kernel.org/r/20200424022449.14972-1-alexander@tsoy.me
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/usb/card.h     |  4 ++++
>  sound/usb/endpoint.c | 43 ++++++++++++++++++++++++++++++++++++++--
> ---
>  sound/usb/endpoint.h |  1 +
>  sound/usb/pcm.c      |  2 ++
>  4 files changed, 45 insertions(+), 5 deletions(-)

Please drop this patch from the queue for now (and for 4.4 as well). It
introduced a regression for some devices. The fix is available, but not
accepted yet.

