Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413C9621AD2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 18:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbiKHRgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 12:36:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbiKHRgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 12:36:47 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCC7E0D3;
        Tue,  8 Nov 2022 09:36:46 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id f37so22210766lfv.8;
        Tue, 08 Nov 2022 09:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ts1OMTgoNQBYMD+LlN12Djk7W/xNrL3YKKYYOB6HHfU=;
        b=oMZarAvONxb46BGzHmx6Ftds5jVZs/0IlpNrzqN2aIuIBIX0rHmaPTw3YWoCtWlpne
         xKPwjrjO6WLLT6GW9n102QzFRaVaBH7/MW7NMH4vWca8w8NgBCJeqa2//ch38ih9e3E+
         1x9Ul4PC3zVGGxBBVRIq9RNFTsmsCkgljQz3mXJyXQ+sRjvGA4MMEZuI9nBHr1v1+w1/
         Tk//DoUg+JTmpDCdfWL/OmZ2fpplPZlfPURKUilddSVb73KqLciLSUsUHTPyF1imwDOs
         pFFC4ypI4V8fHF71xPXyM3xQ1EMQEnjBdPjNdz8MpASOrzKns3Ji2m8czg/DlXIBHNvd
         pkeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ts1OMTgoNQBYMD+LlN12Djk7W/xNrL3YKKYYOB6HHfU=;
        b=ViaAlympNpw6iKmNDF5J+OwtE1qMtWDxt/uRhvvFltfiUVTVLYH2ZapgmK8NBzyBgM
         pdKe9Jr9KmzYheUO04oMQpWZnuVMacK06hDnscfjSbe/b+fOasq9vD1to6yT0A8agVAq
         9RQisDytJpsE/DwwbvpL7hM+XVw0j0tUsAW/+kX7S1GG07K9DpLXNn8uL1X8fcbWBj7E
         wGET/rqCCAJkjFpbvDga2p43o9jrnDo0MEx990uHxY1K+WnRncOSpKw8At87yfCvR0OT
         CkBqYcPeM6/i12N35g5WKOM3UeSRqas54R5Q6akRQFxgJSvFFCKqeD0MGWbOqS0oF7IC
         1u4A==
X-Gm-Message-State: ACrzQf0x8u+Y74hEzLZTdl6npsD6/aDDZwUouVcxOxqJeud1Gusu7NJ3
        SeJ3YLXnnpT0H/8uRnjmccdVgt4owmWu1HAiWz4=
X-Google-Smtp-Source: AMsMyM4wCSMKG2RIOFdKFrTl8wWVUroLuDY6QCPiegdFrPHvEDnsCc82ltZEEZA7D4YtSeZlJAaylakxPp3PL4Wbaro=
X-Received: by 2002:a05:6512:1093:b0:4a2:a15a:3274 with SMTP id
 j19-20020a056512109300b004a2a15a3274mr18558654lfg.400.1667929004829; Tue, 08
 Nov 2022 09:36:44 -0800 (PST)
MIME-Version: 1.0
References: <Y2kxrerISWIxQsFO@nvidia.com> <20221108035232.87180-1-zhengqi.arch@bytedance.com>
In-Reply-To: <20221108035232.87180-1-zhengqi.arch@bytedance.com>
From:   Akinobu Mita <akinobu.mita@gmail.com>
Date:   Wed, 9 Nov 2022 02:36:32 +0900
Message-ID: <CAC5umygzc=H-9dCa_pLoqodS4Qz90OVmQkrvFOCPv27514tP3A@mail.gmail.com>
Subject: Re: [PATCH v2] mm: fix unexpected changes to {failslab|fail_page_alloc}.attr
To:     Qi Zheng <zhengqi.arch@bytedance.com>
Cc:     dvyukov@google.com, jgg@nvidia.com, willy@infradead.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

2022=E5=B9=B411=E6=9C=888=E6=97=A5(=E7=81=AB) 12:52 Qi Zheng <zhengqi.arch@=
bytedance.com>:
>
> When we specify __GFP_NOWARN, we only expect that no warnings
> will be issued for current caller. But in the __should_failslab()
> and __should_fail_alloc_page(), the local GFP flags alter the
> global {failslab|fail_page_alloc}.attr, which is persistent and
> shared by all tasks. This is not what we expected, let's fix it.
>
> Cc: stable@vger.kernel.org
> Fixes: 3f913fc5f974 ("mm: fix missing handler for __GFP_NOWARN")
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  v1: https://lore.kernel.org/lkml/20221107033109.59709-1-zhengqi.arch@byt=
edance.com/
>
>  Changelog in v1 -> v2:
>   - add comment for __should_failslab() and __should_fail_alloc_page()
>     (suggested by Jason)

Looks good.

Reviewed-by: Akinobu Mita <akinobu.mita@gmail.com>
