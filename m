Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6204E78AF4
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 13:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387672AbfG2Lzr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 07:55:47 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32854 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387482AbfG2Lzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 07:55:47 -0400
Received: by mail-pl1-f193.google.com with SMTP id c14so27364191plo.0
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 04:55:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=czQpOJ6NuB0rUDf29fzM6UP2/EP/3PAdN6JNsSVcd9E=;
        b=SKqUP1HnACYqd/z5Klcn8luKJZj9VIaiqYnPhM/yFVb26lQlu5aaO5cfbcpDxonlXp
         3sTvCuNq9sjnuzFAvkZ6c98VHSA8Hnd5HYi5XrSKwph8MN7kylrXTYmAt4860wJ4tLiH
         YCDRj/DginXLBID1iz0jOQPTrjOjerBfn+BU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=czQpOJ6NuB0rUDf29fzM6UP2/EP/3PAdN6JNsSVcd9E=;
        b=e4s9thltp2ppVP3jKnUKgqDQBrPldoM74MA9aydDpItdWFKfPuBzC78oFNPbKX/951
         ecorx32feDETVAua5aUN2y7KQFXW1fJTHqU72ihTi7y8fsr5UIHlML5rrqnluBgSoJME
         lOu3O4gBgUyUux7OVZSY9++QejrgTXSv8wXxKaI78eFmNNpiz2n0AjtZeaHFcfi2aCu6
         zyyvwa79ZfOGS7I4Q/rsql2TQXsDzNR1FThWeFNupiu5yNASDbNSE37hOiTPp2bHykpX
         j3MmU34ACynLRUD6Ka5CE1h0r4o4yR9z5B7Zndv4OpRg40HeJO0njKrnTuxZqCxzEY8W
         dv0w==
X-Gm-Message-State: APjAAAUjSItNuebkQkURVq1zog16wQOltXBuEC5SrycPz9mocjRqrOfk
        BD2w9iLzfOX7p7eCJGKgSzTcG/HovntzdvGiDCRqDw==
X-Google-Smtp-Source: APXvYqzntWCCVv2xWXoAwAcJGIukFyDTCIFmzHCDWxwPYM2wXpIyjfq3qWda2a1NuhbLbRx2/ziFluLy+Qv17uqV51I=
X-Received: by 2002:a17:902:2ae8:: with SMTP id j95mr100868250plb.276.1564401346581;
 Mon, 29 Jul 2019 04:55:46 -0700 (PDT)
MIME-Version: 1.0
References: <1564135257-33188-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <20190726142706.GA1734@infradead.org>
In-Reply-To: <20190726142706.GA1734@infradead.org>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Mon, 29 Jul 2019 17:25:35 +0530
Message-ID: <CAK=zhgrWW_vOkXKRYRbiMdHgiT7u=Ra_pCkO_HkmQrCdVXfJBQ@mail.gmail.com>
Subject: Re: [PATCH] mpt3sas: Use 63-bit DMA addressing on SAS35 HBA
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>, stable@vger.kernel.org,
        Sathya Prakash <Sathya.Prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 26, 2019 at 7:57 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Fri, Jul 26, 2019 at 06:00:57AM -0400, Suganath Prabu wrote:
> > Although SAS3 & SAS3.5 IT HBA controllers support
> > 64-bit DMA addressing, as per hardware design,
> > DMA address with all 64-bits set (0xFFFFFFFF-FFFFFFFF)
> > results in a firmware fault.
>
> Linux will never send a dma address with all bits set anyway, as that
> is our magic escape for the dma_addr_t error value.  Additionally to
> generate that address you'd need a 1-byte sized, 1-byte aligned buffer,
> which we never use.

I agree with your above statement. But it is also possible that
0xFFFFFFFF-FFFFFFFF falls under the DMA able range, e.g. SGE's start
address is 0xFFFFFFFF-FFFF000 and data length is 0x1000 bytes. So when
HBA tries to DMA the data at 0xFFFFFFFF-FFFFFFFF location then it will
faults the firmware due to it's hardware design.

We have observed above example's SGE address and length on AMD systems
with SME & IOMMU enabled.

Thanks,
Sreekanth
