Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3F1652294
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 15:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiLTObA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 09:31:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiLTOag (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 09:30:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD0B186ED;
        Tue, 20 Dec 2022 06:29:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C605B81544;
        Tue, 20 Dec 2022 14:29:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D9BC433EF;
        Tue, 20 Dec 2022 14:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671546573;
        bh=UpuzXOOwZs/NV2IUnN+0K9e9seG0tvY+bi0SqVPpbV4=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=NknLAKqa2ouuaAl7QOcccbkv7hks/4MoiSc1MkD0fawpN63QHxiGxngEklza0gWdE
         CWNhwUBXCGIAhVvl5Yb+10utM51fJUKbd6wSv6fUbVReDxE+08Clu7hGwq96Y68MA2
         0MTGn31kUiZOOKvH8JPEOzLNWnwoiEFSbsyhqZTLWZ5pIpm3xR7Heqs5kcQR5bkPDD
         wb8z8XpC1FtSV3ZnYAFGuStmSmKhqzvCeIHY2R3dccd85/ZZ17EY5QbyJPuCVPvHhw
         Po9NpbOl8AiOuV2GLLQ+lAHw3nAMTK6KWYq6XCv4gKGWBSn2tDfiT/UhHKgOxHWiyg
         XwV/Uwz2hlR/Q==
Date:   Tue, 20 Dec 2022 15:29:33 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Jason Gerecke <killertofu@gmail.com>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org,
        "Tobita, Tatsunosuke" <tatsunosuke.tobita@wacom.com>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Joshua Dickens <Joshua@Joshua-Dickens.com>,
        Jason Gerecke <jason.gerecke@wacom.com>, stable@vger.kernel.org
Subject: Re: [PATCH] HID: wacom: Ensure bootloader PID is usable in hidraw
 mode
In-Reply-To: <20221201231141.112916-1-jason.gerecke@wacom.com>
Message-ID: <nycvar.YFH.7.76.2212201529260.9000@cbobk.fhfr.pm>
References: <20221201231141.112916-1-jason.gerecke@wacom.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 1 Dec 2022, Jason Gerecke wrote:

> From: Jason Gerecke <killertofu@gmail.com>
> 
> Some Wacom devices have a special "bootloader" mode that is used for
> firmware flashing. When operating in this mode, the device cannot be
> used for input, and the HID descriptor is not able to be processed by
> the driver. The driver generates an "Unknown device_type" warning and
> then returns an error code from wacom_probe(). This is a problem because
> userspace still needs to be able to interact with the device via hidraw
> to perform the firmware flash.
> 
> This commit adds a non-generic device definition for 056a:0094 which
> is used when devices are in "bootloader" mode. It marks the devices
> with a special BOOTLOADER type that is recognized by wacom_probe() and
> wacom_raw_event(). When we see this type we ensure a hidraw device is
> created and otherwise keep our hands off so that userspace is in full
> control.
> 
> Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
> Tested-by: Tatsunosuke Tobita <tatsunosuke.tobita@wacom.com>
> Cc: <stable@vger.kernel.org>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs

