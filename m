Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0B3A8F5BA
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 22:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfHOU0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 16:26:05 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42493 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbfHOU0E (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 16:26:04 -0400
Received: by mail-lf1-f66.google.com with SMTP id s19so2494101lfb.9
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 13:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OMu2C04ftY81TYFCnc8lXX04zGDDGOcRI0zFGGiMOC0=;
        b=lKumc5s3VZUto1TE0iTCoHL9TAw+ySrWt4qf38RzqlZOcyiAiHQ3yabZ1IX6Mb/ilK
         vdH98kxp4z3xxBRqOFO8Ligh5CG7U1ddsStwqBCkgBoU+bv4ICOpIWoQMyOEo5D1l7A/
         wdiZ49xHK3w2p3ZZSJivn2hJZ/j+dfn10VKHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OMu2C04ftY81TYFCnc8lXX04zGDDGOcRI0zFGGiMOC0=;
        b=d4aWrSPiNNFQeSSntWU/t8WVPTaE188hKlUHwSnLZxw4QHEUOPqtJn2yAjlaCTobIa
         2Jc2AX9icL+hwfHK3UaT9SDCB/FQdS2caS0GsPLs5vSV2ME69L9bKniXV6Nly+LvWXqz
         yfgDRsbGnVL+P976rZgfVkKds6SC5JeAIsuvYccVjec9x7TGvgWZPfZw1F13AG78udw4
         +MakPc9SEvQepUS+1slPvemiTiZAxNHoiXSnzdYCIdCk8LBVgO0Iqc6Gj7+aLs0uab16
         lRNQUO93zrV/kBb+Q6rlk5pdz0d8DU2D00TpbvTBjmzNZMspipsXIn4nlB7NdRLtSbVG
         UeEQ==
X-Gm-Message-State: APjAAAUlWzEmGnO+7sWYFH7jKKYieZFevUCK7efxRI64J5HXdr/zHhq4
        iBVWXOHqiTx42TKz1wjftIpPknQH300=
X-Google-Smtp-Source: APXvYqxil/x0yKrWGFUC9H/hrceGbQsS7XOg6ExWDPEpiikmVXIxnYkqj4CHmLyaVUTVYNwWLI3qyg==
X-Received: by 2002:a05:6512:4c8:: with SMTP id w8mr3239094lfq.98.1565900761560;
        Thu, 15 Aug 2019 13:26:01 -0700 (PDT)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com. [209.85.167.51])
        by smtp.gmail.com with ESMTPSA id u24sm597576lfc.35.2019.08.15.13.25.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 13:25:58 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id c9so2519498lfh.4
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 13:25:58 -0700 (PDT)
X-Received: by 2002:a19:ed11:: with SMTP id y17mr3283567lfy.141.1565900757828;
 Thu, 15 Aug 2019 13:25:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190709161550.GA8703@infradead.org> <20190710083825.7115-1-jian-hong@endlessm.com>
In-Reply-To: <20190710083825.7115-1-jian-hong@endlessm.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Thu, 15 Aug 2019 13:25:46 -0700
X-Gmail-Original-Message-ID: <CA+ASDXOgCHzAfyQDAGhkFZMO4UaXfrnpkN9a95jzfQY_L+EbAg@mail.gmail.com>
Message-ID: <CA+ASDXOgCHzAfyQDAGhkFZMO4UaXfrnpkN9a95jzfQY_L+EbAg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] rtw88: pci: Rearrange the memory usage for skb in
 RX ISR
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux@endlessm.com, Daniel Drake <drake@endlessm.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

I realize this already is merged, and it had some previous review
comments that led to the decisions in this patch, but I'd still like
to ask here, where I think I'm reaching the relevant parties:

On Wed, Jul 10, 2019 at 1:43 AM Jian-Hong Pan <jian-hong@endlessm.com> wrote:
...
> This patch allocates a new, data-sized skb first in RX ISR. After
> copying the data in, we pass it to the upper layers. However, if skb
> allocation fails, we effectively drop the frame. In both cases, the
> original, full size ring skb is reused.
>
> In addition, by fixing the kernel crash, the RX routine should now
> generally behave better under low memory conditions.
>
> Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=204053
> Signed-off-by: Jian-Hong Pan <jian-hong@endlessm.com>
> Cc: <stable@vger.kernel.org>
> ---
> v2:
>  - Allocate new data-sized skb and put data into it, then pass it to
>    mac80211. Reuse the original skb in RX ring by DMA sync.

Is it really wise to force an extra memcpy() for *every* delivery?
Isn't there some other strategy that could be used to properly handle
low-memory scenarios while still passing the original buffer up to
higher layers most of the time? Or is it really so bad to keep
re-allocating RTK_PCI_RX_BUF_SIZE (>8KB) of contiguous memory, to
re-fill the RX ring? And if that is so bad, can we reduce the
requirement for contiguous memory instead? (e.g., keep with smaller
buffers, and perform aggregation / scatter-gather only for frames that
are really larger?)

Anyway, that's mostly a long-term thought, as this patch is good for
fixing the important memory errors, even if it's not necessarily the
ideal solution.

Regards,
Brian
