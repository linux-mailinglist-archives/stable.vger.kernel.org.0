Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14ECD35472
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfFDXgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:36:02 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33124 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfFDXgC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 19:36:02 -0400
Received: by mail-lj1-f194.google.com with SMTP id v29so10121984ljv.0
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 16:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WV3sJyKzvv2hglik5laJLi6zk95U7YCGm4MZG0UbbBM=;
        b=doTgsxvdZv8uU0x8XW1L0hFFxk7NVRCh4EcK48wmJsmGLsH6XMlLAb/m9hX5yAKfq/
         mpAOXL47upaREgDMBi3qMSM8JV9L1dBVgYXWkO08XRJIh04mvW8/RphRVPAe4EgWjIYG
         dOxwWXAQNwFnvP+7LdEIctpkg0tJPmm6BMtrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WV3sJyKzvv2hglik5laJLi6zk95U7YCGm4MZG0UbbBM=;
        b=f6nnfLSlRkvSEomUCK4m4QVxs7aKX+e3DjVfpRM3JIJIIE2fept6ljM+617wVihN3T
         88pAdW0Dj1x7BirvOCrPyAM3/WW5lmbdMegdgKmDTQFCl0GqiDEgn7WtfuvuNFmxHPyB
         CX9lJAdwrm9TCV4Yh4XNmCB/YPChrgrlVfDjQD92KkTesN70GTVjCwPNMdOKpo7jiAID
         eiHaqVZIu9S56aE9LBGlAP30SdG6Go9z5EMloQ8CJHlw0XYoTLfBxhTHi7zMZyTAzYYT
         rwxpWp2CElKqdeurjwx2hi+/zbQdQWI+1uyHSMAomn5JcXVs5d8g1q0LtNIRG3yu3ZSp
         I8XA==
X-Gm-Message-State: APjAAAUGBtNQoCLbZ9L30aDr4Aax4BFXa45gG1JxQFjty7b72nNK8oFI
        i4OxY4sSrU4DqQ1pgunx8bneMxhrGHY=
X-Google-Smtp-Source: APXvYqwYya9wQF1m8bNwtJLC3vXhcH2yUuWIAzyqAvsb8sW1j6crnnrr5Y2b3bKl8rUxdYX2c86zMg==
X-Received: by 2002:a2e:568b:: with SMTP id k11mr18796948lje.124.1559691360218;
        Tue, 04 Jun 2019 16:36:00 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id w25sm2648958lfk.70.2019.06.04.16.35.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 16:35:59 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id s21so10759433lji.8
        for <stable@vger.kernel.org>; Tue, 04 Jun 2019 16:35:59 -0700 (PDT)
X-Received: by 2002:a2e:5d9c:: with SMTP id v28mr18287829lje.32.1559691358483;
 Tue, 04 Jun 2019 16:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190604232443.3417-1-bjorn.andersson@linaro.org>
In-Reply-To: <20190604232443.3417-1-bjorn.andersson@linaro.org>
From:   Evan Green <evgreen@chromium.org>
Date:   Tue, 4 Jun 2019 16:35:21 -0700
X-Gmail-Original-Message-ID: <CAE=gft7nZNLykioozOJUDitXWc8PgFjDmCucmoz-3wtxzg_4CA@mail.gmail.com>
Message-ID: <CAE=gft7nZNLykioozOJUDitXWc8PgFjDmCucmoz-3wtxzg_4CA@mail.gmail.com>
Subject: Re: [PATCH] phy: qcom-qmp: Correct READY_STATUS poll break condition
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Kishon Vijay Abraham I <kishon@ti.com>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Marc Gonzalez <marc.w.gonzalez@free.fr>,
        Vivek Gautam <vivek.gautam@codeaurora.org>,
        Stephen Boyd <swboyd@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 4, 2019 at 4:24 PM Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> After issuing a PHY_START request to the QMP, the hardware documentation
> states that the software should wait for the PCS_READY_STATUS to become
> 1.
>
> With the introduction of c9b589791fc1 ("phy: qcom: Utilize UFS reset
> controller") an additional 1ms delay was introduced between the start
> request and the check of the status bit. This greatly increases the
> chances for the hardware to actually becoming ready before the status
> bit is read.
>
> The result can be seen in that UFS PHY enabling is now reported as a
> failure in 10% of the boots on SDM845, which is a clear regression from
> the previous rare/occasional failure.
>
> This patch fixes the "break condition" of the poll to check for the
> correct state of the status bit.
>
> Unfortunately PCIe on 8996 and 8998 does not specify the mask_pcs_ready
> register, which means that the code checks a bit that's always 0. So the
> patch also fixes these, in order to not regress these targets.
>
> Cc: stable@vger.kernel.org
> Cc: Evan Green <evgreen@chromium.org>
> Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>
> Cc: Vivek Gautam <vivek.gautam@codeaurora.org>
> Fixes: 73d7ec899bd8 ("phy: qcom-qmp: Add msm8998 PCIe QMP PHY support")
> Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Nice find.

Reviewed-by: Evan Green <evgreen@chromium.org>
