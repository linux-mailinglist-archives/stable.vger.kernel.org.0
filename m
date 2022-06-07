Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB7E54021A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240705AbiFGPHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 11:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343850AbiFGPHC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 11:07:02 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7DC4F688D
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 08:07:00 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id o10so23391588edi.1
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 08:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0BaNCtbUy4qoGqaDj8cYNuEZlzINYHGxowSAoBkW/n4=;
        b=DMEwSRpb8kC8xuRVVV7/kHRA/G87E32QbqXN5WzgEfmN3wN+2t7FxY9gibvt2Q3K2n
         e7oiV7BuSHU1ztk6uRd/3ioUYsdni6X4OAT+zCk8pSDcBT+vdGC3sEEJuKREW4/4+37h
         0PzY1LACKakPrZvxSoob9NhmBsTTpIMV093Q0cmbnATQvRd6P2qRDw/jgxX48RUyPnW2
         Z6BLX8I1qh57Fw8kO+l+ZVFBkEax0gi1bbIbXgdFhx4Ve3DKXn5OLv4Q+BpGzQTW4EOX
         jXflMjQnf2JXo9OtPzh7WZbf5Kko0qpRnXFXzmFnpdJ9CUesCblDWfyRiTcPlGa4QXse
         nv1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0BaNCtbUy4qoGqaDj8cYNuEZlzINYHGxowSAoBkW/n4=;
        b=RmIudergvHn9hn0P8C1/r14rpQltmKy1LGoTrjW/Y+JBm1etiv3/SI84rjfTtjCBwR
         J0Zy2KQTkmJFFybYfDkjPeB/KMn6v/HDaDwoi5o+uOlCbAEqwEi6IzKjz+ynGsPT2izm
         uIT+OBI9zNE3Z3vSkiGptJGN29BHDCpCQQjsarnPyLfrxKitDs1U7YgvQadw8U6uO+XH
         F6v5jX8a5yJWC5T8XDEin9pjB51MHdkvpfOn1ecD3N+nF7m6+Fesq6UyjFt0zaiKV28g
         fwQtcR8ekMqkUcy9dAjfzsFObZQywiYCmUcDtJJ1PYKNz334I/snJUyj4K9stDGOQzLO
         JRWQ==
X-Gm-Message-State: AOAM533y5YPoQ4OVhz1fFfv6oUivp1aXD3qMED5KfEn4j17oMxSt8e6T
        KKE6yeyabTQOT/vES21+2CyXa7g1X3YvlACB/qQanA==
X-Google-Smtp-Source: ABdhPJylsWC5i4PgBn7ERQ2wQMm5YBzFNyAS+31DkGotw3HxNaQ5WeBcN28rPFZfemsY/5Yie8NGJLBRPR3TU0T/KXE=
X-Received: by 2002:aa7:c84d:0:b0:431:4226:70c9 with SMTP id
 g13-20020aa7c84d000000b00431422670c9mr17193548edt.51.1654614412623; Tue, 07
 Jun 2022 08:06:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220607025729.1673212-1-mfaltesek@google.com> <20220607025729.1673212-2-mfaltesek@google.com>
In-Reply-To: <20220607025729.1673212-2-mfaltesek@google.com>
From:   Guenter Roeck <groeck@google.com>
Date:   Tue, 7 Jun 2022 08:06:41 -0700
Message-ID: <CABXOdTdeyykMamUoXR+XPCc6jds1419z1Qdu0zw8mcuU0H0Siw@mail.gmail.com>
Subject: Re: [PATCH net v3 1/3] nfc: st21nfca: fix incorrect validating logic
 in EVT_TRANSACTION
To:     Martin Faltesek <mfaltesek@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, krzysztof.kozlowski@linaro.org,
        christophe.ricard@gmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jordy@pwning.systems, Krzysztof Kozlowski <krzk@kernel.org>,
        martin.faltesek@gmail.com, netdev <netdev@vger.kernel.org>,
        linux-nfc@lists.01.org, sameo@linux.intel.com,
        William K Lin <wklin@google.com>, theflamefire89@gmail.com,
        "# v4 . 10+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 6, 2022 at 7:57 PM Martin Faltesek <mfaltesek@google.com> wrote:
>
> The first validation check for EVT_TRANSACTION has two different checks
> tied together with logical AND. One is a check for minimum packet length,
> and the other is for a valid aid_tag. If either condition is true (fails),
> then an error should be triggered.  The fix is to change && to ||.
>
> Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Martin Faltesek <mfaltesek@google.com>

Reviewed-by: Guenter Roeck <groeck@chromium.org>

> ---
>  drivers/nfc/st21nfca/se.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
> index 7e213f8ddc98..9645777f2544 100644
> --- a/drivers/nfc/st21nfca/se.c
> +++ b/drivers/nfc/st21nfca/se.c
> @@ -315,7 +315,7 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
>                  * AID          81      5 to 16
>                  * PARAMETERS   82      0 to 255
>                  */
> -               if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
> +               if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
>                     skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
>                         return -EPROTO;
>
> --
> 2.36.1.255.ge46751e96f-goog
>
