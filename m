Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A63A610CEB
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 11:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiJ1JTA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 05:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiJ1JS7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 05:18:59 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9411C69EA;
        Fri, 28 Oct 2022 02:18:57 -0700 (PDT)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4MzH6P5DY0z9sWR;
        Fri, 28 Oct 2022 11:18:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1666948733;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eis4BHp6rV4DuI32+/hJJDIeNrqEW30VXCIBbxfDosQ=;
        b=Moq/6jp5+T8DQK1h1wG+o+TgTWVFLL6rUV9i4B1j0+NphVi6q7r2pZ98SyL0/u1TVEo+xI
        JY14bk+wBgpdWXKVfsZYz8gJOtkMcxYKbZ1QpqZregow6xOtU9Yl46LEjaRmJyZ1GePtPM
        PQD22sQjze2E6vGFA7EkvWmkxNAEibyETX4BHb6qz9r1+gO9C8wY2pkromSfAbVrF7xOBc
        MfJ7o2AcoYAJtcK9v3E4Bfp8qlDZ2uU0dlZsq/LYxbl4C7E09mXuvWjGvzpLU34XLGAxzo
        iUYT7fl/mS17p3vbbveX88mUQj80WmSPRTaqpMPt8TX75BMdYEwiItkJCekIYA==
Message-ID: <54ee5dcb-d573-ade6-9132-8b165fbc875c@mailbox.org>
Date:   Fri, 28 Oct 2022 11:18:51 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] drm/simpledrm: Only advertise formats that are supported
Content-Language: en-CA
To:     Hector Martin <marcan@marcan.st>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Javier Martinez Canillas <javierm@redhat.com>
Cc:     stable@vger.kernel.org,
        Pekka Paalanen <pekka.paalanen@collabora.com>,
        asahi@lists.linux.dev, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
References: <20221027101327.16678-1-marcan@marcan.st>
 <cfe65da9-497d-b825-7332-874b6e87c087@marcan.st>
From:   =?UTF-8?Q?Michel_D=c3=a4nzer?= <michel.daenzer@mailbox.org>
In-Reply-To: <cfe65da9-497d-b825-7332-874b6e87c087@marcan.st>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: 55bpuhqga5u63eixficdps4prshzwmo6
X-MBO-RS-ID: 0b09ffe32abd9141eff
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-10-27 12:53, Hector Martin wrote:
> 
> Q: Why not just add a conversion from XRGB2101010 to XRGB8888?
> A: Because that would only fix KDE, and would make it slower vs. not
> advertising XRGB2101010 at all (double conversions, plus kernel
> conversion can be slower). Plus, it doesn't make any sense as it only
> fills in one entry in the conversion matrix. If we wanted to actually
> fill out the conversion matrix, and thus support everything simpledrm
> has advertised to day correctly, we would need helpers for:
> 
> rgb565->rgb888
> rgb888->rgb565
> rgb565->xrgb2101010
> rgb888->xrgb2101010
> xrgb2101010->rgb565
> xrgb2101010->rgb888
> xrgb2101010->xrgb8888
> 
> That seems like overkill and unlikely to actually help anyone, it'd just
> give userspace more options to shoot itself in the foot with a
> sub-optimal format choice. And it's a pile of code.

In addition to everything you mentioned, converting from XRGB2101010 to XRGB8888 loses the additional information, defeating the only point of using XRGB2101010 instead of XRGB8888 in the first place.


-- 
Earthling Michel Dänzer            |                  https://redhat.com
Libre software enthusiast          |         Mesa and Xwayland developer

