Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF48660E7E
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 13:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjAGMGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 07:06:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbjAGMGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 07:06:07 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC844EC86
        for <stable@vger.kernel.org>; Sat,  7 Jan 2023 04:06:02 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m26-20020a05600c3b1a00b003d9811fcaafso2795581wms.5
        for <stable@vger.kernel.org>; Sat, 07 Jan 2023 04:06:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLjHqFbROXlE+sbQ3Mi0YQwdit1/ACHkltZB2eIp6ZY=;
        b=VZ5LC/sHAOIR5huRKj2y+0d40HWTG5UTtD8WCG8STyZQlXt4fYxcz2D61c7EiDK6+x
         1iq1BqhEjdpRL68bguKTkMX/H/fNo0BFSKZA5L7Sh7kAEIsM4f9s77WkVIFxDZOxdX4p
         yh1QQk2Nn0mdoUl0yg72fRnItYVKI0RJ5/Pmc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLjHqFbROXlE+sbQ3Mi0YQwdit1/ACHkltZB2eIp6ZY=;
        b=DuRnMToGn1KSGjgYPAQNmBVuf9WwGLx0QZ2DpJrHQLboQOAKB9tR+b8p4uU3H5c6p+
         IdxKcwbofH4ofLD+jHSfwGgRgDxGasLmTG3Nok2g6JXsCv5UMHPjhGvmwZLYVelMBb77
         O8O/zTH4YovqPOaYUYSAkF3oorWvnfRHxZ77zxAzoLdWvGgWqwsxpNb/8c2UyN9Pv7Dk
         /OrlkBr1uo+xM05/CluB1m9w8aUlblXaKzbFeIF7XyPw23lEVneUsNdfwzYnsLH7pbeH
         X+ic+5dLCC4LaMagpak90sf6GkyfNXwuAwHda7r+++RThsG25JFEL1Ppf+Ow2ps56f4J
         /f+w==
X-Gm-Message-State: AFqh2krC7SDNR83EMPjwh3puPMB2Uksvto8dyYMx9RM/sjqFDHfIB8tx
        RBG1xuMhc/Zrb/Kqy7jNWL3sDg==
X-Google-Smtp-Source: AMrXdXvG2OKBklPVU/w7yJTB6p28qUxxhsgOsf2xdlo6IBSDgcIEZZbPsf9QYXqEN76wJsjC57mQNQ==
X-Received: by 2002:a7b:ca4f:0:b0:3c6:edc0:5170 with SMTP id m15-20020a7bca4f000000b003c6edc05170mr40747291wml.25.1673093160874;
        Sat, 07 Jan 2023 04:06:00 -0800 (PST)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id o9-20020a05600c510900b003c6f8d30e40sm10842896wms.31.2023.01.07.04.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Jan 2023 04:05:59 -0800 (PST)
Date:   Sat, 7 Jan 2023 13:05:57 +0100
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] drm/atomic: Allow vblank-enabled + self-refresh
 "disable"
Message-ID: <Y7lgJVP7hVtHpWTB@phenom.ffwll.local>
Mail-Followup-To: Brian Norris <briannorris@chromium.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Sean Paul <seanpaul@chromium.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel.daenzer@mailbox.org>,
        Sandy Huang <hjc@rock-chips.com>,
        linux-rockchip@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230106172310.v2.1.I3904f697863649eb1be540ecca147a66e42bfad7@changeid>
 <CA+ASDXNBDkzz_xRDbE9gNZZN5kSfxksh0EN01_CxNgyog_BZOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+ASDXNBDkzz_xRDbE9gNZZN5kSfxksh0EN01_CxNgyog_BZOg@mail.gmail.com>
X-Operating-System: Linux phenom 5.19.0-2-amd64 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 05:27:33PM -0800, Brian Norris wrote:
> On Fri, Jan 6, 2023 at 5:23 PM Brian Norris <briannorris@chromium.org> wrote:
> > v2:
> >  * add 'ret != 0' warning case for self-refresh
> >  * describe failing test case and relation to drm/rockchip patch better
> 
> Ugh, there's always something you remember right after you hit send: I
> forgot to better summarize some of the other discussion from v1, and
> alternatives we didn't entertain. I'll write that up now (not sure
> whether in patch 1 or 2) and plan on sending a v3 for next week, in
> case there are any other comments I should address at the same time.

For me it needs to be in the helper patch, since anyone not doing rockchip
work will otherwise never find it. But you can also duplicate the
discussion summary into the 2nd patch, doesn't really hurt.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
