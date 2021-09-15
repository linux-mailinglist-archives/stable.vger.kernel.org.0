Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A97540C77F
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 16:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbhIOOeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 10:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233745AbhIOOeA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 10:34:00 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576D3C061574;
        Wed, 15 Sep 2021 07:32:41 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id y3-20020a4ab403000000b00290e2a52c71so956293oon.2;
        Wed, 15 Sep 2021 07:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r+B7P+bJ1yyCKcAAG/Nv16gjiQPAYq04lxb01icvVY0=;
        b=UJS4RQRUo6Tyr7KLmtNEYku4GcNlD5VvkEwr9huMgn/7YEEzxjJPCFoiKsQ1ke4xMY
         Pk2AQYBmwLK+tTRBJKPZqL9FwXWRr63xgXRx2t0Xd7oOeOKyq3Wy7XvunZzSgtIVrWT5
         s8YYIJ0ohsMFUeCtHxchwsZNcOtM6v1vPLkH1sXse+sBLXiwP3x7m1Fpx01rY3sZDz2d
         cdJfi6Q1SOTQZoIy4Wp5YO7Q1BpTI5Lzk88yg3tzo40YXVHJMUA21ucGi6YCMXAGLjnX
         Af3r3bhcM+RODzQ2BfgRd8l0HkCHCYXe9ja/ivja/SGnq7DBC9yYQTFZtpo8ifOmTpKH
         DlZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=r+B7P+bJ1yyCKcAAG/Nv16gjiQPAYq04lxb01icvVY0=;
        b=T25eRHHB6trc2ODUw5wHhhPFncGXRMKPItla4gdOHEtBj3r0ftTjPH17bm84btm3qw
         72bhz/7kd6gB84LDXv39GWtHOcrpUkyngahQROY58XdrL1FS00NiCmO4vQ4Orwsx303a
         3Yevzlh4bwbsB8IjkSc5aL4RT3KOfrr//btejqD6KpXuPVR63EyYrOMme3sWIyv5DAJT
         356uyqZ1oQdzpTk2MKRdt8lfIrnktLwTtsbV6DHVov+bO6i8gltkjxO7r9nV80PM66Pg
         s9tF4zy4m4MHZCSbWwPfPILMBs0CLXkaJX6xWu6VqfNDMVwbFKzy6SkcNRz5y2BOucpO
         yp0g==
X-Gm-Message-State: AOAM5336hAqvQ0vlYmtihXT3Bvue3u7U1PTNa7JaP1E8Rpsj2gHli3Zd
        Soqv0JjH7zOQLG0f316+lKA=
X-Google-Smtp-Source: ABdhPJwgRyomaRiiwB4eFwhgiaU7i3BK8ohkqFLZfju6seY+FUtszZFtzaDdSrsMGolBHVPKC3ISXQ==
X-Received: by 2002:a05:6820:16a8:: with SMTP id bc40mr45352oob.63.1631716360722;
        Wed, 15 Sep 2021 07:32:40 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x4sm41206ood.2.2021.09.15.07.32.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 07:32:40 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 15 Sep 2021 07:32:38 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Hsin-Yi Wang <hsinyi@chromium.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>,
        Mattijs Korpershoek <mkorpershoek@baylibre.com>
Subject: Re: [PATCH 5.10 157/236] Bluetooth: Move shutdown callback before
 flushing tx and rx queue
Message-ID: <20210915143238.GA2403125@roeck-us.net>
References: <20210913131100.316353015@linuxfoundation.org>
 <20210913131105.720088593@linuxfoundation.org>
 <20210915111843.GA16198@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915111843.GA16198@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 15, 2021 at 01:18:43PM +0200, Pavel Machek wrote:
> Hi!
> 
> > [ Upstream commit 0ea53674d07fb6db2dd7a7ec2fdc85a12eb246c2 ]
> 
> Upstream commit is okay...
> 
> > So move the shutdown callback before flushing TX/RX queue to resolve the
> > issue.
> 
> ...but something went wrong in stable. This is not moving code, this
> is duplicating it:
> 
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -1726,6 +1726,14 @@ int hci_dev_do_close(struct hci_dev *hdev)
> >  	hci_request_cancel_all(hdev);
> >  	hci_req_sync_lock(hdev);
> >  
> > +	if (!hci_dev_test_flag(hdev, HCI_UNREGISTER) &&
> > +	    !hci_dev_test_flag(hdev, HCI_USER_CHANNEL) &&
> > +	    test_bit(HCI_UP, &hdev->flags)) {
> > +		/* Execute vendor specific shutdown routine */
> > +		if (hdev->shutdown)
> > +			hdev->shutdown(hdev);
> > +	}
> > +
> >  	if (!test_and_clear_bit(HCI_UP, &hdev->flags)) {
> >  		cancel_delayed_work_sync(&hdev->cmd_timer);
> >  		hci_req_sync_unlock(hdev);
> 
> And yes, we end up with 2 copies in 5.10.
> 

Same problem in v5.4.y, unfortunately.

Guenter

> Best regards,
> 								Pavel
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany


