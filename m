Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0FD433A55
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 23:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbfFCVyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 17:54:46 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40837 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfFCVyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 17:54:46 -0400
Received: by mail-pf1-f196.google.com with SMTP id u17so11367992pfn.7;
        Mon, 03 Jun 2019 14:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=oPgJE3SSPiX3rwzOACtwORs8x/gWd6/IDJ++GUP51Jg=;
        b=bfXkOXSfNVYnnh16yF2REmi7yZJCVii7QO2C8GoEfLF165QIfQP5OGhUup1x8cHoUQ
         Z3U/55H+nLoLRJuozE4ILyDjvOzbYQHgzbrpAVopIc7+buaraZZ21Z28FsHlExFQlfkN
         XgpCGT5Ox6f7MpKZe9/h7cZ3NzHXfyoR6DF0pr8vX8ft8Tj//aOFG7kdQp2WvWn3fnEn
         g9tfN2xrfjyABTyJyR5oWGumZvvAEklIf8BSUyahMMAA4izG5/ivi1excyBsqCDjA4VO
         k+Bkk7//oHXdv2bVq2VQVtjEvtB/QByvDZPDwvTJbu3NJUpZkMS+NpO2yW7VqVFemfXk
         kPFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oPgJE3SSPiX3rwzOACtwORs8x/gWd6/IDJ++GUP51Jg=;
        b=mtDIxp3Tr8ls/e0Ca1E8H9B7cqY9rpRv7rUFxjKe8h3gsrDh0jOlpqAqCIudgAuvfC
         qTef7HC2mBS+VUfijE+mXUmbUl9EyUZ+ft6Ky6lkN4jsHHnTHPEmTLpmT4LfrG8UOtWc
         YO9+K/7nm74QohKcg/22CCxj37rs3aNUuHYBxMeUHTYhnGEI2ETg2ekr5bIWoFQLp1dH
         iLhtOYLrLwPEZY0fglk3pz0t0+Q4zV40U7JaSFNP/uq24riDzDUdtOFqHELG5VVYOShN
         CVvYPMooQeiEE8lDWHtNDWkhdGd4IsTU9sHpV+4007TpJqXtFq2mKXBGIFljgev+JnDa
         Zl0w==
X-Gm-Message-State: APjAAAXqtGwyY2t25KwGxHCuCcWi7/Xw012GDGycV+fl3o6wOx100l3W
        bmVBk9j4qw6xu1CZyNThnuU=
X-Google-Smtp-Source: APXvYqyeipUplPNCoCJXUVB7Wx50wgvCiYlk9Y54A9DE4CDmrWG2qKZIezaeu1pnxMHa/u7BIZ+HvA==
X-Received: by 2002:a17:90a:204a:: with SMTP id n68mr32638862pjc.21.1559597157690;
        Mon, 03 Jun 2019 14:25:57 -0700 (PDT)
Received: from ?IPv6:2001:df0:0:200c:802d:b772:7767:bf29? ([2001:df0:0:200c:802d:b772:7767:bf29])
        by smtp.gmail.com with ESMTPSA id j186sm13739673pfg.66.2019.06.03.14.25.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 14:25:56 -0700 (PDT)
Subject: Re: [PATCH 5/7] scsi: mac_scsi: Fix pseudo DMA implementation, take 2
To:     Finn Thain <fthain@telegraphics.com.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
References: <cover.1559438652.git.fthain@telegraphics.com.au>
 <c56deeb735545c7942607a93f017bb536f581ae5.1559438652.git.fthain@telegraphics.com.au>
 <CAMuHMdWxRtJU2aRQQjXzR2mvpfpDezCVu42Eo1eXDsQaPb+j6Q@mail.gmail.com>
 <alpine.LNX.2.21.1906030903510.20@nippy.intranet>
 <CAMuHMdUFxQnmJmkr2qm4waTfFA5yfCHAFngyD37cFH6gbbD-Pg@mail.gmail.com>
 <alpine.LNX.2.21.1906031702220.37@nippy.intranet>
From:   Michael Schmitz <schmitzmic@gmail.com>
Message-ID: <247ed79a-75c7-41fd-0932-0b7701ee5d4e@gmail.com>
Date:   Tue, 4 Jun 2019 09:25:49 +1200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.21.1906031702220.37@nippy.intranet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Finn,

On 3/06/19 7:40 PM, Finn Thain wrote:
>
>> There are several other drivers that contain pieces of assembler code.
>>
> Does any driver contain assembler code for multiple architectures? I was
> trying to avoid that -- though admittedly I don't yet have actual code for
> the PDMA implementation for mac_scsi for Nubus PowerMacs.
>
I've seen that once, for one of the ESP drivers that were supported on 
both m68k and ppc (APUS, PPC upgrade to Amiga computers). But that 
driver was removed long ago (after 2.6?).

In that case, the assembly file did reside in drivers/scsi/. That still 
appears to be current practice (see drivers/scsi/arm/acornscsi-io.S).

Cheers,

     Michael


