Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D558624EF0
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 01:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiKKAbW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 19:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231157AbiKKAbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 19:31:22 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CD35F869
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 16:31:21 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id o7so3137835pjj.1
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 16:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BeArgbWRKJ56DeeZbQq60SOy0XSAuNerlwx2a6cRecA=;
        b=NIpdKfiDFZYAimTkKhDGW+TBqzF42/7ZtyCEkSzeNjsv5N2w69HDQx3TqvyGiJsN8S
         +/3d48s0G2LOjW/JTgezM60/h/RQdAWRjEPaThN6u5Y4aX0ReMPRIftQ6NWUQ5gAqAMf
         lLQ5C4DUhSBpSd9BchVBd4mZc3diTTbq8+36Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BeArgbWRKJ56DeeZbQq60SOy0XSAuNerlwx2a6cRecA=;
        b=jqK5qBgC50ZrHl3wC8u+mYzzEvvQWqEirtCFRhm6omdwMFMy0P+067fgWDfZ0m50zO
         /F0ymgMlS5el8Z463sQI5oJSOBYAqGetVXErJp9OZzuzMOPFb7+44DqpRxgdDj2sO3Qj
         YeqloWD0fYrdrr9hNvUexfdH5HIJPy537SP/8wwEMji/zAPQwAoFJB4rgyXC/jl6JV6N
         MhmKnBRvJU91r47auqEMXRzGhFbpYaFZH/reISAklP054BuYN7tLfS3JyjeFESWqxq5T
         cqCaqV09Scl9DTBYaJv/8rTk4cU4hP4+mWPlaObdOvN/ID2MHhzjMuazBsjVnh0WZp3O
         k4eA==
X-Gm-Message-State: ACrzQf0w+3aoVhgYQk4yzK+oqj9Zi388MRw9/no8IV+hzWzB0d5BwNKq
        xVzDUY5ywX4jsTTYeJdVY0onDQ==
X-Google-Smtp-Source: AMsMyM7PpSiwTrDvgomdUQ7mPXloqRN80xZFlIZJzRv22u0wsqZrE0mTs2EHLEjmgOAg4/kZB5K9pw==
X-Received: by 2002:a17:90a:cb95:b0:215:f80c:18e6 with SMTP id a21-20020a17090acb9500b00215f80c18e6mr2596437pju.45.1668126680779;
        Thu, 10 Nov 2022 16:31:20 -0800 (PST)
Received: from google.com ([240f:75:7537:3187:8d55:c60d:579d:741c])
        by smtp.gmail.com with ESMTPSA id k11-20020a170902d58b00b001868d4600b8sm277150plh.158.2022.11.10.16.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 16:31:20 -0800 (PST)
Date:   Fri, 11 Nov 2022 09:31:14 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Wolfram Sang <wsa@kernel.org>, Tomasz Figa <tfiga@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hidenori Kobayashi <hidenorik@google.com>,
        stable@vger.kernel.org, linux-i2c@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/1] i2c: Restore initial power state when we are done.
Message-ID: <Y22X0iDsF2Y5cy95@google.com>
References: <20221109-i2c-waive-v5-0-2839667f8f6a@chromium.org>
 <20221109-i2c-waive-v5-1-2839667f8f6a@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109-i2c-waive-v5-1-2839667f8f6a@chromium.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (22/11/10 17:20), Ricardo Ribalda wrote:
> A driver that supports I2C_DRV_ACPI_WAIVE_D0_PROBE is not expected to
> power off a device that it has not powered on previously.
> 
> For devices operating in "full_power" mode, the first call to
> `i2c_acpi_waive_d0_probe` will return 0, which means that the device
> will be turned on with `dev_pm_domain_attach`.
> 
> If probe fails or the device is removed the second call to
> `i2c_acpi_waive_d0_probe` will return 1, which means that the device
> will not be turned off. This is, it will be left in a different power
> state. Lets fix it.
> 
> Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: stable@vger.kernel.org
> Fixes: b18c1ad685d9 ("i2c: Allow an ACPI driver to manage the device's power state during probe")
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>

Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
