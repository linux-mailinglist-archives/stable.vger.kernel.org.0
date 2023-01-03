Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A862365C51D
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 18:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238628AbjACRcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 12:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238592AbjACRb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 12:31:57 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E57391263B
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 09:31:41 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id d123so16918817iof.6
        for <stable@vger.kernel.org>; Tue, 03 Jan 2023 09:31:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QVXkX+oXDjibQsAJOLkEC70E+94rOo3Bn3DMKsDQMdQ=;
        b=fLRVjK+RCtG+oc9MpS7kUULwSxGxSKeRu3LC/oVre0/bOTPIhK/rVrxy2nxMBHcCYr
         vZ6gQH9ucVfG868kq8Z9TjtgBymNJF/4JJwjSQmGYeBZ8A9eVXmiONPA0TVIiufS1TXc
         wtuBP3iJL1BnAfFD1b2SlZ0i0x1EfV02uVFCI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QVXkX+oXDjibQsAJOLkEC70E+94rOo3Bn3DMKsDQMdQ=;
        b=NhaagvjOowvLq4Gq9PVpldZasGFR86NKHAMzLTjsuaR8iFTwFhdcfWSA8XaQI+7T6r
         XIucc5TO4aeqKSeGZ/rLC8dB2pe0wtIZxnj1iw78CcSNmvJ8NtGZ8KkpkSJ7Xa5SYlXf
         1QkbJqaVzNl7NpM42hq61Hbb6r2HO+Sr/ao1P+2bsxUKII+oJ0U1xNLUUPWIV6Hk5kAu
         /ib18N96iFZevDSFNxco/KHne/I6/EuB+NLhNpTF7a8rU/tu+NSXikueDGmhJAowMX89
         mA0HQ/HV4F85GD7aCK+sLwxWWUzvtWXnM85ZfYFeKAiLN261jynheRrnjL5uX4Kxeb1C
         nnBQ==
X-Gm-Message-State: AFqh2kpx9BRMdXsm2wd8cgtnnEt6cu680AXWOQBeb6A0335mQP2wKCX6
        eijjgQUAMd64Fj9mrUZKH4rZZg==
X-Google-Smtp-Source: AMrXdXvGWSFQf3Q13U3wLmLZliIZO0W4zz2ArpL05k9HKU6pTSREQvmx8Vv6NJlusfoWk8ckio50Ug==
X-Received: by 2002:a6b:6d15:0:b0:6df:5a5d:5e8b with SMTP id a21-20020a6b6d15000000b006df5a5d5e8bmr34981690iod.9.1672767101292;
        Tue, 03 Jan 2023 09:31:41 -0800 (PST)
Received: from localhost (30.23.70.34.bc.googleusercontent.com. [34.70.23.30])
        by smtp.gmail.com with UTF8SMTPSA id k130-20020a6bba88000000b006e0577610e2sm11941366iof.45.2023.01.03.09.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 09:31:40 -0800 (PST)
Date:   Tue, 3 Jan 2023 17:31:40 +0000
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     Doug Anderson <dianders@chromium.org>,
        Icenowy Zheng <uwu@icenowy.me>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        stable@vger.kernel.org,
        Ravi Chandra Sadineni <ravisadineni@chromium.org>
Subject: Re: [PATCH v2 1/2] usb: misc: onboard_usb_hub: Don't create platform
 devices for DT nodes without 'vdd-supply'
Message-ID: <Y7RmfDZcjRlBTkKf@google.com>
References: <20221222022605.v2.1.If5e7ec83b1782e4dffa6ea759416a27326c8231d@changeid>
 <3724284.kQq0lBPeGt@steina-w>
 <fdfe4b3c-1e7c-b9d5-6173-ce2c0e8dd52b@i2se.com>
 <1783674.3VsfAaAtOV@steina-w>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1783674.3VsfAaAtOV@steina-w>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 02, 2023 at 03:38:19PM +0100, Alexander Stein wrote:
> Hi Stefan,
> 
> Am Montag, 2. Januar 2023, 12:44:33 CET schrieb Stefan Wahren:
> > Hello Alexander,
> > 
> > Am 02.01.23 um 10:20 schrieb Alexander Stein:
> > > Hi everybody,
> > > 
> > > Am Freitag, 23. Dezember 2022, 08:46:45 CET schrieb Icenowy Zheng:
> > >> 在 2022-12-22星期四的 11:26 -0800，Doug Anderson写道：
> > >> 
> > >>> Hi,
> > >>> 
> > >>> On Wed, Dec 21, 2022 at 6:26 PM Matthias Kaehlcke <mka@chromium.org>
> > >>> 
> > >>> wrote:
> > >>>> The primary task of the onboard_usb_hub driver is to control the
> > >>>> power of an onboard USB hub. The driver gets the regulator from the
> > >>>> device tree property "vdd-supply" of the hub's DT node. Some boards
> > >>>> have device tree nodes for USB hubs supported by this driver, but
> > >>>> don't specify a "vdd-supply". This is not an error per se, it just
> > >>>> means that the onboard hub driver can't be used for these hubs, so
> > >>>> don't create platform devices for such nodes.
> > >>>> 
> > >>>> This change doesn't completely fix the reported regression. It
> > >>>> should fix it for the RPi 3 B Plus and boards with similar hub
> > >>>> configurations (compatible DT nodes without "vdd-supply"), boards
> > >>>> that actually use the onboard hub driver could still be impacted
> > >>>> by the race conditions discussed in that thread. Not creating the
> > >>>> platform devices for nodes without "vdd-supply" is the right
> > >>>> thing to do, independently from the race condition, which will
> > >>>> be fixed in future patch.
> > >>>> 
> > >>>> Fixes: 8bc063641ceb ("usb: misc: Add onboard_usb_hub driver")
> > >>>> Link:
> > >>>> https://lore.kernel.org/r/d04bcc45-3471-4417-b30b-5cf9880d785d@i2se.com
> > >>>> /
> > >>>> Reported-by: Stefan Wahren <stefan.wahren@i2se.com>
> > >>>> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > >>>> ---
> > >>>> 
> > >>>> Changes in v2:
> > >>>> - don't create platform devices when "vdd-supply" is missing,
> > >>>> 
> > >>>>    rather than returning an error from _find_onboard_hub()
> > >>>> 
> > >>>> - check for "vdd-supply" not "vdd" (Johan)
> > >>>> - updated subject and commit message
> > >>>> - added 'Link' tag (regzbot)
> > >>>> 
> > >>>>   drivers/usb/misc/onboard_usb_hub_pdevs.c | 13 +++++++++++++
> > >>>>   1 file changed, 13 insertions(+)
> > >>> 
> > >>> I'm a tad bit skeptical.
> > >>> 
> > >>> It somehow feels a bit too much like "inside knowledge" to add this
> > >>> here. I guess the "onboard_usb_hub_pdevs.c" is already pretty
> > >>> entangled with "onboard_usb_hub.c", but I'd rather the "pdevs" file
> > >>> keep the absolute minimum amount of stuff in it and all of the
> > >>> details
> > >>> be in the other file.
> > >>> 
> > >>> If this was the only issue though, I'd be tempted to let it slide. As
> > >>> it is, I'm kinda worried that your patch will break Alexander Stein,
> > >>> who should have been CCed (I've CCed him now) or Icenowy Zheng (also
> > >>> CCed now). I believe those folks are using the USB hub driver
> > >>> primarily to drive a reset GPIO. Looking at the example in the
> > >>> bindings for one of them (genesys,gl850g.yaml), I even see that the
> > >>> reset-gpio is specified but not a vdd-supply. I think you'll break
> > >>> that?
> > >> 
> > >> Well technically in my final DT a regulator is included (to have the
> > >> Vbus enabled when enabling the hub), however I am still against this
> > >> patch, because the driver should work w/o vdd-supply (or w/o reset-
> > >> gpios), and changing this behavior is a DT binding stability breakage.
> > > 
> > > I second that. The bindings don't require neither vdd-supply nor
> > > reset-gpios.
> > > 
> > > But I have to admit I lack to understand the purpose of this series in the
> > > first place. What is the benefit or fix?
> > 
> > did you followed the provided link from the patch?
> 
> Ah, I didn't notice that. Thanks. Admittedly I've yet to fully understand that 
> race condition, but Matthias already suspects this series might not be enough, 
> even for boards which do use vdd-supply.
> 
> Just for the record, this series breaks my board if, as suspected by Doug 
> Anderson and Icenowy Zheng, there is no vdd-supply. The reset line will never 
> be touched.

Yes, I missed that a reset GPIO could be used in combination with an always-on
regulator (instead of specifiying 'vdd-supply') to 'switch the hub on and off'.
If we proceed with the general approach of this patch then creation of the pdev
should only be skipped when neither 'vdd-supply' nor 'reset-gpios' is specified.
