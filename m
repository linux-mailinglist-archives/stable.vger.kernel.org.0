Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F702922BD
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 09:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbgJSHCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 03:02:22 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:38675 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727175AbgJSHCW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 03:02:22 -0400
Received: by mail-lj1-f193.google.com with SMTP id m20so10723747ljj.5;
        Mon, 19 Oct 2020 00:02:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wEeufKCObi+IpynLWe9WQXVzx+1s6haXoiocpLiNQWo=;
        b=CTUa5PA0sM21/wJoCQIcDKj4u48uBDatapYtrzgOdf59bzPCXOoe4Afu5bSlw3fxEg
         9w4zthNHRfKOz1QVliJ8+bnUg/AL49dcmVX/oFbX0G5Jf85+7qMgM+dh54RiFIFxxlWC
         2A+9c7WfDg8uF9ibPeuM83AzC78nMHZYvgxhWq/smYLq0KgITBqOoP5dQhpOLvrgnkQb
         lenINQ+YiBY1mBlOvWtbzRlmwHfXg+HJi7/BEdVC52VUmf54nPfpXkBXDGub/inKUfpI
         sMMrJN/RycvH6jBkISqLaSFRS00B1j6UHzignVlXnJn9uAjHE7BLzv3nHX56CnF3mBK3
         JiFA==
X-Gm-Message-State: AOAM533ohz9xy9njN9GOOyxR5MfQX2XurqXxmyxMiUhVkMNRYnfRjbhF
        PUCuJAiK+UPTPJ50NhN+fZw=
X-Google-Smtp-Source: ABdhPJzO8A67rktquY4rITqfyjaoRASffHIkslIvibA+CK2ltevaV9KMlSuD/8bGwnWkHIXM8KDtJQ==
X-Received: by 2002:a2e:9951:: with SMTP id r17mr6173655ljj.37.1603090938756;
        Mon, 19 Oct 2020 00:02:18 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id v4sm3437678ljk.80.2020.10.19.00.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 00:02:17 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kUPBS-0000EE-8I; Mon, 19 Oct 2020 09:02:18 +0200
Date:   Mon, 19 Oct 2020 09:02:18 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>,
        Oliver Neukum <oneukum@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.9 054/111] USB: cdc-acm: handle broken union
 descriptors
Message-ID: <20201019070218.GO26280@localhost>
References: <20201018191807.4052726-1-sashal@kernel.org>
 <20201018191807.4052726-54-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201018191807.4052726-54-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Oct 18, 2020 at 03:17:10PM -0400, Sasha Levin wrote:
> From: Johan Hovold <johan@kernel.org>
> 
> [ Upstream commit 960c7339de27c6d6fec13b54880501c3576bb08d ]
> 
> Handle broken union functional descriptors where the master-interface
> doesn't exist or where its class is of neither Communication or Data
> type (as required by the specification) by falling back to
> "combined-interface" probing.
> 
> Note that this still allows for handling union descriptors with switched
> interfaces.
> 
> This specifically makes the Whistler radio scanners TRX series devices
> work with the driver without adding further quirks to the device-id
> table.
> 
> Reported-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> Tested-by: Daniel Caujolle-Bert <f1rmb.daniel@gmail.com>
> Acked-by: Oliver Neukum <oneukum@suse.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Link: https://lore.kernel.org/r/20200921135951.24045-3-johan@kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

I was surprised to see this picked up by AUTOSEL since I remember adding
a stable tag to this patch (to v2, changed my mind since v1) -- and it's
there in the lore link above.

Greg, just to make sure this wasn't due to a b4 bug; did you drop the
stable tag on purpose when applying?

The tag-order has been reshuffled by b4 too it seems (I know, some
people think that's ok) so maybe it fell out in the process.

Johan
