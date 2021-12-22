Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C81D47D181
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 13:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244798AbhLVMIM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 07:08:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51544 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235474AbhLVMIL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 07:08:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBF94B81C0E
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 12:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D406C36AE8;
        Wed, 22 Dec 2021 12:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640174889;
        bh=hSx0F1SHuquApofLRciRkqnph0nAiFdr4tsBDQJhIIE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xC2XAy6d4j74ak2dvfopbI2uz96C29YYJ7hQ5arrcLef0prdPalxF0fXwkP0yAT/Q
         QBkR7UOAjRbjFf08FIVTdVrCVFQrqeRS8BZb8hhqvh+9MXd6mfFiPocwxePw6L+wxe
         cetWlVAHIOr/C6VMU1UTNqSsaUNr6vdobHLPxnRI=
Date:   Wed, 22 Dec 2021 13:02:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/3] Fix kernel crash caused by ext4/054
Message-ID: <YcMTwuKA0k16TwwJ@kroah.com>
References: <20211220153659.2120506-1-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211220153659.2120506-1-tytso@mit.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 20, 2021 at 10:36:56AM -0500, Theodore Ts'o wrote:
> The following commits were cherry-picked from upstream to fix a crash
> in ext4/054.  There was a minor fix-up needed in the first patch,
> although no other changes were needed for the 2nd and 3rd patches.
> 
> Ext4/054 will cause older LTS kernels to crash, but unfortunately
> these patches will need further back-porting to apply to 5.4, never
> mind older LTS kernels.  But at least here are the fixes for 5.10....
> 
> Zhang Yi (3):
>   ext4: prevent partial update of the extent blocks
>   ext4: check for out-of-order index extents in
>     ext4_valid_extent_entries()
>   ext4: check for inconsistent extents between index and leaf block
> 
>  fs/ext4/extents.c | 93 ++++++++++++++++++++++++++++++++---------------
>  1 file changed, 63 insertions(+), 30 deletions(-)
> 
> -- 
> 2.31.0
> 

I also had to apply them to 5.15.y as you do not want people to upgrade
and have a regression.

thanks,

greg k-h
