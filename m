Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782CE3EDDEA
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 21:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhHPTcD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 15:32:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:38566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhHPTcD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 15:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C6060F41;
        Mon, 16 Aug 2021 19:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629142291;
        bh=9VaxF6jVusxISKrl+DoxFH9PV6Q/wbOarU5+TUjcbCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UxyWzKJuCStklyEI4oOGdmfYjlFW7VqOInRhPrY9SZv+PRNewhH8mhVZDA02SWUUo
         ygXcrXlQ/cCuPkaIhDDi6C9SUca6omB2spOHJB9NkVeGFBKSuU/WzpITTJT2Z3lrr7
         ebmwo5WdyPVtHBIck3fMcV3RA7vD3wxyEC488fIU=
Date:   Mon, 16 Aug 2021 21:31:28 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Georgi Djakov <djakov@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Tipton <mdtipton@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.13 046/151] interconnect: qcom: icc-rpmh: Add BCMs to
 commit list in pre_aggregate
Message-ID: <YRq9EHuOsgqAUFdo@kroah.com>
References: <20210816125444.082226187@linuxfoundation.org>
 <20210816125445.588155407@linuxfoundation.org>
 <56b19dc0-b5b0-accb-956d-1a817444ca04@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56b19dc0-b5b0-accb-956d-1a817444ca04@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 08:17:52PM +0300, Georgi Djakov wrote:
> On 16.08.21 16:01, Greg Kroah-Hartman wrote:
> > From: Mike Tipton <mdtipton@codeaurora.org>
> > 
> > [ Upstream commit f84f5b6f72e68bbaeb850b58ac167e4a3a47532a ]
> > 
> > We're only adding BCMs to the commit list in aggregate(), but there are
> > cases where pre_aggregate() is called without subsequently calling
> > aggregate(). In particular, in icc_sync_state() when a node with initial
> > BW has zero requests. Since BCMs aren't added to the commit list in
> > these cases, we don't actually send the zero BW request to HW. So the
> > resources remain on unnecessarily.
> > 
> > Add BCMs to the commit list in pre_aggregate() instead, which is always
> > called even when there are no requests.
> > 
> > Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
> > Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
> > Link: https://lore.kernel.org/r/20210721175432.2119-5-mdtipton@codeaurora.org
> > Signed-off-by: Georgi Djakov <djakov@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hello Greg and Sasha,
> 
> Please drop this patch from both 5.10 and 5.13 stable queues. It's
> causing issues on some platforms and we are reverting in. Revert is
> in linux-next already.

Now dropped, thanks.

greg k-h
