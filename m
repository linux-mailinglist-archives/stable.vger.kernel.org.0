Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C36A73CBAD6
	for <lists+stable@lfdr.de>; Fri, 16 Jul 2021 18:58:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbhGPRBT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Jul 2021 13:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhGPRBQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Jul 2021 13:01:16 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42FEC06175F
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 09:58:20 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id s23so11668010oij.0
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 09:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zF6RFynJImZVZ9iauRKVrADk1+eSALtVWbPASLHhoSw=;
        b=CYfZq/00WLjjWY1y5nRSBmHv2gLKV/HPnda9tFP2NnVUU0Wmm+FGSaRVjx7ugR8Wu8
         gVqOAn49/fcLFt2j5zQor/oTx+Jc8rdVjMNfSyuGOUUPuFt7FC/Ok1UjIuCgrVE4R1wQ
         g97bIBeGzSYqzNZwtdBTzPpYJlV55FMfIxS5Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zF6RFynJImZVZ9iauRKVrADk1+eSALtVWbPASLHhoSw=;
        b=Dx1jtGDpXWNtDw5XI8Hl9Ue4ziTsvwBTiqCyYPq47/BGCYaF2v5pUJthaAydT3WqQh
         15+1RJe/76ut7OMDOte0V7BfqYW8Hy9ihX14NOCy6H7XJHfI58Rxmk+gMuetwx00UMOV
         js+tHnTPNt2RLxZNOq3QFJxLwNCMxxubEjux5mhjdDPIlz9wkSItiPxlovf14w6W+k1K
         4ytoIR7UK99MglPrTFwwAWACB61ixyrgSWbrkE8qDgCIaSJMLgxudLUXYENVQx2oDM3T
         ErYdJ5c9lgQtt7xCW2GOIQJUm+9+C32ccpzto+zcrcZh1ctzFndAq3NNd7fmE5QexZFZ
         sPAQ==
X-Gm-Message-State: AOAM532+oNoEWj0eVjPII0RtOlXbtXizBlo0g4ArQPGQVW9kKCM0QAub
        ztTiWfqv4I38nK9ZFBnZA6jYAjhlhSloqw==
X-Google-Smtp-Source: ABdhPJxKP+Ch3usQGQ0fkwQThdP0TY1QQ+jhsAWa8Q0TrdaGtOdkENi5T5Xx/NDIjGpGWYBh0OJ7YA==
X-Received: by 2002:aca:e107:: with SMTP id y7mr13162862oig.11.1626454699490;
        Fri, 16 Jul 2021 09:58:19 -0700 (PDT)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com. [209.85.167.170])
        by smtp.gmail.com with ESMTPSA id o129sm2156936oif.21.2021.07.16.09.58.18
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 09:58:18 -0700 (PDT)
Received: by mail-oi1-f170.google.com with SMTP id u15so11626720oiw.3
        for <stable@vger.kernel.org>; Fri, 16 Jul 2021 09:58:18 -0700 (PDT)
X-Received: by 2002:aca:304f:: with SMTP id w76mr11034037oiw.77.1626454698098;
 Fri, 16 Jul 2021 09:58:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210716155311.5570-1-len.baker@gmx.com>
In-Reply-To: <20210716155311.5570-1-len.baker@gmx.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 16 Jul 2021 09:58:07 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPSL4bFpyjRYGEOG=Df8dOXc19LYBO06wdFN_k8OkiwKQ@mail.gmail.com>
Message-ID: <CA+ASDXPSL4bFpyjRYGEOG=Df8dOXc19LYBO06wdFN_k8OkiwKQ@mail.gmail.com>
Subject: Re: [PATCH v2] rtw88: Fix out-of-bounds write
To:     Len Baker <len.baker@gmx.com>
Cc:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Pkshih <pkshih@realtek.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 8:54 AM Len Baker <len.baker@gmx.com> wrote:
>
> In the rtw_pci_init_rx_ring function the "if (len > TRX_BD_IDX_MASK)"
> statement guarantees that len is less than or equal to GENMASK(11, 0) or
> in other words that len is less than or equal to 4095. However the
> rx_ring->buf has a size of RTK_MAX_RX_DESC_NUM (defined as 512). This
> way it is possible an out-of-bounds write in the for statement due to
> the i variable can exceed the rx_ring->buff size.
>
> However, this overflow never happens due to the rtw_pci_init_rx_ring is
> only ever called with a fixed constant of RTK_MAX_RX_DESC_NUM. But it is
> better to be defensive in this case and add a new check to avoid
> overflows if this function is called in a future with a value greater
> than 512.
>
> Cc: stable@vger.kernel.org

This kinda seems excessive, considering we absolutely know this is not
currently a bug. But then, LWN nicely highlighted this thread, which
reminds me that even without the Cc stable, this is likely to
unnecessarily get picked up:

https://lwn.net/ml/linux-kernel/YO0zXVX9Bx9QZCTs@kroah.com/

And I guess silencing Coverity is a desirable goal in many cases, even
if Coverity is being a bit trigger-happy.

So, *shrug*.

> Addresses-Coverity-ID: 1461515 ("Out-of-bounds write")
> Fixes: e3037485c68ec ("rtw88: new Realtek 802.11ac driver")
> Signed-off-by: Len Baker <len.baker@gmx.com>
> ---
> Changelog v1 -> v2
> - Remove the macro ARRAY_SIZE from the for loop (Pkshih, Brian Norris).
> - Add a new check for the len variable (Pkshih, Brian Norris).

Reviewed-by: Brian Norris <briannorris@chromium.org>

Thanks.
