Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7DB2CAA52
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 18:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbgLAR5s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 12:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729674AbgLAR5r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 12:57:47 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE841C0613D4;
        Tue,  1 Dec 2020 09:57:01 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id v21so1541763plo.12;
        Tue, 01 Dec 2020 09:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ko8Rpi5XdY+5xbwkM3NHH1CGOWT3+hQSw29aZT2K81U=;
        b=OBBFWefNmb6yceW4xat6kcf4+UkhvTOgGxfzRnHw/ANgyrf0jt8zEmlAVNWkSl/TLG
         eOGsG5ymCLPUB4vAuEUi+K2r7zkcLlUz8+zBpEisGY4f+cNM3ula+gfAnU+DFT+dl+b4
         KqIKkqynG/MzCfOP9qzuB4byRyQJrkWeDx0t4SHPxYYslQbEhy/ECPXVpKqQFwpRA0AP
         nG71o+CGxIV7bo9h+o53BG16lnSt18VlfaV+cttOZ04CsN3v5V2kKZhj7ER03SpMWPzK
         64azE/CE/xXWHMe/ExcND7nCtiGrhIPVclogHLPa6JbU0gOEKWh6H9gTb8+7KpNcg0ZG
         MUZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ko8Rpi5XdY+5xbwkM3NHH1CGOWT3+hQSw29aZT2K81U=;
        b=VLFRfhx2KzDI4iPCADGtAyzwq+LW1SRtjNYXLWuIhl8vfF82RYA3uv37CFBQ+lkVA2
         MLoVoInQB9xd3G04otYBRD/bAriwzswb4qWKVhjf34m7LQVlqmJmDQOf5lBLbzkmgggB
         FKmrwQtEs2Lme0cdGHVYv7xZEuVeiseWrCgfc+AraURwn0F0VB3duGm0c4wvKYL6DbCz
         lK36aGB+3guoibVzfWZhxP5gulF2yomU1JhHCMvxAmq4cUU4bFRsT3YYoX9Npt13TWGb
         F/ScHdH+41vr6YZviA9GkYGdYFjrDLHFo7TFKBQmtyPX/thGxAk0H/fL2Xi4L2pP6emM
         TUPA==
X-Gm-Message-State: AOAM5308EDGiicT5xUKPRTj5p67ydVAmcacc2lWqIkazNY6IW6RoQp04
        57Zy8UZx6j3OHPJp4RMRDkLSkGwIUj0=
X-Google-Smtp-Source: ABdhPJzORi7PglZA/hmwhx0f5YxfTHVEFDLPsK5c2HMHC7ecH0KQiTL7PHKer/1gFLkU+uM/tyk7GA==
X-Received: by 2002:a17:90a:db43:: with SMTP id u3mr3813113pjx.235.1606845421332;
        Tue, 01 Dec 2020 09:57:01 -0800 (PST)
Received: from dtor-ws ([2620:15c:202:201:a6ae:11ff:fe11:fcc3])
        by smtp.gmail.com with ESMTPSA id u14sm433817pfc.87.2020.12.01.09.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 09:57:00 -0800 (PST)
Date:   Tue, 1 Dec 2020 09:56:58 -0800
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-input@vger.kernel.org,
        Andre =?iso-8859-1?Q?M=FCller?= <andre.muller@web.de>,
        Nick Dyer <nick.dyer@itdev.co.uk>,
        Jiada Wang <jiada_wang@mentor.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3] Input: atmel_mxt_ts - Fix lost interrupts
Message-ID: <20201201175658.GX2034289@dtor-ws>
References: <20201201123026.1416743-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201201123026.1416743-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 01, 2020 at 01:30:26PM +0100, Linus Walleij wrote:
> After commit 74d905d2d38a devices requiring the workaround
> for edge triggered interrupts stopped working.
> 
> The hardware needs the quirk to be used before even
> proceeding to check if the quirk is needed because
> mxt_acquire_irq() is called before mxt_check_retrigen()
> is called and at this point pending IRQs need to be
> checked, and if the workaround is not active, all
> interrupts will be lost from this point.
> 
> Solve this by switching the calls around.
> 
> Cc: Andre Müller <andre.muller@web.de>
> Cc: Nick Dyer <nick.dyer@itdev.co.uk>
> Cc: Jiada Wang <jiada_wang@mentor.com>
> Cc: stable@vger.kernel.org
> Reported-by: Andre Müller <andre.muller@web.de>
> Tested-by: Andre Müller <andre.muller@web.de>
> Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Fixes: 74d905d2d38a ("Input: atmel_mxt_ts - only read messages in mxt_acquire_irq() when necessary")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thank you.

-- 
Dmitry
