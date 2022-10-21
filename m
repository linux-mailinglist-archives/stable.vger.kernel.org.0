Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECFBE6081A4
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 00:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbiJUWbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 18:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJUWbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 18:31:36 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DC12ACBC4
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 15:31:35 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id t16so2775084qvm.9
        for <stable@vger.kernel.org>; Fri, 21 Oct 2022 15:31:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3ccSmoVfXZFlZPMpL3j8vyHNh3nUVZ/QEZFkZGGqx8U=;
        b=hnFW3lYNV8PHMskIXZ0zmTYSaca6XpmVBhXFGiqQkL2O9ZaRVxVKrsuGxuiDhrDgwq
         sI3y3l8ZprxvJ1R+onhhmBarULX9Ac9mC3VuPcODZACJwSMyvsgZuEZSzuToXLOz7XGz
         pU6O48ohijSq43DRHkCByYGLLUGIVsOAwM2lxiHA0l2+3uzD33XWZqYZVpLLfVw1A7IZ
         YXqdH7FiYG5u+I3yIXCjb8JE5aqI1K2rwctkpjK/lcrG+9UAtORiGxx99dvrc8m0IXMq
         FOee02d55kzVz5vuZZQS4HCb4bdpcNIzO4UwMYW737Ux1CT3GH+/o5KKX/+FgsRy67aM
         iYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3ccSmoVfXZFlZPMpL3j8vyHNh3nUVZ/QEZFkZGGqx8U=;
        b=WB1g6An/Fh/WhuWkIVJOdWhRt9h0wTJeJ9tA00eKJgowuKBDG8WSs/lextkDIieNaD
         AUYTLnq3/KpV0dMgHcp20IlttMSv8IZKLo/qNdWHAVuZXh18ZmcU9mquaTSJ6gnzI4F6
         CjeAQ+sktGa8cUgLsIegakqocpUX4X732ShDJueEiiQjyuS7ywdaofLLT+Ye+ohpD6Sz
         G0GVqafOgyJ7VfHwBR0bepQYrxsp0JiCArjZ829sFn00PyVUvL+mz49oggtNfKSAynK4
         NTlhjSqrDxLZxWabz0OPAwQx+WJVCcTRus8eqbr7icEggZMGcs+LaSWTMX0sYjGInXQ3
         qRDw==
X-Gm-Message-State: ACrzQf1dMOuBGrkZQCOoSKUZBjgookJ7gsncXFJPgmnMwII6uuFyZF+t
        2DGSY6xwTBTyvwVDkRKCQRUVFe/pB8SoLtvtB+Y/5ieHq2zLtQ==
X-Google-Smtp-Source: AMsMyM6Hz0NCts1cNUPVTeQFXHPIOpnJuYAHxd9Q8xdfq3rrmFvuhI9DTdQs90nBBSsQggRe08oSVIbeZn+PzN6aHNc=
X-Received: by 2002:a05:6102:3172:b0:3a7:319c:ffef with SMTP id
 l18-20020a056102317200b003a7319cffefmr16137927vsm.80.1666391483841; Fri, 21
 Oct 2022 15:31:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAFKCwrhcszDEzW8S2Y_aCZW2o5H6S=Z-Ao1ASpzPw3ZOm9UAtw@mail.gmail.com>
 <Y1KrUDvIf30wAcUC@kroah.com>
In-Reply-To: <Y1KrUDvIf30wAcUC@kroah.com>
From:   Evgenii Stepanov <eugenis@google.com>
Date:   Fri, 21 Oct 2022 15:31:12 -0700
Message-ID: <CAFKCwrjV_gtyqoCSGOm3kNzmFoq+_UvtL9f0c_Vv9iauFzYzWA@mail.gmail.com>
Subject: Re: backport of arm64: mte: move register initialization to C
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Peter Collingbourne <pcc@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 21, 2022 at 7:23 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > Please note that the extra backport below can be avoided with a
> > trivial change in the above patch. Let me know if that's preferable.
> >
> > Cc: <stable@vger.kernel.org> # 5.15.y: e921da6: arm64/mm: Consolidate
> > TCR_EL1 fields
> > Signed-off-by: Evgenii Stepanov <eugenis@google.com>
>
> Yes, please provide a working backport.

Thanks! I've sent a backport for "arm64/mm: Consolidate TCR_EL1 fields".
