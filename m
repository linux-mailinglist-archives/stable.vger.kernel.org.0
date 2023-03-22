Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5906C51C0
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 18:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjCVREM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 13:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjCVRDq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 13:03:46 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5799161AAB
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 10:03:17 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id v4-20020a05600c470400b003ee4f06428fso2403756wmo.4
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 10:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679504595;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fF0kXha0iC7DXFpAivYe8iA4rI1+YTj1bu366LSCxxk=;
        b=CODHf0ARi+ZAQwKJquFfTZVE8GcbNBB35tiLrdZgRYIyaxVhmUezxMFGMCvTfztcTb
         zBY391pL+wcccrmfHqacIkJ0YwfRwFpDfuCK+Q9mDDiiYUqxSVdqaFsm4UhJtdgAcOk/
         F6LAVGKFmL2U0VXmZXkuJANw/xDh74CEr1oqlpBHvEkF7uwCOz8mHJqBtcndkweTZu84
         EWxQDoQICuRUaPaLZel4wmpg8X6v3kZxBzpnge4qiQbhvPObr36dnM6Ec00/y5F17gEs
         WA6uVF72nkfgiZpQBflwbEFO/Re4i7Fk8rbofwYctPmB9ebZDYXgHUX0vTBFV7d3NVPO
         81zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679504595;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fF0kXha0iC7DXFpAivYe8iA4rI1+YTj1bu366LSCxxk=;
        b=0jA9v/6tpJaJ1muMcFYchHdsSdNLcP77JS0q5TQfG54Gi2ZR1Rhyeejde4A8tJvjzD
         bYThAw4MIUb5T913YHjCJqKsepD3a52hp2tPruB2jo6YCp0dDuPhuAip5SrcimfwuTtq
         81k6712EtrU8fUUv4iHP8I3JU1s+cYoMIWpNeU760gNmnRWnBvlHUcknPVvGwSREGieN
         tsw8V1CQk/UcMVdoxHegUt2xNPdbk5kxTR3An5cuV0VX1lZIepiJhf3v5wQ7Zpo6dZMa
         tTJHANMUjTcLAijoxWtAjcFDbR8MwT5ULlar1hcTMUo5n3/5nCwSJCa1GLxcf2JKMs5d
         HyNg==
X-Gm-Message-State: AO0yUKUFquxlkoboIdb4p9Ca7po1l1aRO4DBaGbmtyGNzt0HnH6ExQDx
        gqUjQQWNZby3sCULMyML7nKz4Q==
X-Google-Smtp-Source: AK7set+XVsENvidhTYRl8NHap3p+RLXPJj7q9BKTdTDgxFMbLPVmRCtz/DO/KEbqCzBtozbr/f27Rw==
X-Received: by 2002:a05:600c:2c48:b0:3eb:39e0:3530 with SMTP id r8-20020a05600c2c4800b003eb39e03530mr125002wmg.41.1679504595001;
        Wed, 22 Mar 2023 10:03:15 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id n1-20020a7bc5c1000000b003db03725e86sm17553580wmk.8.2023.03.22.10.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Mar 2023 10:03:14 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     David Airlie <airlied@gmail.com>, Daniel Vetter <daniel@ffwll.ch>,
        Kevin Hilman <khilman@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        dri-devel@lists.freedesktop.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
In-Reply-To: <20230306103533.4915-1-johan+linaro@kernel.org>
References: <20230306103533.4915-1-johan+linaro@kernel.org>
Subject: Re: [PATCH] drm/meson: fix missing component unbind on bind errors
Message-Id: <167950459423.530086.3154658002025345243.b4-ty@linaro.org>
Date:   Wed, 22 Mar 2023 18:03:14 +0100
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

On Mon, 06 Mar 2023 11:35:33 +0100, Johan Hovold wrote:
> Make sure to unbind all subcomponents when binding the aggregate device
> fails.
> 
> 

Thanks, Applied to https://anongit.freedesktop.org/git/drm/drm-misc.git (drm-misc-fixes)

[1/1] drm/meson: fix missing component unbind on bind errors
      https://cgit.freedesktop.org/drm/drm-misc/commit/?id=ba98413bf45edbf33672e2539e321b851b2cfbd1

-- 
Neil

