Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F63356AFF
	for <lists+stable@lfdr.de>; Wed,  7 Apr 2021 13:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234062AbhDGLUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Apr 2021 07:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbhDGLUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Apr 2021 07:20:35 -0400
X-Greylist: delayed 924 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 07 Apr 2021 04:20:25 PDT
Received: from laas.laas.fr (laas.laas.fr [IPv6:2001:660:6602:4::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBB5C061756;
        Wed,  7 Apr 2021 04:20:19 -0700 (PDT)
Received: from cactus.useless-ficus.net (useless-ficus.net [IPv6:2001:470:7ffe:0:0:0:0:cafe])
        (authenticated bits=0)
        by laas.laas.fr (8.16.0.45/8.16.0.29) with ESMTPSA id 137B4YJO028770
        (version=TLSv1.3 cipher=AEAD-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 7 Apr 2021 13:04:40 +0200 (CEST)
Received: from ficus.useless-ficus.net (ficus.useless-ficus.net [IPv6:2001:470:7ffe:1::1])
        by cactus.useless-ficus.net (Postfix) with ESMTP id EAA6A9F;
        Wed,  7 Apr 2021 13:04:31 +0200 (CEST)
        (envelope-from anthony.mallet@laas.fr)
Received: by ficus.useless-ficus.net (Postfix, from userid 1001)
        id C6DF3605557; Wed,  7 Apr 2021 13:04:31 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <24685.37311.759816.776098@gargle.gargle.HOWL>
Date:   Wed, 7 Apr 2021 13:04:31 +0200
From:   Anthony Mallet <anthony.mallet@laas.fr>
To:     Johan Hovold <johan@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/3] Revert "USB: cdc-acm: fix rounding error in TIOCSSERIAL"
In-Reply-To: <20210407102845.32720-2-johan@kernel.org>
References: <20210407102845.32720-1-johan@kernel.org>
        <20210407102845.32720-2-johan@kernel.org>
X-Mailer: VM 8.2.0b under 26.3 (x86_64--netbsd)
Organization: LAAS/CNRS - Toulouse - France
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wednesday  7 Apr 2021, at 12:28, Johan Hovold wrote:
> With HZ=250, the default 0.5 second value of close_delay is converted to
> 125 jiffies when set and is converted back to 50 centiseconds by
> TIOCGSERIAL as expected (not 12 cs as was claimed).

It was "12" (instead of 50) because the conversion gor TIOCGSERIAL was
initially broken, and that was fixed in the previous commit
633e2b2ded739a34bd0fb1d8b5b871f7e489ea29

> For completeness: With different default values for these parameters or
> with a HZ value not divisible by two, the lack of rounding when setting
> the default values in tty_port_init() could result in an -EPERM being
> returned, but this is hardly something we need to worry about.

The -EPERM is harmful when a regular user wants to update other
members of serial_struct without changing the close delays,
e.g. ASYNC_LOW_LATENCY, which is granted to regular users.

Best,
Anthony
