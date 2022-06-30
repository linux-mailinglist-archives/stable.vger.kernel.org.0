Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC5D561283
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 08:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbiF3Gei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 02:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbiF3Geh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 02:34:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691D42CDE8;
        Wed, 29 Jun 2022 23:34:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 050CF621FA;
        Thu, 30 Jun 2022 06:34:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96E3C341C8;
        Thu, 30 Jun 2022 06:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656570875;
        bh=CVsB0I1jCfXqz/B/gLEyz+jbRI188O9nR4J+pt/8oTY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TzM5T7KgikPskMNBTrOcT7Vy4tIb2ppX3qkSeCvt09Ssp07yUTBrqpYLLRsBvgRDN
         3dXTqjTIqRWZeJU+S2Y8U8XggZj209EABqRHAHM5TW5Z3rAB72PT7nbnvK7+Upu5Vp
         PbwuHlrRC53W9b/GV7CSq+CCqQfPG8F5wQxhvZsQ=
Date:   Thu, 30 Jun 2022 08:34:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     William McVicker <willmcvicker@google.com>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        kernel-team@android.com, linux-hwmon@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>
Subject: Re: [PATCH 4.19 v1 1/2] hwmon: Introduce
 hwmon_device_register_for_thermal
Message-ID: <Yr1D+BGiv3MXgpm/@kroah.com>
References: <20220629225843.332453-1-willmcvicker@google.com>
 <20220629225843.332453-2-willmcvicker@google.com>
 <d4a85598-af50-541a-9632-8d0343e8082d@roeck-us.net>
 <YrzdyUm/xlJPldwP@google.com>
 <4bafbfe7-1a9e-651e-41c1-76a131c1a477@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bafbfe7-1a9e-651e-41c1-76a131c1a477@roeck-us.net>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 29, 2022 at 07:31:10PM -0700, Guenter Roeck wrote:
> On 6/29/22 16:18, William McVicker wrote:
> > On 06/29/2022, Guenter Roeck wrote:
> > > On 6/29/22 15:58, Will McVicker wrote:
> > > > From: Guenter Roeck <linux@roeck-us.net>
> > > > 
> > > > [ upstream commit e5d21072054fbadf41cd56062a3a14e447e8c22b ]
> > > > 
> > > > The thermal subsystem registers a hwmon driver without providing
> > > > chip or sysfs group information. This is for legacy reasons and
> > > > would be difficult to change. At the same time, we want to enforce
> > > > that chip information is provided when registering a hwmon device
> > > > using hwmon_device_register_with_info(). To enable this, introduce
> > > > a special API for use only by the thermal subsystem.
> > > > 
> > > > Acked-by: Rafael J . Wysocki <rafael@kernel.org>
> > > > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > > 
> > > NACK. The patch introducing the problem needs to be reverted.
> > 
> > I'm fine with that as well. I've already verified that fixes the issue. I'll go
> > ahead and send the revert.
> > 
> 
> My understanding is that it is already queued up.

Yes it is, sorry for the delay, will try to push out -rc releases later
today...

greg k-h
