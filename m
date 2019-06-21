Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0754EE19
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 19:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfFURqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 13:46:48 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37295 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfFURqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 13:46:48 -0400
Received: by mail-qt1-f193.google.com with SMTP id y57so7793887qtk.4
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 10:46:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/rmiMLVq7kF2q2o6AKgSHjhv/l9ATXyCn/hQ4uzJmwg=;
        b=PzFuJKPNTeVjy12+CqQGyGCGyNnHdgXUdKfEKQ6JEW3xNkuhZOqhP3A63RjaVIyr5E
         HLOQbHhK1sWa9xpsXAl62zsIJAI72JIArV494r0IzaqU+dXbXRTWvQQblY6r27Glqba5
         5J5+HoYhqV9fDFGIJNRlg4xj2SRPcyzu5lDExrk3CZVbLtDWXj3Y5BqG5ZqbqK8rQC07
         sPytTTM1RdTUlHm164FazJ51mJ9HCh6x3R9mDnCcSTle0GfrS41rHGqYfyEonELXcKWh
         O6L9ag33xz1NExqyhls7mSq71mI51LP35BPFlZNe/eyzNF58uBruEW9hDPHbMDnN3mj5
         IKnw==
X-Gm-Message-State: APjAAAWuevliUZ/qRBgxyvhQHRag2X6KukORN3HGDIOfZ1ObQnPRJ4vK
        5dVeDt3NB/H5qwtVT/tphnBImw==
X-Google-Smtp-Source: APXvYqypVgeY2m60j16sgUDhAGhJwXgzSED6dHO7ab7CV6hNpq8x2x6XMkqgyoiCGRkVCJiwB3VaZQ==
X-Received: by 2002:ac8:38cf:: with SMTP id g15mr111973445qtc.268.1561139207526;
        Fri, 21 Jun 2019 10:46:47 -0700 (PDT)
Received: from [192.168.1.157] (pool-96-235-39-235.pitbpa.fios.verizon.net. [96.235.39.235])
        by smtp.gmail.com with ESMTPSA id k15sm1552422qtg.22.2019.06.21.10.46.46
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 10:46:46 -0700 (PDT)
Subject: Re: [PATCH] s390/jump_label: Use "jdd" constraint on gcc9
To:     Ilya Leoshkevich <iii@linux.ibm.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        stable <stable@vger.kernel.org>,
        Major Hayden <mhayden@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <99840513-9a7d-2c91-1e41-5355f88babcf@redhat.com>
 <20190621153912.9528-1-iii@linux.ibm.com>
From:   Laura Abbott <labbott@redhat.com>
Message-ID: <9210d2cc-8cca-208a-a1b4-5ccb49f4e3f8@redhat.com>
Date:   Fri, 21 Jun 2019 13:46:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190621153912.9528-1-iii@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/21/19 11:39 AM, Ilya Leoshkevich wrote:
>> Ah okay, I didn't realize there was more needed, I was just looking at
>> the clean cherry-pick. I'm not sure how to do the backport, if you
>> give me the patch I can verify.
> 
> Please find the cherry-picked 146448524bdd below.
> 
> I also had to cherry-pick 159491f3b509 to fix an unrelated compilation
> error and make the build fully work.
> 

Yes, this worked for me (plus 159491f3b509). Thanks!

> Best regards,
> Ilya
> 
> ----
> 
> [heiko.carstens@de.ibm.com]:
> -----
> Laura Abbott reported that the kernel doesn't build anymore with gcc 9,
> due to the "X" constraint. Ilya provided the gcc 9 patch "S/390:
> Introduce jdd constraint" which introduces the new "jdd" constraint
> which fixes this.
> -----
> 
> The support for section anchors on S/390 introduced in gcc9 has changed
> the behavior of "X" constraint, which can now produce register
> references. Since existing constraints, in particular, "i", do not fit
> the intended use case on S/390, the new machine-specific "jdd"
> constraint was introduced. This patch makes jump labels use "jdd"
> constraint when building with gcc9.
> 
> Reported-by: Laura Abbott <labbott@redhat.com>
> Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
>   arch/s390/include/asm/jump_label.h | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/include/asm/jump_label.h b/arch/s390/include/asm/jump_label.h
> index 40f651292aa7..9c7dc970e966 100644
> --- a/arch/s390/include/asm/jump_label.h
> +++ b/arch/s390/include/asm/jump_label.h
> @@ -10,6 +10,12 @@
>   #define JUMP_LABEL_NOP_SIZE 6
>   #define JUMP_LABEL_NOP_OFFSET 2
>   
> +#if __GNUC__ < 9
> +#define JUMP_LABEL_STATIC_KEY_CONSTRAINT "X"
> +#else
> +#define JUMP_LABEL_STATIC_KEY_CONSTRAINT "jdd"
> +#endif
> +
>   /*
>    * We use a brcl 0,2 instruction for jump labels at compile time so it
>    * can be easily distinguished from a hotpatch generated instruction.
> @@ -19,9 +25,9 @@ static __always_inline bool arch_static_branch(struct static_key *key, bool bran
>   	asm_volatile_goto("0:	brcl 0,"__stringify(JUMP_LABEL_NOP_OFFSET)"\n"
>   		".pushsection __jump_table, \"aw\"\n"
>   		".balign 8\n"
> -		".quad 0b, %l[label], %0\n"
> +		".quad 0b, %l[label], %0+%1\n"
>   		".popsection\n"
> -		: : "X" (&((char *)key)[branch]) : : label);
> +		: : JUMP_LABEL_STATIC_KEY_CONSTRAINT (key), "i" (branch) : : label);
>   
>   	return false;
>   label:
> @@ -33,9 +39,9 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key, bool
>   	asm_volatile_goto("0:	brcl 15, %l[label]\n"
>   		".pushsection __jump_table, \"aw\"\n"
>   		".balign 8\n"
> -		".quad 0b, %l[label], %0\n"
> +		".quad 0b, %l[label], %0+%1\n"
>   		".popsection\n"
> -		: : "X" (&((char *)key)[branch]) : : label);
> +		: : JUMP_LABEL_STATIC_KEY_CONSTRAINT (key), "i" (branch) : : label);
>   
>   	return false;
>   label:
> 

