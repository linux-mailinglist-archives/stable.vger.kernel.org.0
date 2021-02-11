Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCAB318EF3
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:42:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbhBKPl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:57478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhBKPjl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:39:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 349F064E08;
        Thu, 11 Feb 2021 15:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613057890;
        bh=5YfJF7uxrTWeac4nnX0BQnZhyrdOqrgfkk/zq2S5Oik=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/r4K0nYNzJXsb12h+VVxHetr449jMfWcETjIiklOpW8NxCd7gE2xNi4prN2wLPju
         Qs2EmoX0GQTEAjpVH0IuwDuxWEoQVDKMOfN9fXURFN3uvEzhaS5Z9iCj67AZ/fECkk
         Cu75UdlnltnUKPLNIW6AnhV2JVlCI2U9xNNuJuTU=
Date:   Thu, 11 Feb 2021 16:38:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Collins <collinsd@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 07/24] regulator: core: avoid
 regulator_resolve_supply() race condition
Message-ID: <YCVPYEgCIbqDRYLa@kroah.com>
References: <20210211150147.743660073@linuxfoundation.org>
 <20210211150148.069380965@linuxfoundation.org>
 <20210211152656.GD5217@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211152656.GD5217@sirena.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 03:26:56PM +0000, Mark Brown wrote:
> On Thu, Feb 11, 2021 at 04:02:41PM +0100, Greg Kroah-Hartman wrote:
> > From: David Collins <collinsd@codeaurora.org>
> > 
> > [ Upstream commit eaa7995c529b54d68d97a30f6344cc6ca2f214a7 ]
> > 
> > The final step in regulator_register() is to call
> > regulator_resolve_supply() for each registered regulator
> 
> This is buggy without a followup which doesn't seem to have been
> backported here.

Would that be 14a71d509ac8 ("regulator: Fix lockdep warning resolving
supplies")?  Looks like it made it into the 5.4.y and 5.10.y queues, but
not 4.19.y.

Sasha, any reason for this?

thanks,

greg k-h
