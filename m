Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEA229D91F
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389166AbgJ1Wob (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389160AbgJ1WmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:42:23 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8332247F1;
        Wed, 28 Oct 2020 16:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603903599;
        bh=u0zpqZBA75YhMTCDK2IhnqlGdtca2dn1nTVqZw7Ot14=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=euGVA9HlpXasrUOFGBJJZvv8Qjo5PBwZ/iN2wWfDmBPwQ6UATCjlwTH7csCVMwGMV
         /jSQ3k0xZitMLNf3fOCxhoyEytkkP+jHkCs2uLEYErtl/Tzj74E7ZZwThmkFaxLkIZ
         Kh+SW3kfInPmqvdc4bxy8RhhdcMa00Q/lPcZE0N0=
Date:   Wed, 28 Oct 2020 09:46:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: Re: [PATCH 4.19 018/264] chelsio/chtls: correct function return and
 return type
Message-ID: <20201028094638.3284bded@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201028065803.GA8084@amd>
References: <20201027135430.632029009@linuxfoundation.org>
        <20201027135431.522408687@linuxfoundation.org>
        <20201028065803.GA8084@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 28 Oct 2020 07:58:04 +0100 Pavel Machek wrote:
> > From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> > 
> > [ Upstream commit 8580a61aede28d441e1c80588803411ee86aa299 ]
> > 
> > csk_mem_free() should return true if send buffer is available,
> > false otherwise.  
> 
> > Fixes: 3b8305f5c844 ("crypto: chtls - wait for memory sendmsg, sendpage")  
> 
> This does not fix anything. In fact, binary code should be exactly
> equivalent. It does not need to be in 4.19-stable.

Not sure why you think binary code will be equivalent.

The condition changed from:

cdev->max_host_sndbuf != sk->sk_wmem_queued

to

cdev->max_host_sndbuf > sk->sk_wmem_queued


That said Chelsio would have to comment if it really fixes any real
user-visible issue :)

> > @@ -914,9 +914,9 @@ static int tls_header_read(struct tls_hd
> >  	return (__force int)cpu_to_be16(thdr->length);
> >  }
> >  
> > -static int csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
> > +static bool csk_mem_free(struct chtls_dev *cdev, struct sock *sk)
> >  {
> > -	return (cdev->max_host_sndbuf - sk->sk_wmem_queued);
> > +	return (cdev->max_host_sndbuf - sk->sk_wmem_queued > 0);
> >  }
> >  
> >  static int csk_wait_memory(struct chtls_dev *cdev,
