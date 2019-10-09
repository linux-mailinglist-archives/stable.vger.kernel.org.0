Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72F6D0B47
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 11:33:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730398AbfJIJcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 05:32:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbfJIJct (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 05:32:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 848DC20B7C;
        Wed,  9 Oct 2019 09:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570613569;
        bh=Qcai3WFj1Vr8RwsOaAUArbhYUeCnV6FfXohDH+W8Ib4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ph3HFuxTYCP3w4lMaMmKhp3zuJnp5DtAuas0lBA63+lNlza79RC1P8eNvMCWDc4jo
         wVCx1/KaNZqenRMqKxwrTPTdhIKTyOqP6x3zVlTPQ5GEQgUnavBszn0DU4zWPMnVVO
         0mSvhwAovYTljwmEmUnmmMyZ0aWbJXfGMQ4fq0bQ=
Date:   Wed, 9 Oct 2019 11:32:46 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4.4, 4.9] crypto: caam - fix concurrency issue in
 givencrypt descriptor
Message-ID: <20191009093246.GB3901624@kroah.com>
References: <20191008201941.17526-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191008201941.17526-1-horia.geanta@nxp.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 11:19:41PM +0300, Horia Geantă wrote:
> commit 48f89d2a2920166c35b1c0b69917dbb0390ebec7 upstream.
> 
> IV transfer from ofifo to class2 (set up at [29][30]) is not guaranteed
> to be scheduled before the data transfer from ofifo to external memory
> (set up at [38]:
> 
> [29] 10FA0004           ld: ind-nfifo (len=4) imm
> [30] 81F00010               <nfifo_entry: ofifo->class2 type=msg len=16>
> [31] 14820004           ld: ccb2-datasz len=4 offs=0 imm
> [32] 00000010               data:0x00000010
> [33] 8210010D    operation: cls1-op aes cbc init-final enc
> [34] A8080B04         math: (seqin + math0)->vseqout len=4
> [35] 28000010    seqfifold: skip len=16
> [36] A8080A04         math: (seqin + math0)->vseqin len=4
> [37] 2F1E0000    seqfifold: both msg1->2-last2-last1 len=vseqinsz
> [38] 69300000   seqfifostr: msg len=vseqoutsz
> [39] 5C20000C      seqstr: ccb2 ctx len=12 offs=0
> 
> If ofifo -> external memory transfer happens first, DECO will hang
> (issuing a Watchdog Timeout error, if WDOG is enabled) waiting for
> data availability in ofifo for the ofifo -> c2 ififo transfer.
> 
> Make sure IV transfer happens first by waiting for all CAAM internal
> transfers to end before starting payload transfer.
> 
> New descriptor with jump command inserted at [37]:
> 
> [..]
> [36] A8080A04         math: (seqin + math0)->vseqin len=4
> [37] A1000401         jump: jsl1 all-match[!nfifopend] offset=[01] local->[38]
> [38] 2F1E0000    seqfifold: both msg1->2-last2-last1 len=vseqinsz
> [39] 69300000   seqfifostr: msg len=vseqoutsz
> [40] 5C20000C      seqstr: ccb2 ctx len=12 offs=0
> 
> [Note: the issue is present in the descriptor from the very beginning
> (cf. Fixes tag). However I've marked it v4.19+ since it's the oldest
> maintained kernel that the patch applies clean against.]
> 
> Cc: <stable@vger.kernel.org> # v4.19+
> Fixes: 1acebad3d8db8 ("crypto: caam - faster aead implementation")
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> [Horia: backport to v4.4, v4.9]
> Signed-off-by: Horia Geantă <horia.geanta@nxp.com>

Now queued up, thanks.

greg k-h
