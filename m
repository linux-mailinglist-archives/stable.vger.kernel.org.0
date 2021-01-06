Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9438C2EBAE4
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 08:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbhAFHyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 02:54:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:36018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbhAFHyO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Jan 2021 02:54:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1816022CB9;
        Wed,  6 Jan 2021 07:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609919613;
        bh=xiFVpD/CRY+q2mNpAyDtyTzskh6HX/szXzXaESwNz54=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=J6b9OhfstEjwgNagKr8WiPXvAYH53lHpo1rPWSKv/nG/TiJe9Q5E9P/h9Vl5K5wKI
         v5GR5v2BgMyYok7NJ8rAoubRPh9LJURCRFxHTMLt12pgPQtJ25zNFEcLRBVmfDniiw
         WAkwfMVFELRU7DKdpA9DqycEv+lBm95JEvYMZpHSXw1YQT5RSvznYerz1m4fkn4b+y
         9pZANXJ0/EJInT1VWAMzhRz1nIV2PCkASBqaJpKSgduyHJ5dmm7qQTUgAKMOGL8YHB
         T4eUZlb3JU2kylYfDXRGC9DVA2iMpPK/EAqpLQ9v+TTWIHbNDZjdHRjHtp4t/cXU3L
         kCezwEvd6hC3A==
From:   Felipe Balbi <balbi@kernel.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thinh.Nguyen@synopsys.com, linux-usb@vger.kernel.org
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] usb: dwc3: gadget: Check if the gadget had started
In-Reply-To: <92118292e053f3a1a9238facfec91630468ba752.1609865348.git.Thinh.Nguyen@synopsys.com>
References: <cover.1609865348.git.Thinh.Nguyen@synopsys.com>
 <92118292e053f3a1a9238facfec91630468ba752.1609865348.git.Thinh.Nguyen@synopsys.com>
Date:   Wed, 06 Jan 2021 09:53:29 +0200
Message-ID: <87a6tmcxhi.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Hi,

Thinh Nguyen <Thinh.Nguyen@synopsys.com> writes:
> If the gadget had already started, don't try to start again. Otherwise,
> we may request the same threaded irq with the same dev_id, it will mess
> up the interrupt freeing logic. This can happen if a user tries to
> trigger a soft-connect from soft_connect sysfs multiple times. Check to
> make sure that the gadget had started before proceeding to request
> threaded irq. Fix this by checking if there's bounded gadget driver.

Looks like this should be fixed at the framework level, otherwise we
will have to patch every single UDC. After that is done, we can remove
the dwc->gadget_driver check from here.

-- 
balbi
