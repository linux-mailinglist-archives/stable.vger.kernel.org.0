Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F326C51C1
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 18:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjCVREO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 13:04:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbjCVRDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 13:03:48 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38CB5FFE
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 10:03:20 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j18-20020a05600c1c1200b003ee5157346cso2129943wms.1
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 10:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679504596;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dujRv61zmcVnrqSD4vDmJ5J/GQAubkah0V6OA3TTILA=;
        b=sKtjJBbDGU0biBN4S1JJo8juFcgpQhRBWIJGAKcjYfqy9mDBkD90dLvyqe3atDMZ7O
         XTgAUDtnxcwY8iFQsqcSfi35s5ERoHbHgpFJZMZFzCfkkDAQS1EQ7IzcOyVuYFlHjKRk
         ne1VdqeF7UJMvsWNQ0dSNlR/MGVit0NsFHHwthFZzTqT+af4yQgPFvda/iKJhrFzg64r
         tuJrYlBhriAgxXqAAEt+D70oT3QTn6kMuGIUrIp2ZdGAl6pKcxqDh3Q1TyOnUM1pQO5P
         9Sa8iTQAyeCByYSrmtx93sMxXdfx4TSd+ivb69qC5fn145xqbb91EKgJzCsF//6Jz2x0
         agOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679504596;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dujRv61zmcVnrqSD4vDmJ5J/GQAubkah0V6OA3TTILA=;
        b=LXA+qf0EFDiyQ2qLi+C2M6SqiS/QRCweIMUqia3vXq1QTCtS60R/bCZ/uvDxgpI2QN
         yMV+dR1VZS7Atn7UvSW+suvWDw5pPhctlOfzDv5Z5VDkw4lQEs/HcE85N+Pkel3CbzlK
         8Vrs2nCyHMt7/Cz0bHppIAJ8y6CW1eZGHYJ2LASoPrAyGLB7PwCnEvpAqkapmxpOByW3
         foKHBXUbbwwiRQR4HpXncXnsR3hMEh3f6oYZmoj5VUBgK80rg0+Vkm+ui7xFV2+lrLt3
         HsfTseznPwCSp6dHCqeq36DsGTz7qRTOB+WZF8KaB7LD+GX1sSN6UOLvLDuewzJ73G68
         zJYQ==
X-Gm-Message-State: AO0yUKWDkzpdL7UHCORgz2jpsVOnKzp8m6+ilVksJVVJd5xpG9U8lgm2
        spxnEAa2trIIrs473XGEKFg6Xg==
X-Google-Smtp-Source: AK7set8xfrpjFFbD6r13fZmKLXi2Ry9Kxeb7eX/Cxlh2km+WD2n0mJl4cS46A1F/aNWPtnFIBzQJ+g==
X-Received: by 2002:a05:600c:2182:b0:3ee:3d2d:841a with SMTP id e2-20020a05600c218200b003ee3d2d841amr172302wme.24.1679504595885;
        Wed, 22 Mar 2023 10:03:15 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id n1-20020a7bc5c1000000b003db03725e86sm17553580wmk.8.2023.03.22.10.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 10:03:15 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
To:     Adrien Grassein <adrien.grassein@gmail.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Robert Foss <rfoss@kernel.org>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        dri-devel@lists.freedesktop.org,
        Francesco Dolcini <francesco@dolcini.it>
Cc:     Matheus Castello <matheus.castello@toradex.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Francesco Dolcini <francesco.dolcini@toradex.com>
In-Reply-To: <20230322143821.109744-1-francesco@dolcini.it>
References: <20230322143821.109744-1-francesco@dolcini.it>
Subject: Re: [PATCH v2] drm/bridge: lt8912b: return EPROBE_DEFER if bridge
 is not found
Message-Id: <167950459507.530086.7266374998941792767.b4-ty@linaro.org>
Date:   Wed, 22 Mar 2023 18:03:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, 22 Mar 2023 15:38:21 +0100, Francesco Dolcini wrote:
> Returns EPROBE_DEFER when of_drm_find_bridge() fails, this is consistent
> with what all the other DRM bridge drivers are doing and this is
> required since the bridge might not be there when the driver is probed
> and this should not be a fatal failure.
> 
> 

Thanks, Applied to https://anongit.freedesktop.org/git/drm/drm-misc.git (drm-misc-fixes)

[1/1] drm/bridge: lt8912b: return EPROBE_DEFER if bridge is not found
      https://cgit.freedesktop.org/drm/drm-misc/commit/?id=1a70ca89d59c7c8af006d29b965a95ede0abb0da

-- 
Neil

