Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0D9F3584C1
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 15:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhDHNcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 09:32:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:46774 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231665AbhDHNcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Apr 2021 09:32:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617888726; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e/BYXAqs9v2XgoT7DwNh0sQcjNscDAkBH9BXsk3qfmc=;
        b=kHWNJHVI19TVIsXv2WQ6wnWrCWEVevm2PBRwT+VCTZ960Cm+Pkkl3H00brUVI6b0GkvbGe
        tnonQXzeXOCeUp43BNt+V7E3LB8IdPeZDPCgcDTrw/UXU40cocZpxh3dz2PyA18ya22jK1
        RgEqA/yO4j/Drs0uuerH4X85o/PfNzE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5CBC6B13B;
        Thu,  8 Apr 2021 13:32:06 +0000 (UTC)
Message-ID: <177fba4f41526ef97aadddc9c4d7abf71c1cf77b.camel@suse.com>
Subject: Re: [PATCH v2 1/3] Revert "USB: cdc-acm: fix rounding error in
 TIOCSSERIAL"
From:   Oliver Neukum <oneukum@suse.com>
To:     Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anthony Mallet <anthony.mallet@laas.fr>, stable@vger.kernel.org
Date:   Thu, 08 Apr 2021 15:31:49 +0200
In-Reply-To: <20210408131602.27956-2-johan@kernel.org>
References: <20210408131602.27956-1-johan@kernel.org>
         <20210408131602.27956-2-johan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Donnerstag, den 08.04.2021, 15:16 +0200 schrieb Johan Hovold:
> This reverts commit b401f8c4f492cbf74f3f59c9141e5be3071071bb.
> 
> The offending commit claimed that trying to set the values reported back
> by TIOCGSERIAL as a regular user could result in an -EPERM error when HZ
> is 250, but that was never the case.
> 
> With HZ=250, the default 0.5 second value of close_delay is converted to
> 125 jiffies when set and is converted back to 50 centiseconds by
> TIOCGSERIAL as expected (not 12 cs as was claimed, even if that was the
> case before an earlier fix).
> 
> Comparing the internal current and new jiffies values is just fine to
> determine if the value is about to change so drop the bogus workaround
> (which was also backported to stable).
> 
> For completeness: With different default values for these parameters or
> with a HZ value not divisible by two, the lack of rounding when setting
> the default values in tty_port_init() could result in an -EPERM being
> returned, but this is hardly something we need to worry about.
> 
> Cc: Anthony Mallet <anthony.mallet@laas.fr>
> Cc: stable@vger.kernel.org
> Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Oliver Neukum <oneukum@suse.com>

