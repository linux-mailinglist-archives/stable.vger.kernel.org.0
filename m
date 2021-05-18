Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5CCC38746E
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 10:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347601AbhERI4W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 04:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:60642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240325AbhERI4V (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 May 2021 04:56:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE0986135B;
        Tue, 18 May 2021 08:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621328104;
        bh=pzxfb66QN2ANJJUwd1jPAEiSOUrGsJN1z35uOPl5HJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=erzd/c0nbLs8HowykFsNM57r/bRC6gm+xcvL2re0NReaVr+fpzogn9ty42YGboYr6
         XjeD0Jc6GCAUmbJUbFxBSvU7t/9G5z0BbRViQUywS2n7Zb0JiB1+IIkCAcHyHkuw4G
         W7kirNhxEg/14KsHns/DFmFEkRL+KMtE5mlEUh+s=
Date:   Tue, 18 May 2021 10:55:02 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Patryk Duda <pdk@semihalf.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] platform/chrome: cros_ec_proto: Send command again when
 timeout occurs
Message-ID: <YKOA5hHPsIJbhgnm@kroah.com>
References: <20210518084823.14392-1-pdk@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518084823.14392-1-pdk@semihalf.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 10:48:23AM +0200, Patryk Duda wrote:
> Sometimes kernel is trying to probe Fingerprint MCU (FPMCU) when it
> hasn't initialized SPI yet. This can happen because FPMCU is restarted
> during system boot and kernel can send message in short window
> eg. between sysjump to RW and SPI initialization.
> 
> Cc: <stable@vger.kernel.org> # 4.4+
> Signed-off-by: Patryk Duda <pdk@semihalf.com>
> ---
> Fingerprint MCU is rebooted during system startup by AP firmware (coreboot).
> During cold boot kernel can query FPMCU in a window just after jump to RW
> section of firmware but before SPI is initialized. The window was
> shortened to <1ms, but it can't be eliminated completly.
> 
> Communication with FPMCU (and all devices based on EC) is bi-directional.
> When kernel sends message, EC will send EC_SPI* status codes. When EC is
> not able to process command one of bytes will be eg. EC_SPI_NOT_READY.
> This mechanism won't work when SPI is not initailized on EC side. In fact,
> buffer is filled with 0xFF bytes, so from kernel perspective device is not
> responding. To avoid this problem, we can query device once again. We are
> already waiting EC_MSG_DEADLINE_MS for response, so we can send command
> immediately.
> 
> Best regards,
> Patryk
>  drivers/platform/chrome/cros_ec_proto.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
