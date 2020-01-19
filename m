Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 392EF141EEE
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 16:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgASPxW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 10:53:22 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34102 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbgASPxW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 10:53:22 -0500
Received: by mail-lf1-f67.google.com with SMTP id l18so22035206lfc.1
        for <stable@vger.kernel.org>; Sun, 19 Jan 2020 07:53:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nlXx1t1kXYQp2vJ2k1L9OrgAxcPIAOBgSt1sUDPSaSY=;
        b=Li0wSGwU/sgEvNdvTnazDkZf2dVGNxMQ2K+/T1bhcCLZSlhsZ/T5+ETHbw1kl9q6X0
         xAX+yicwv55WB65nhzVQo9Qjc3xvDK8QLxqMcmOj4ItRDsToGPDNZnkMaEE7R16RS7Cw
         Ocf1XEoiJBk3Y7ZZgjoHw0ztPuxNWODMxzkBIYUzBj5WNpzbg95B5Fh65b3Mq4qA/f6g
         QKjoRBEypRSNvcJhdNqtSeE50ZFqcFt8IG+iFoT9P4w/UQAFlap1puWnVLMvPC4HHQql
         NpgrRv5o+VvOXJxJhp97p6jPvQ6WaTD1ocTdxcT7pRTC5YX1Ejy4XBK8ZIEz6DOyC3Sp
         SS0A==
X-Gm-Message-State: APjAAAVsl/LScD6CgW73+oa9uB4I5yfd3plTP/whT5N5k9cgDQycD3EO
        ThLv3c9Bq7ZQKZc5aLIBMgL5n/E6
X-Google-Smtp-Source: APXvYqwl8p8XqPCUIxUUhzdl3HcczebmZRdRdy285aZjOOCdcf5gEMdO89cKA7Hi5HJ0ZxA10hX6Ww==
X-Received: by 2002:ac2:544f:: with SMTP id d15mr10932056lfn.126.1579449200418;
        Sun, 19 Jan 2020 07:53:20 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id y5sm2419891lfl.6.2020.01.19.07.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jan 2020 07:53:19 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@kernel.org>)
        id 1itCt3-0007pM-4R; Sun, 19 Jan 2020 16:53:17 +0100
Date:   Sun, 19 Jan 2020 16:53:17 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, johan@kernel.org,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] USB: serial: io_edgeport: handle unbound
 ports on URB" failed to apply to 4.14-stable tree
Message-ID: <20200119155317.GA2301@localhost>
References: <15794412294018@kroah.com>
 <20200119154225.GQ1706@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119154225.GQ1706@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 10:42:25AM -0500, Sasha Levin wrote:
> On Sun, Jan 19, 2020 at 02:40:29PM +0100, gregkh@linuxfoundation.org wrote:
> >
> >The patch below does not apply to the 4.14-stable tree.
> >If someone wants it applied there, or to any other stable or longterm
> >tree, then please email the backport, including the original git commit
> >id to <stable@vger.kernel.org>.
> >
> >thanks,
> >
> >greg k-h
> >
> >------------------ original commit in Linus's tree ------------------
> >
> >From e37d1aeda737a20b1846a91a3da3f8b0f00cf690 Mon Sep 17 00:00:00 2001
> >From: Johan Hovold <johan@kernel.org>
> >Date: Fri, 17 Jan 2020 10:50:23 +0100
> >Subject: [PATCH] USB: serial: io_edgeport: handle unbound ports on URB
> > completion
> >
> >Check for NULL port data in the shared interrupt and bulk completion
> >callbacks to avoid dereferencing a NULL pointer in case a device sends
> >data for a port device which isn't bound to a driver (e.g. due to a
> >malicious device having unexpected endpoints or after an allocation
> >failure on port probe).
> >
> >Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> >Cc: stable <stable@vger.kernel.org>
> >Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >Signed-off-by: Johan Hovold <johan@kernel.org>
> 
> I also took dd1fae527612 ("USB: serial: io_edgeport: use irqsave() in
> USB's complete callback") as a fix on it's own,

That commit is not a fix; it was a preparatory change done to be able to
call completion handlers with interrupts enabled.

> and queued both for 4.14-4.4.

That said, it should be fine to backport, thanks.

Johan
