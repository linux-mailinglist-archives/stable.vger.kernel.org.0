Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC44324BDA
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 09:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhBYIPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 03:15:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:37466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230142AbhBYIP0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 03:15:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DEEE64E4D;
        Thu, 25 Feb 2021 08:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614240885;
        bh=FIIQYrMd3eyKYvYbHiSlBA2eMZvZBmVNWEKSpp/O1YA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nc4LCXLGzTOqXNJY/X9CKnP/p2uTNpjpMfz2ZGQuSo/DYbhTyBwVzNBl9hEVVIei5
         Ex4h6TN1N47xWpM6hOZQ9iRcgu44jKs1v8te9EDCl6gtzhNiv5NOj0LzC5XOyegIut
         ZUx4v47kh1cXFyFvrYTJFE+OK7eGSX012P0v+xnk=
Date:   Thu, 25 Feb 2021 09:14:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 04/35] iwlwifi: pcie: add a NULL check in
 iwl_pcie_txq_unmap
Message-ID: <YDdccs3OacohZgFr@kroah.com>
References: <20210222121013.581198717@linuxfoundation.org>
 <20210222121017.933649049@linuxfoundation.org>
 <20210225060446.auoymjxg5cuzlism@toshiba.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225060446.auoymjxg5cuzlism@toshiba.co.jp>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 03:04:46PM +0900, Nobuhiro Iwamatsu wrote:
> Hi,
> 
> Sorry for the report after the release.
> 
> On Mon, Feb 22, 2021 at 01:36:00PM +0100, Greg Kroah-Hartman wrote:
> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > 
> > [ Upstream commit 98c7d21f957b10d9c07a3a60a3a5a8f326a197e5 ]
> > 
> > I hit a NULL pointer exception in this function when the
> > init flow went really bad.
> > 
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> > Link: https://lore.kernel.org/r/iwlwifi.20210115130252.2e8da9f2c132.I0234d4b8ddaf70aaa5028a20c863255e05bc1f84@changeid
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/net/wireless/iwlwifi/pcie/tx.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
> > index 8dfe6b2bc7031..cb03c2855019b 100644
> > --- a/drivers/net/wireless/iwlwifi/pcie/tx.c
> > +++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
> > @@ -585,6 +585,11 @@ static void iwl_pcie_txq_unmap(struct iwl_trans *trans, int txq_id)
> >  	struct iwl_txq *txq = &trans_pcie->txq[txq_id];
> >  	struct iwl_queue *q = &txq->q;
> >  
> > +	if (!txq) {
> > +		IWL_ERR(trans, "Trying to free a queue that wasn't allocated?\n");
> > +		return;
> > +	}
> > +
> 
> I think that this fix is not enough.
> If txq is NULL, an error will occur with "struct iwl_queue * q = & txq->q;".
> The following changes are required.

Is this a 4.4-only thing, or is this issue also in Linus's tree as well?
If Linus's tree, please submit this as a normal patch so we can apply it
there first.

thanks,

greg k-h
