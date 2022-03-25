Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 740774E7DB6
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiCYX6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 19:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiCYX6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 19:58:52 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A181C4B35
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 16:57:17 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id z8so9881966oix.3
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 16:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=dF3l/8rJJ88LI3L212eeEG8ChpweezAO/LgHhM3ZshQ=;
        b=IeUnfdUCh/hMpGj/86bCARzVHdx7A0/M758wB5N+YBqiwITGU/UMajpA+bIKH8FvQk
         UvD/5mDMHzvnvQDD04I7Sxc6O4xBhabU9J975QdlSPfm4fDHOLmqriQvOrjVadhBCxnG
         VWSTEg3+VYcdunuWZORjVCfwlQKvOQZrvjL4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=dF3l/8rJJ88LI3L212eeEG8ChpweezAO/LgHhM3ZshQ=;
        b=qiltRdXeAse05ZrwaqUr4FMHtUSWsFLDn8qAg+JxVMg2seRsgETGOfqXudAHvboSRt
         H1zcRJseoOTWHkrRgzC0CrZsxuYG7qLIvyzvYTke/Ow8yekz46CrmXmtFANIl2uayMBG
         SldDVEuLRgccmMGEaAAGhLZq9hGHJmNHcA29DcZPzDKWlXp70C93mSULcb/O2C+SGoUn
         Hzw20M4nt+zkl8dAgv6m95R5XZWj4mxIB35ZZhQaoCAt3bN1GQ7zHN4u6N6T2y5hV8QX
         9KyHNQFTxOr3FsEZpQG9PptDtwevTUvtN5kzedJplGEj2LbEF5cz9SezRxU0oDT6hguv
         bIaQ==
X-Gm-Message-State: AOAM532iJi4G7v6tqhlBJYb0MNTngDrV/XqtjBhCmCCvUWFs69g1lLuK
        gEwXgopAk5xbKHQ2wl5kgNT2zkT+C9lb5/SsTmW4AA==
X-Google-Smtp-Source: ABdhPJxVy6FgKQgiwDbcajisI+cryeaKQbx6Bp/0sq0F7ILX2/ChyP3eGOieS+1wfca8VtaBeJelhvBHfhqzcbCaVkQ=
X-Received: by 2002:aca:bd41:0:b0:2ec:ff42:814f with SMTP id
 n62-20020acabd41000000b002ecff42814fmr6896182oif.63.1648252637219; Fri, 25
 Mar 2022 16:57:17 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 25 Mar 2022 18:57:16 -0500
MIME-Version: 1.0
In-Reply-To: <20220325220827.3719273-2-gwendal@chromium.org>
References: <20220325220827.3719273-1-gwendal@chromium.org> <20220325220827.3719273-2-gwendal@chromium.org>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date:   Fri, 25 Mar 2022 18:57:16 -0500
Message-ID: <CAE-0n52MOeHL8ZVrtiPPt+r+Jib0WrJJQ6Tmkqrdt-a=ZuE7FQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/8] iio: sx9324: Fix default precharge internal
 resistance register
To:     Gwendal Grignou <gwendal@chromium.org>, jic23@kernel.org,
        robh+dt@kernel.org
Cc:     linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Gwendal Grignou (2022-03-25 15:08:20)
> Fix the default value for the register that set the resistance:
> it has to be 0x10.
>
> Fixes: 4c18a890dff8d ("iio:proximity:sx9324: Add SX9324 support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> ---

I'd appreciate if you can carry forward tags next time. Then I know
where to focus on things that have changed.

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
