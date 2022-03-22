Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44984E3931
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 07:54:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbiCVGwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 02:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237045AbiCVGwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 02:52:11 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FEC13CF3
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 23:50:43 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id y3-20020a056830070300b005cd9c4d03feso1116910ots.3
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 23:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:from:user-agent:date:message-id
         :subject:to:cc;
        bh=4dUdFBYGFHqdvIymHkW7uWgJF3CbepMSQD8M94HghbI=;
        b=Bof3EO7aw8OA5pwZ5yxVnP++vbPHCQ1bdfbCS5RmQRKgTvkOHuLAtn3kQMPM7dFEAw
         oU+zD1O71Vnye2indO40KaojnXRAukYViQsVWZn0fGdDWnwEpF7API/QJ+sQdrs87osK
         bGB4DiF25bkduxrnKXZiMG9q3dZsXlPeWIU5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:in-reply-to:references:from
         :user-agent:date:message-id:subject:to:cc;
        bh=4dUdFBYGFHqdvIymHkW7uWgJF3CbepMSQD8M94HghbI=;
        b=0PbViDwCHe8N+I+HXAph1NX1CvOkPjhyKAcK4qSp/7lBie/xbke2v95ex8RP8hhKAS
         YHkiS6kVJ107ny4yPYikfkvK1Nyy/ZO4e9llI42+68VlokNNGwpU9TX5mFSbgn3HpGXA
         PCK93cQG1HVIo5dfHYwsQIqmmD9ECoYiw0pl+Rmk4xmtdq7wj4339PjnnYBftZx6EYcD
         N6weK7l+Q+XKSGI9CdXa5x5xrFA7QehoDEaRhTGdDOoYEldLGcaPm+P6IV8gWM6h5x5k
         rYlUK7ne9+JgFCrM8MOCISXa0PihAS38Dymk/fuLvp6/na+j536gJeF1BElQgefXuRbk
         Z2VQ==
X-Gm-Message-State: AOAM5336STz/XDOsKDoA3jwSPvT6FiDoY6ceIINFjUnHK+bymLHfHCEf
        sR3OMHcNeZOMNDTPxCT65aStgKK6ZflBBnMxdwsYLA==
X-Google-Smtp-Source: ABdhPJy+33iIcLPWvfYNbGLs+Fm01g7tBW+Guhoo6T8iHpmzNhPV1FTBYUb8XV3ozRiO5xv03OfRd1FikjljDwHyhqM=
X-Received: by 2002:a05:6830:61b:b0:5cc:e44:7dc3 with SMTP id
 w27-20020a056830061b00b005cc0e447dc3mr4838467oti.159.1647931842453; Mon, 21
 Mar 2022 23:50:42 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 22 Mar 2022 07:50:42 +0100
MIME-Version: 1.0
In-Reply-To: <20220322062504.1019504-2-gwendal@chromium.org>
References: <20220322062504.1019504-1-gwendal@chromium.org> <20220322062504.1019504-2-gwendal@chromium.org>
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date:   Tue, 22 Mar 2022 07:50:42 +0100
Message-ID: <CAE-0n510fc3AUYXSS376C90T87FHpuTRZOt79roEjbnToCG4RQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/8] iio: sx9324: Fix default precharge internal
 resistance register
To:     Gwendal Grignou <gwendal@chromium.org>, jic23@kernel.org,
        robh+dt@kernel.org
Cc:     linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Gwendal Grignou (2022-03-21 23:24:57)
> Fix the default value for the register that set the resistance:
> it has to be 0x10.
>
> Fixes: 4c18a890dff8d ("iio:proximity:sx9324: Add SX9324 support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
> ---

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
