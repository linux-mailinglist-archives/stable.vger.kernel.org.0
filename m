Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7423D6C0352
	for <lists+stable@lfdr.de>; Sun, 19 Mar 2023 17:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjCSQyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Mar 2023 12:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCSQyi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Mar 2023 12:54:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9141284A;
        Sun, 19 Mar 2023 09:54:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73F4D61126;
        Sun, 19 Mar 2023 16:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8655C433EF;
        Sun, 19 Mar 2023 16:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679244875;
        bh=SNwnAkp9FIpdByyHEqUkysZv9TxOIb/dW6tgBK0r9CU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JHzvUAYis2jlgBQ8tr+UAzUqkuLT595pLzybvfTk5ovqpXriyARIgOSecsF5qBg4u
         HV3u7a4Ws7AbN8eb5rXDaaxq7RjTyqZKNjXvwF6AtVwSamafYlYbwEfiwrZXIli3s9
         nqq9RIiYR2FY3YKWmzeTxwMzxdKmegzVBDnJPEFSG9z0eRgLsJMfvGLjZQcF0a1pxs
         xXjKmXE06x/OKjIfaaSVpK1AhxNPFyu2VI4GFb6AGJs6zOjsU8HhLsRk/7XhIQcdwJ
         chn4BojQFgR97Ye2SEjosNK3444BLvztcIyvzFS6j3uvbq21sYs4l5lTlH2W+K24+y
         Jeuiv9/v3ZJ+Q==
Received: by pali.im (Postfix)
        id 149D2622; Sun, 19 Mar 2023 17:54:33 +0100 (CET)
Date:   Sun, 19 Mar 2023 17:54:32 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     msizanoen <msizanoen@qtmlabs.xyz>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: alps: fix compatibility with -funsigned-char
Message-ID: <20230319165432.5dj3stwgz4aoluf2@pali>
References: <20230318144206.14309-1-msizanoen@qtmlabs.xyz>
 <1fd818c2-4e68-8760-9123-de4fa1920c6b@qtmlabs.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1fd818c2-4e68-8760-9123-de4fa1920c6b@qtmlabs.xyz>
User-Agent: NeoMutt/20180716
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sunday 19 March 2023 16:56:11 msizanoen wrote:
> Patch confirmed working as expected on real hardware.
> 
> Tested-by: msizanoen <msizanoen@qtmlabs.xyz>

Thank you for testing. Patch looks good, you can add my:

Reviewed-by: Pali Rohár <pali@kernel.org>

Anyway, for future, what do you think about using of s8 and u8 types?
It could prevent this signdness char nightmare.

> On 3/18/23 21:42, msizanoen wrote:
> > The AlpsPS/2 code previously relied on the assumption that `char` is a
> > signed type, which was true on x86 platforms (the only place where this
> > driver is used) before kernel 6.2. However, on 6.2 and later, this
> > assumption is broken due to the introduction of -funsigned-char as a new
> > global compiler flag.
> > 
> > Fix this by explicitly specifying the signedness of `char` when sign
> > extending the values received from the device.
> > 
> > Fixes: f3f33c677699 ("Input: alps - Rushmore and v7 resolution support")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: msizanoen <msizanoen@qtmlabs.xyz>
> > ---
> >   drivers/input/mouse/alps.c | 8 ++++----
> >   1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
> > index 989228b5a0a4..1c570d373b30 100644
> > --- a/drivers/input/mouse/alps.c
> > +++ b/drivers/input/mouse/alps.c
> > @@ -2294,20 +2294,20 @@ static int alps_get_v3_v7_resolution(struct psmouse *psmouse, int reg_pitch)
> >   	if (reg < 0)
> >   		return reg;
> > -	x_pitch = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
> > +	x_pitch = (signed char)(reg << 4) >> 4; /* sign extend lower 4 bits */
> >   	x_pitch = 50 + 2 * x_pitch; /* In 0.1 mm units */
> > -	y_pitch = (char)reg >> 4; /* sign extend upper 4 bits */
> > +	y_pitch = (signed char)reg >> 4; /* sign extend upper 4 bits */
> >   	y_pitch = 36 + 2 * y_pitch; /* In 0.1 mm units */
> >   	reg = alps_command_mode_read_reg(psmouse, reg_pitch + 1);
> >   	if (reg < 0)
> >   		return reg;
> > -	x_electrode = (char)(reg << 4) >> 4; /* sign extend lower 4 bits */
> > +	x_electrode = (signed char)(reg << 4) >> 4; /* sign extend lower 4 bits */
> >   	x_electrode = 17 + x_electrode;
> > -	y_electrode = (char)reg >> 4; /* sign extend upper 4 bits */
> > +	y_electrode = (signed char)reg >> 4; /* sign extend upper 4 bits */
> >   	y_electrode = 13 + y_electrode;
> >   	x_phys = x_pitch * (x_electrode - 1); /* In 0.1 mm units */
