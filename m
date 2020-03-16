Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFFB2186CFE
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 15:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731470AbgCPO0d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 10:26:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729710AbgCPO0c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Mar 2020 10:26:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 04B5120719;
        Mon, 16 Mar 2020 14:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584368792;
        bh=q6g4WiBrZQGjlwO4bu6WdG3zLkNZcpFR8X1o1lWPCYw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FL9DcB0UwHx2nDkBr2BK509ErKJmjrChYiPMoNZfkHMv+gExb+lBkRuz1FkbSlsWb
         86vmLAONpqamDXdOBtZWPAKR277jlm0nPwzdPwFnZj/Icng9Ki2gBDrVSuC8rV0giU
         QG1n4r7X4Ky98iviJC4W/1jXuRpxFIMw05RibQ2k=
Date:   Mon, 16 Mar 2020 15:26:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Matthias Maennich <maennich@google.com>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        qize wang <wangqize888888888@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 4.4] mwifiex: Fix heap overflow in
 mmwifiex_process_tdls_action_frame()
Message-ID: <20200316142630.GA4107198@kroah.com>
References: <20200316141512.70762-1-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200316141512.70762-1-maennich@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 03:15:12PM +0100, Matthias Maennich wrote:
> From: qize wang <wangqize888888888@gmail.com>
> 
> mwifiex_process_tdls_action_frame() without checking
> the incoming tdls infomation element's vality before use it,
> this may cause multi heap buffer overflows.
> 
> Fix them by putting vality check before use it.
> 
> IE is TLV struct, but ht_cap and  ht_oper aren’t TLV struct.
> the origin marvell driver code is wrong:
> 
> memcpy(&sta_ptr->tdls_cap.ht_oper, pos,....
> memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos,...
> 
> Fix the bug by changing pos(the address of IE) to
> pos+2 ( the address of IE value ).
> 
> Signed-off-by: qize wang <wangqize888888888@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> (cherry picked from commit 1e58252e334dc3f3756f424a157d1b7484464c40)
> Signed-off-by: Matthias Maennich <maennich@google.com>
> ---
>  drivers/net/wireless/mwifiex/tdls.c | 70 ++++++++++++++++++++++++++---
>  1 file changed, 64 insertions(+), 6 deletions(-)

Now queued up, thanks.

greg k-h
