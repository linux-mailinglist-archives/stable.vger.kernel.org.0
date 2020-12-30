Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1C382E7A4E
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 16:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgL3P1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 10:27:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgL3P1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Dec 2020 10:27:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD324207A6;
        Wed, 30 Dec 2020 15:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609342032;
        bh=9D5CdCo5QpIbsP7n69sEdVl2e2LJVIcUjuR/wirG5D8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2TDjUowQt9yNhvPO0L4xLAuIap8S8IL8+7mNySveVPh4c0M4+7ugsP9DznRlTcU+2
         GgTEtJGvwSnwt4NvQOpfxlRUuzdR3IdAG67mB3IPSAI5B+DJrs0W6JiGeyarTL8WM+
         RJybhuLXjxsKMBagfP00Voyljy7tpfN8pbPUofZI=
Date:   Wed, 30 Dec 2020 16:28:38 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Song Liu <songliubraving@fb.com>
Cc:     stable@vger.kernel.org, Kevin Vigor <kvigor@gmail.com>
Subject: Re: [PATCH] md/raid10: initialize r10_bio->read_slot before use.
Message-ID: <X+ycptEik0Iz+k7n@kroah.com>
References: <20201230074039.1732760-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230074039.1732760-1-songliubraving@fb.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 11:40:39PM -0800, Song Liu wrote:
> From: Kevin Vigor <kvigor@gmail.com>
> 
> In __make_request() a new r10bio is allocated and passed to
> raid10_read_request(). The read_slot member of the bio is not
> initialized, and the raid10_read_request() uses it to index an
> array. This leads to occasional panics.
> 
> Fix by initializing the field to invalid value and checking for
> valid value in raid10_read_request().
> 
> Cc: stable@vger.kernel.org # v4.14+
> Signed-off-by: Kevin Vigor <kvigor@gmail.com>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> (cherry picked from commit 93decc563637c4288380912eac0eb42fb246cc04)
> ---
>  drivers/md/raid10.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
