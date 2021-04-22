Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A0B3687A0
	for <lists+stable@lfdr.de>; Thu, 22 Apr 2021 22:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239066AbhDVUEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Apr 2021 16:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239101AbhDVUEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Apr 2021 16:04:14 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E2DC061756
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 13:03:38 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id u15so15538296plf.10
        for <stable@vger.kernel.org>; Thu, 22 Apr 2021 13:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wfL45R5dBs0MS9kZn3ph77DF/daCg5TSX71XRehgnxk=;
        b=UjUpfOM/+EU+ODcUcs8lF11e3se8Yw8Lky6BSnX4yXUh+tH0bpE0cSc4yyI3n5B7pk
         pv8ltbRteNvl2R3roc9z2gnsO8vWps8U6LQsGpj3qY+cNNdAKS4TAI5H102o/aDYkmit
         DSgHAkITih3THSRWqGyqGn3H5/wg4Zzxk0AD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wfL45R5dBs0MS9kZn3ph77DF/daCg5TSX71XRehgnxk=;
        b=Q1b9V4fX/Ckf9faUcgUgY9ne5NsJAPhpIMPWXt/70+qZZOQ3kuOZHpZyOToHSyvddf
         FidUTA1OB0rteBtwQlwODguHllo8wdITu938eRl3AJT7v691hQaiJv3Yd2cNQvdyFREZ
         uA1xWgTyH8GmMEn8OlBub79l01Tp1O3LAAY/uk6E4aqHgTsxzYvPvumV0ZfeQyp9WtKs
         RSCeCyg1vWUfsEwboCLwIu+pgZDRgpkB9wVBU0vZqPEaqDZind/jn6tEA1sfNM5YolEC
         DHwwp5JuTW4byePyIxTXkQySMvgmTC5SiiZ3ZEg1bAG7t3n8z6ZJ0A0V5hXzmfayyXBL
         5k6w==
X-Gm-Message-State: AOAM531ro2MMIwB0M4T+LEeqFO1WhRP6a6I2eeUik4sP3HRWmQbaraPN
        k/mNvJMOVjIEycXNKG9oG4oodg==
X-Google-Smtp-Source: ABdhPJza8gCfdaIX2zwXwIfrBz18VOBT1lbCrdWZuk0N4EoKlrwKK9Gt24lkIqjFphGcuVLpxWADDA==
X-Received: by 2002:a17:90a:d18a:: with SMTP id fu10mr444528pjb.233.1619121817858;
        Thu, 22 Apr 2021 13:03:37 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:acff:4f9f:d039:23ff])
        by smtp.gmail.com with UTF8SMTPSA id y13sm3044062pgs.93.2021.04.22.13.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 13:03:37 -0700 (PDT)
Date:   Thu, 22 Apr 2021 13:03:36 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Subbaraman Narayanamurthy <subbaram@codeaurora.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Georgi Djakov <djakov@kernel.org>,
        Mike Tipton <mdtipton@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] interconnect: qcom: bcm-voter: add a missing
 of_node_put()
Message-ID: <YIHWmJPcoh4bFKNi@google.com>
References: <1619116570-13308-1-git-send-email-subbaram@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1619116570-13308-1-git-send-email-subbaram@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 22, 2021 at 11:36:10AM -0700, Subbaraman Narayanamurthy wrote:
> Add a missing of_node_put() in of_bcm_voter_get() to avoid the
> reference leak.
> 
> Signed-off-by: Subbaraman Narayanamurthy <subbaram@codeaurora.org>
> Cc: stable@vger.kernel.org

nit: I think you would typically put tags like 'Cc' or 'Fixed' before
the 'Signed-off-by' tag.

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
