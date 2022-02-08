Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3EDF4ACFC6
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 04:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237974AbiBHD2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 22:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiBHD2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 22:28:24 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C06CC0401D1
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 19:28:24 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id v17-20020a4ac911000000b002eac41bb3f4so16059610ooq.10
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 19:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ZAKaEEyJI1QlBtAO97x/djdFEUaVpT8G63TEnOhPRg=;
        b=W6dNI7vUff+i2CWCPidwYuDGTXnjvVZ967bP9FBbHOD6GWxeF7BTCtKnnq+/EnBk8d
         Cdl5XsWFnnf0bi3ikaGN5N0vkfb9qsUCYM4uVsVSPTaZQ6NBZLPdwkCMoWNx+B36ZzH8
         Fg+da5Yr1RHZHbv40fywMSgRRWEd6sxVquv3W6NYMJRL8MNkjYqkaNTXciJh5Hy1iynM
         k52TqHw5xhSsd/Qh4qvrw0PeraONV9SYN6jCl0B++3IhJtysEQzjNCtGMfoss7RdzHvI
         jH0doWgS4TBQWIULob9UVazUbDZh6sgnMr3IcEg0csFxPhU/2SvH/KKa1PgPxd9vhqWj
         COUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ZAKaEEyJI1QlBtAO97x/djdFEUaVpT8G63TEnOhPRg=;
        b=1z3RShxBL3oB/XTMI8Rc5eqNKLJLvahwlBRaarZATnSNoRE34dYLLoZCZX/TioiHjm
         WFQlelDhMt+e04JOjj0lYimz7WROojmw5g8XyRHK+uERtocurTLVrJBl4wbvnQnbuPz3
         9f/Rm4xg/xXGpq43L9uyd7Pm+1NPQAbAY6YaPPKjcqWjAz44iLbzz117+vwOrOigMrdD
         VhSVrF/wyZFX7IJ4GkYiSYdi7l6OqUi36FiebRPkhVBmdE+4uYjqrFrZqqGjd8u7UZdp
         bq03cpco3EpSyGpePIoBw6PkYPXxWMg5sLaYWuupd+U6itWw/aQ1gRgI8I23Gx/cehtT
         UUUw==
X-Gm-Message-State: AOAM533rhQYHqUdnc4wGiD+HniA4TH1ezpsXSCd25lmlo8g5fPdmTzl0
        pQFT2CGjxyt3TSNj7ETT0Ba7RQ==
X-Google-Smtp-Source: ABdhPJxN1005N1nYLZgtc+K1Uzm1yy23+Xza9MKiC+hNYnP7jyUycrml+zFm/YdVOHUZHfNTY5jJxQ==
X-Received: by 2002:a05:6870:3:: with SMTP id a3mr631975oaa.305.1644290903793;
        Mon, 07 Feb 2022 19:28:23 -0800 (PST)
Received: from builder.lan ([2600:1700:a0:3dc8:3697:f6ff:fe85:aac9])
        by smtp.gmail.com with ESMTPSA id c13sm4705272otf.5.2022.02.07.19.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 19:28:23 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alistair Delva <adelva@google.com>, linux-kernel@vger.kernel.org
Cc:     linux-remoteproc@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Rishabh Bhatnagar <rishabhb@codeaurora.org>,
        stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        kernel-team@android.com
Subject: Re: [PATCH] remoteproc: Fix count check in rproc_coredump_write()
Date:   Mon,  7 Feb 2022 21:28:22 -0600
Message-Id: <164429089105.137686.16984376250267108775.b4-ty@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220119232139.1125908-1-adelva@google.com>
References: <20220119232139.1125908-1-adelva@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 19 Jan 2022 23:21:39 +0000, Alistair Delva wrote:
> Check count for 0, to avoid a potential underflow. Make the check the
> same as the one in rproc_recovery_write().
> 
> 

Applied, thanks!

[1/1] remoteproc: Fix count check in rproc_coredump_write()
      commit: 09dc6efba9088a84ac00bd25be36c50d0a01a4df

Best regards,
-- 
Bjorn Andersson <bjorn.andersson@linaro.org>
