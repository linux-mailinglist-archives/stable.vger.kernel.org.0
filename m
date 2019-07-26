Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B387B76B0F
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfGZOHm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 10:07:42 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44158 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfGZOHl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 10:07:41 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so53365113edr.11;
        Fri, 26 Jul 2019 07:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=zWt0jo8AMAZchPeNnT8VtD1Yz35B0VOWcsrzm+hetHc=;
        b=EBcVkDbkQNLVIGiixEGt7/effrRULBIFCXd9TZAffqJ0lq9fLauFVglwd8b2bkfIyN
         BC2KTJ0r7uFjeAiEasWUgU6aWedhVoGCjUdR79nMIVUDf9eRmgNeFHwfIhnG2q+vPRj7
         KHU9aOnIUcaakS3x7UtUstN8BEHp6jrdVJM3xQiElzojceQJjqShcUo3suIS3TZKEIa/
         q+wCSwmyLhAMXWit89VHrabrdm0z8JodaAn4xOccgKrSmNSXuwY7DZP8cbK9m5UDEhTA
         TbTSj64wO85eM1pq276rMeD9A4c5mKU+DVMlfW5NOSsvxIMd+TxOHofzx8wrdUuqQLLM
         3rVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=zWt0jo8AMAZchPeNnT8VtD1Yz35B0VOWcsrzm+hetHc=;
        b=EPCg97zCZQzhPo/OjPa05yATVxc7UIb71QPZXrojpMtn5sQHgL8qIpvlOHmathyFvE
         azhRQ0ePt5HQsxOPZgYf8lZAp+mChZ3gptS1eoMIlmP/M92N9vNYuETYerEFyQEJMtlY
         RiTrOBnyHgvGbyntegfOrjGdxvoswFMO5ky9tzxEybw4+7thrUcWjIoNNTCVM0GuyQEJ
         Wz7KT0HcjazfNegtHhs3Sl6nJWc9gWjWK5dL6BA/gGlSwgaUHtEegsHtGAnPEeXSXbrd
         dxU+NxC5kh6vOb7MMZJfjuqQvsNHqFYrTXsFFTqjDXchKUvI8V6pajcoJ2lnX2YFwAAQ
         sunQ==
X-Gm-Message-State: APjAAAVOOj8inEfFoJU2Ea3SEVxhPHg09lg2KwpHzjVDSEFtpX8FvLOj
        Chmb04qGoQ7ZqP369tTQoVmZ4r2e3raCotLwVMg=
X-Google-Smtp-Source: APXvYqziAi2Y22ozLNyzPYiFdK2PgVBXM4KosDiTc3Nx+FjBq2NUFXjGLKY6H8bA/5mLr0Sx4XUxvkaoFm5l8HHo1CM=
X-Received: by 2002:a50:8b9d:: with SMTP id m29mr82832052edm.248.1564150059833;
 Fri, 26 Jul 2019 07:07:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:b3b9:0:0:0:0:0 with HTTP; Fri, 26 Jul 2019 07:07:39
 -0700 (PDT)
In-Reply-To: <20190726110135.GO31381@hirez.programming.kicks-ass.net>
References: <20190724191655.268628197@linuxfoundation.org> <20190724191701.954991110@linuxfoundation.org>
 <5D3AD35E.FB77B44F@gmail.com> <20190726110135.GO31381@hirez.programming.kicks-ass.net>
From:   Jari Ruusu <jari.ruusu@gmail.com>
Date:   Fri, 26 Jul 2019 17:07:39 +0300
Message-ID: <CACMCwJJm++=x0EOXYMvFvybE63rmHEq6f96ahfYUA83wGGHHLw@mail.gmail.com>
Subject: Re: [PATCH 4.19 079/271] x86/atomic: Fix smp_mb__{before,after}_atomic()
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/19, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jul 26, 2019 at 01:18:06PM +0300, Jari Ruusu wrote:
>> Shouldn't those clobber contraints actually be:  "memory","cc"
>> That is because addl subl (and other) machine instructions
>> actually modify the flags register too.
>>
>> gcc docs say: The "cc" clobber indicates that the assembler
>> code modifies the flags register.
>
> GCC x86 assumes any asm() will clobber "cc".

No worries then. Thanks for your clarification.

-- 
Jari Ruusu  4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD  ACDF F073 3C80 8132 F189
