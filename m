Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53D53F2B4B
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 13:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239377AbhHTLfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 07:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239233AbhHTLfq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Aug 2021 07:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 40C8361051;
        Fri, 20 Aug 2021 11:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629459308;
        bh=tkVRmuGLhLfvsBQ3/bsUHTitr56vDiVOqOLUyKm0InQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BDSNSX8F+DlYltseB0FN+yIf9YASDb9S52bRN2o+mkZ0KaRb780gByvfQxN+pBrMI
         kDI1ilmXZbWdHaGos0MRfjvKCts4hvDQf/4PzIcNDkSiEtz1RFE5NlxQD2ylm8Pdgw
         2LLbfoJmUkIbdsIPmvgWEF4thNmv7o1jaUqD1DE/I42Ai6FJL2Ad4DzesBEFWKozWC
         fC9AvbGuwdALjC065GHOZIfRxp5Gra7plMyLJVnYjaJJJqmQrq6IFZT6k6vn4My140
         PTAG5x1TXXv0YLcpniBKx9Ye2XCYdgoY5s67TE8AQMWGV2rg0acuCN1y+e6RNWrqKa
         p+Ab8K0POfGWw==
Received: by pali.im (Postfix)
        id BD89B7C5; Fri, 20 Aug 2021 13:35:05 +0200 (CEST)
Date:   Fri, 20 Aug 2021 13:35:05 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: Re: Backporting CVE-2020-3702 ath9k patches to stable
Message-ID: <20210820113505.dgcsurognowp6xqp@pali>
References: <20210818084859.vcs4vs3yd6zetmyt@pali>
 <YRzMt53Ca/5irXc0@kroah.com>
 <20210818091027.2mhqrhg5pcq2bagt@pali>
 <YRzQZZIp/LfMy/xG@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YRzQZZIp/LfMy/xG@kroah.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday 18 August 2021 11:18:29 Greg KH wrote:
> On Wed, Aug 18, 2021 at 11:10:27AM +0200, Pali Rohár wrote:
> > On Wednesday 18 August 2021 11:02:47 Greg KH wrote:
> > > On Wed, Aug 18, 2021 at 10:48:59AM +0200, Pali Rohár wrote:
> > > > Hello! I would like to request for backporting following ath9k commits
> > > > which are fixing CVE-2020-3702 issue.
> > > > 
> > > > 56c5485c9e44 ("ath: Use safer key clearing with key cache entries")
> > > > 73488cb2fa3b ("ath9k: Clear key cache explicitly on disabling hardware")
> > > > d2d3e36498dd ("ath: Export ath_hw_keysetmac()")
> > > > 144cd24dbc36 ("ath: Modify ath_key_delete() to not need full key entry")
> > > > ca2848022c12 ("ath9k: Postpone key cache entry deletion for TXQ frames reference it")
> > > > 
> > > > See also:
> > > > https://lore.kernel.org/linux-wireless/87o8hvlx5g.fsf@codeaurora.org/
> > > > 
> > > > This CVE-2020-3702 issue affects ath9k driver in stable kernel versions.
> > > > And due to this issue Qualcomm suggests to not use open source ath9k
> > > > driver and instead to use their proprietary driver which do not have
> > > > this issue.
> > > > 
> > > > Details about CVE-2020-3702 are described on the ESET blog post:
> > > > https://www.welivesecurity.com/2020/08/06/beyond-kr00k-even-more-wifi-chips-vulnerable-eavesdropping/
> > > > 
> > > > Two months ago ESET tested above mentioned commits applied on top of
> > > > 4.14 stable tree and confirmed that issue cannot be reproduced anymore
> > > > with those patches. Commits were applied cleanly on top of 4.14 stable
> > > > tree without need to do any modification.
> > > 
> > > What stable tree(s) do you want to see these go into?
> > 
> > Commits were introduced in 5.12, so it should go to all stable trees << 5.12
> > 
> > > And what order are the above commits to be applied in, top-to-bottom or
> > > bottom-to-top?
> > 
> > Same order in which were applied in 5.12. So first commit to apply is
> > 56c5485c9e44, then 73488cb2fa3b and so on... (from top of the email to
> > the bottom of email).
> 
> Great, all now queued up.  Sad that qcom didn't want to do this
> themselves :(
> 
> greg k-h

It is sad, but Qualcomm support said that they have fixed it in their
proprietary driver in July 2020 (so more than year ago) and that open
source drivers like ath9k are unsupported and customers should not use
them :( And similar answer is from vendors who put these chips into
their cards / products.
