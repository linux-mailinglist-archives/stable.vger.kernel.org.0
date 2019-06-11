Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 708163C4DD
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 09:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404282AbfFKHUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 03:20:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404279AbfFKHUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 11 Jun 2019 03:20:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6854D2086D;
        Tue, 11 Jun 2019 07:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560237617;
        bh=A6Gg0KGw/+9WbdgZDB3FBl1rwLrEFluqXrCtKVr6q5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rp4s/cwTvhpotEafDiSCBxwwG57+Tz0FM/y63j/l51/Pvcd1VU0nP2Sg7UaM9/9uT
         +CGfIOgDoQ3hDtpBrh6w2lvzUNe/FQUONWZKQYQvf2BIVlTMS4e+L1fDf+y1k0+maB
         HQ23nMK4FbV2Oz+a0uepd2AngQUCG0iVo3pVraGQ=
Date:   Tue, 11 Jun 2019 09:20:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Shilovskiy <pshilov@microsoft.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Christoph Probst <kernel@probst.it>,
        Steven French <Steven.French@microsoft.com>
Subject: Re: [PATCH 4.4 041/241] cifs: fix strcat buffer overflow and reduce
 raciness in smb21_set_oplock_level()
Message-ID: <20190611072010.GA10581@kroah.com>
References: <20190609164147.729157653@linuxfoundation.org>
 <20190609164148.958546130@linuxfoundation.org>
 <BYAPR21MB130347F749FFEC7025DA5710B6130@BYAPR21MB1303.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR21MB130347F749FFEC7025DA5710B6130@BYAPR21MB1303.namprd21.prod.outlook.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 10, 2019 at 07:13:24PM +0000, Pavel Shilovskiy wrote:
> 
> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org> 
> Sent: Sunday, June 9, 2019 9:40 AM
> To: linux-kernel@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; stable@vger.kernel.org; Christoph Probst <kernel@probst.it>; Pavel Shilovskiy <pshilov@microsoft.com>; Steven French <Steven.French@microsoft.com>
> Subject: [PATCH 4.4 041/241] cifs: fix strcat buffer overflow and reduce raciness in smb21_set_oplock_level()
> 
> From: Christoph Probst <kernel@probst.it>
> 
> commit 6a54b2e002c9d00b398d35724c79f9fe0d9b38fb upstream.
> 
> Change strcat to strncpy in the "None" case to fix a buffer overflow when cinode->oplock is reset to 0 by another thread accessing the same cinode. It is never valid to append "None" to any other message.
> 
> Consolidate multiple writes to cinode->oplock to reduce raciness.
> 
> Signed-off-by: Christoph Probst <kernel@probst.it>
> Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> CC: Stable <stable@vger.kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> --------------------------------
> 
> Hi Greg,
> 
> This patch has been queued for 4.4.y and has already been merged into
> 5.1.y (5.1.5). Are you going to apply it to other stable kernels: 4.9,
> 4.14, 4.19?

It is already in the 4.9.179, 4.14.122, 4.19.46, 5.0.19, and 5.1.5
released kernels.  So I don't think I can merge it into them again :)

thanks,

greg k-h
