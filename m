Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D27D60F74E
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 14:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235175AbiJ0Mbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 08:31:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbiJ0Mbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 08:31:47 -0400
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B82D2F614F;
        Thu, 27 Oct 2022 05:31:44 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 6E26F3FA55;
        Thu, 27 Oct 2022 12:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1666873902; bh=DhI7Jpa2fk46YynTb7FAUNf45bUY2pAqyB4/4XUT9U0=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=u2xvHArOBP4pV4EiGf77kPFgsS7pwRtF9nLL0NudQY1FM2bNADHHOQlFvimFEgeWp
         Sp5yO/NbMGgHFrIT3EGmAcqWIVU9SFNoQRrvvtF1Ytvt+tzgixM3ewch9Mvf3VkZFy
         WoFXr/g6sOJpR+MrwYlKm3W+v4acvNsGsDK4iicfq7woJ4bwqlWo7GF+O5V+onGHN4
         XCdPsHLtsbdx45Mo1gfsR464EBcuTl6tBHr0jjTuQpnwfZn6WLVJ0847zQIx569Pzz
         HC4btRypjK7j/82a9NxJgdxiUASE6YWtCBLj0kak9FtKtL94O7qTQF/0z85804uyUe
         Cn+kA6+gGqPtA==
Message-ID: <c56b2545-d749-0460-0031-36ae4e3d0aed@marcan.st>
Date:   Thu, 27 Oct 2022 21:31:36 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Thomas Zimmermann <tzimmermann@suse.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>
Cc:     Pekka Paalanen <pekka.paalanen@collabora.com>,
        dri-devel@lists.freedesktop.org, asahi@lists.linux.dev,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20221027101327.16678-1-marcan@marcan.st>
 <fa4efcfd-91b6-dc76-2e5c-eed538bccff3@suse.de>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH] drm/simpledrm: Only advertise formats that are supported
In-Reply-To: <fa4efcfd-91b6-dc76-2e5c-eed538bccff3@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/10/2022 20.08, Thomas Zimmermann wrote:
> We currently have two DRM drivers that call drm_fb_build_fourcc_list(): 
> simpledrm and ofdrm. I've been very careful to keep the format selection 
> in sync between them. (That's the reason why the helper exists at all.) 
> If the drivers start to use different logic, it will only become more 
> chaotic.
> 
> The format array of ofdrm is at [1]. At a minimum, ofdrm should get the 
> same fix as simpledrm.

Looks like this was merged recently, so I didn't see it on my tree (I
was basing off of 6.1-rc2).

Since this patch is a regression fix, it should be applied to drm-fixes
(and automatically picked up by stable folks) soon to be fixed in 6.1,
and then we can fix whatever is needed in ofdrm separately in drm-tip.
As long as ofdrm is ready for the new behavior prior to the merge of
drm-tip with 6.1, there will be no breakage.

In this case, the change required to ofdrm is probably just to replace
that array with just DRM_FORMAT_XRGB8888 (which should be the only
supported fallback format for new drivers) and then to add a test to
only expose it for formats for which we actually have conversion
helpers, similar to what the the switch() enumerates here. That logic
could later be moved into the helper as a refactor.

>>   	/* Primary plane */
>> +	switch (format->format) {
> 
> I trust you when you say that <native>->XRGB8888 is not enough. But 
> although I've read your replies, I still don't understand why this 
> switch is necessary.
> 
> Why don't we call drm_fb_build_fourcc_list() with the native 
> format/formats and let it append a number of formats, such as adding 
> XRGB888, adding ARGB8888 if necessary, adding ARGB2101010 if necessary. 
> Each with a elaborate comment why and which userspace needs the format. (?)

That would be fine to do, it would just be moving the logic to the
helper. That kind of refactoring is better suited for subsequent
patches. This is a regression fix, it attempts to minimize the amount of
refactoring, which means keeping the logic in simpledrm, to make it
easier to review for correctness.

Also, that would change the API of that function, which would likely
make the merge with the new ofdrm painful. The way things are now, a
small fix to ofdrm will make it compatible with both the state before
and after this patch, which means the merge will go through painlessly,
and then we can just refactor everything once everything is in the same
tree.

- Hector
