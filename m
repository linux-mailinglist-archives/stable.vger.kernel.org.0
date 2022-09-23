Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C9C5E76A9
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 11:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbiIWJSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 05:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbiIWJSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 05:18:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7121DFAE4;
        Fri, 23 Sep 2022 02:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 048C0B828D6;
        Fri, 23 Sep 2022 09:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB55C433C1;
        Fri, 23 Sep 2022 09:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663924709;
        bh=YeIXUIvKYOYKtRkb/Qswfyg+dBvZFn4qcVK5+GCbxFA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1oz5zunqpwPuWjTITSmGTfRn8wjkEHZJKU8oA+zOHRVgyLLyS6bCzTisrVkn8yMNb
         GLpKp3zXKv8zRbAJElEHNKsdYfhAKwAGj+QZA3YroAK7vj64cQ/BQXOICt8sGfYg3Z
         CJRIwXqpzWFRCvbFghSclGFAN2/N2xw2GtMWKQ4A=
Date:   Fri, 23 Sep 2022 11:18:26 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     Stefan Agner <stefan@agner.ch>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH 5.15 247/779] drm/meson: encoder_hdmi: switch to bridge
 DRM_BRIDGE_ATTACH_NO_CONNECTOR
Message-ID: <Yy154kHD7PPtj05W@kroah.com>
References: <20220815180337.130757997@linuxfoundation.org>
 <20220815180347.894058731@linuxfoundation.org>
 <892a917454bd0bbfe8a4d34a5170fe50@agner.ch>
 <685b64f60375b69c5c790286f1386be3@agner.ch>
 <YyBoACiWvW1UnfQA@kroah.com>
 <db3b3082-5278-7ed8-4322-2422cec227a5@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db3b3082-5278-7ed8-4322-2422cec227a5@linaro.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 23, 2022 at 11:12:02AM +0200, Neil Armstrong wrote:
> Hi Greg,
> 
> On 13/09/2022 13:22, Greg Kroah-Hartman wrote:
> > On Mon, Sep 12, 2022 at 08:48:24PM +0200, Stefan Agner wrote:
> > > On 2022-09-12 18:08, Stefan Agner wrote:
> > > > On 2022-08-15 19:58, Greg Kroah-Hartman wrote:
> > > > > From: Neil Armstrong <narmstrong@baylibre.com>
> > > > > 
> > > > > [ Upstream commit 0af5e0b41110e2da872030395231ab19c45be931 ]
> > > > > 
> > > > > This implements the necessary change to no more use the embedded
> > > > > connector in dw-hdmi and use the dedicated bridge connector driver
> > > > > by passing DRM_BRIDGE_ATTACH_NO_CONNECTOR to the bridge attach call.
> > > > > 
> > > > > The necessary connector properties are added to handle the same
> > > > > functionalities as the embedded dw-hdmi connector, i.e. the HDR
> > > > > metadata, the CEC notifier & other flags.
> > > > > 
> > > > > The dw-hdmi output_port is set to 1 in order to look for a connector
> > > > > next bridge in order to get DRM_BRIDGE_ATTACH_NO_CONNECTOR working.
> > > > 
> > > > HDMI on ODROID-N2+ was working with v5.15.60, and stopped working with
> > > > v5.15.61. Reverting this commit (and two dependent refcount leak) to be
> > > > the culprit. Reverting just the refcount leaks is not enough to get HDMI
> > > > working, so I assume it is this commit.
> > > > 
> > > > I haven't investigated much beyond that, maybe its simple a case of a
> > > > missing kernel configuration? DRM_DISPLAY_CONNECTOR is compiled, and the
> > > > module display_connector is loaded, so that part seemed to have worked.
> > > > 
> > > > Any ideas welcome.
> > > > 
> > > > FWIW, I track the issue in the HAOS tracker at
> > > > https://github.com/home-assistant/operating-system/issues/2120.
> > > 
> > > It seems that backporting commit 7cd70656d128 ("drm/bridge:
> > > display-connector: implement bus fmts callbacks") fixes the problem
> > > without reverting this commit.
> > > 
> > > @Greg, can we backport this commit as well?
> > 
> > sure, now queued up, thanks.
> 
> Backport of 7cd70656d128 ("drm/bridge: display-connector: implement bus fmts callbacks") is still missing in 5.15-stable.

I see it in the 5.15.68 release as commit 590b4f10e3a4.

What am I missing?

confused,

greg k-h
