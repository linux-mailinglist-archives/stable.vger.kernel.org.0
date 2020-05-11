Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520CA1CE79B
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 23:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgEKVlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 17:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:44704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725860AbgEKVlw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 May 2020 17:41:52 -0400
Received: from localhost (c-67-164-102-47.hsd1.ca.comcast.net [67.164.102.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FA83206E6;
        Mon, 11 May 2020 21:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589233311;
        bh=/fl3uka4BT5IGqZ+Q4Z4mtPFibQXcT2JNziQkXT1B1Y=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=2YJjy8kxgUoeP+gliRPlKr1nW7XHzo4oL9gHBwx3pAz42LG3n/w4NH/igzJJstIct
         HW4nO1ydZ86YE7re2cLTdml2H2TafeyC+oDL4wo5Mqhxuf/9gDzc8Ci/QsQsQ3UlFR
         LhIZV1ZAwA1Eky4PnR4qG9ZAi+2mr3HhB9+YdsHQ=
Date:   Mon, 11 May 2020 14:41:50 -0700 (PDT)
From:   Stefano Stabellini <sstabellini@kernel.org>
X-X-Sender: sstabellini@sstabellini-ThinkPad-T480s
To:     Juergen Gross <jgross@suse.com>
cc:     xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] xen/pvcalls-back: test for errors when calling
 backend_connect()
In-Reply-To: <20200511074231.19794-1-jgross@suse.com>
Message-ID: <alpine.DEB.2.21.2005111440210.26167@sstabellini-ThinkPad-T480s>
References: <20200511074231.19794-1-jgross@suse.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 May 2020, Juergen Gross wrote:
> backend_connect() can fail, so switch the device to connected only if
> no error occurred.
> 
> Fixes: 0a9c75c2c7258f2 ("xen/pvcalls: xenbus state handling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>


> ---
>  drivers/xen/pvcalls-back.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/pvcalls-back.c b/drivers/xen/pvcalls-back.c
> index cf4ce3e9358d..41a18ece029a 100644
> --- a/drivers/xen/pvcalls-back.c
> +++ b/drivers/xen/pvcalls-back.c
> @@ -1088,7 +1088,8 @@ static void set_backend_state(struct xenbus_device *dev,
>  		case XenbusStateInitialised:
>  			switch (state) {
>  			case XenbusStateConnected:
> -				backend_connect(dev);
> +				if (backend_connect(dev))
> +					return;

Do you think it would make sense to WARN?

>  				xenbus_switch_state(dev, XenbusStateConnected);
>  				break;
>  			case XenbusStateClosing:
> -- 
> 2.26.1
> 
