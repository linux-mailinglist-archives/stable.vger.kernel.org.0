Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4E8163F7
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 14:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbfEGMtc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 08:49:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:35402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726159AbfEGMtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 08:49:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FAFD205C9;
        Tue,  7 May 2019 12:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557233371;
        bh=XdAjnHt4EB6PZ/2o9+t02PkKMJ9elm5fJFbn7IRzPm4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VBku6dTJ6/vky557fEKpwHtjeHJlfREJk0WNBZE7pCtr+3S6OfATQdhOR0zn2c2p0
         AnhZGHFxL9Jd/ldP+yg9HXiYkgWEGFCThDcy/dC8ZZ2OxZjub820VPyiIWhDi6nRl8
         JQAI2XWznaGPYzhpU87bdlMDfn9370j34AG5ZDBI=
Date:   Tue, 7 May 2019 14:49:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4.19 79/99] ASoC: wm_adsp: Correct handling of compressed
 streams that restart
Message-ID: <20190507124928.GA10118@kroah.com>
References: <20190506143053.899356316@linuxfoundation.org>
 <20190506143101.240836871@linuxfoundation.org>
 <20190507174430.2e981704@fdyp522>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507174430.2e981704@fdyp522>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 05:44:30PM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> On Mon, May 06, 2019 at 04:32:52PM +0200, Greg Kroah-Hartman wrote:
> > From: Charles Keepax <ckeepax@opensource.cirrus.com>
> >
> > commit 639e5eb3c7d67e407f2a71fccd95323751398f6f upstream.
> >
> > Previously support was added to allow streams to be stopped and
> > started again without the DSP being power cycled and this was done
> > by clearing the buffer state in trigger start. Another supported
> > use-case is using the DSP for a trigger event then opening the
> > compressed stream later to receive the audio, unfortunately clearing
> > the buffer state in trigger start destroys the data received
> > from such a trigger. Correct this issue by moving the call to
> > wm_adsp_buffer_clear to be in trigger stop instead.
> >
> > Fixes: 61fc060c40e6 ("ASoC: wm_adsp: Support streams which can start/stop with DSP active")
> > Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This commit has other problems, and it is fixed by commit 43d147be5738a9ed6cfb25c285ac50d6dd5793be.
> Please apply this commit too.
> 
> commit 43d147be5738a9ed6cfb25c285ac50d6dd5793be
> Author: Charles Keepax <ckeepax@opensource.cirrus.com>
> Date:   Tue Apr 2 13:49:14 2019 +0100
> 
>     ASoC: wm_adsp: Check for buffer in trigger stop
> 
>     Trigger stop can be called in situations where trigger start failed
>     and as such it can't be assumed the buffer is already attached to
>     the compressed stream or a NULL pointer may be dereferenced.
> 
>     Fixes: 639e5eb3c7d6 ("ASoC: wm_adsp: Correct handling of compressed streams that restart")
>     Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
>     Signed-off-by: Mark Brown <broonie@kernel.org>

Thank you, now queued up!

greg k-h
