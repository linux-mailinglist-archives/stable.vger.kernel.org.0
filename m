Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF766D4A0C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbjDCOno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbjDCOng (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:43:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3328D280ED
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680532944;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K+EPWgU2x5V4hfg46aLK3WZjBP8GTm1fIwNbw6N/r0w=;
        b=A+ls6enq87T/JavQCoKqnUn3U5dBSbmRHIm8tnbXpuWRr3AkctWrenQKYAP4hNuIu/DcNW
        AKnNavOFb1alIYOH7eEff0oNsLkes3GI+m4tpL5OXDU9MwKgYh9F1IylRkAHliBgINtbQm
        3sNimNYAfcvsjrC5DDDLwCog3DMOcY4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-HcZVqk0iN06tvnzLG2XdLA-1; Mon, 03 Apr 2023 10:42:19 -0400
X-MC-Unique: HcZVqk0iN06tvnzLG2XdLA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7598E884EC5;
        Mon,  3 Apr 2023 14:42:18 +0000 (UTC)
Received: from rotkaeppchen (unknown [10.39.192.158])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 09E7C492C13;
        Mon,  3 Apr 2023 14:42:16 +0000 (UTC)
Date:   Mon, 3 Apr 2023 16:42:13 +0200
From:   Philipp Rudo <prudo@redhat.com>
To:     Ricardo Ribalda <ribalda@chromium.org>
Cc:     Eric Biederman <ebiederm@xmission.com>,
        Baoquan He <bhe@redhat.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Simon Horman <horms@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v5 1/2] kexec: Support purgatories with .text.hot
 sections
Message-ID: <20230403164213.108093ec@rotkaeppchen>
In-Reply-To: <20230321-kexec_clang16-v5-1-5563bf7c4173@chromium.org>
References: <20230321-kexec_clang16-v5-0-5563bf7c4173@chromium.org>
        <20230321-kexec_clang16-v5-1-5563bf7c4173@chromium.org>
Organization: Red Hat inc.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ricardo,

On Thu, 30 Mar 2023 11:44:47 +0200
Ricardo Ribalda <ribalda@chromium.org> wrote:

> Clang16 links the purgatory text in two sections:
> 
>   [ 1] .text             PROGBITS         0000000000000000  00000040
>        00000000000011a1  0000000000000000  AX       0     0     16
>   [ 2] .rela.text        RELA             0000000000000000  00003498
>        0000000000000648  0000000000000018   I      24     1     8
>   ...
>   [17] .text.hot.        PROGBITS         0000000000000000  00003220
>        000000000000020b  0000000000000000  AX       0     0     1
>   [18] .rela.text.hot.   RELA             0000000000000000  00004428
>        0000000000000078  0000000000000018   I      24    17     8
> 
> And both of them have their range [sh_addr ... sh_addr+sh_size] on the
> area pointed by `e_entry`.
> 
> This causes that image->start is calculated twice, once for .text and
> another time for .text.hot. The second calculation leaves image->start
> in a random location.
> 
> Because of this, the system crashes immediately after:
> 
> kexec_core: Starting new kernel
> 
> Cc: stable@vger.kernel.org
> Fixes: 930457057abe ("kernel/kexec_file.c: split up __kexec_load_puragory")
> Reviewed-by: Ross Zwisler <zwisler@google.com>
> Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
> ---
>  kernel/kexec_file.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
> index f1a0e4e3fb5c..c7a0e51a6d87 100644
> --- a/kernel/kexec_file.c
> +++ b/kernel/kexec_file.c
> @@ -901,10 +901,22 @@ static int kexec_purgatory_setup_sechdrs(struct purgatory_info *pi,
>  		}
>  
>  		offset = ALIGN(offset, align);
> +
> +		/*
> +		 * Check if the segment contains the entry point, if so,
> +		 * calculate the value of image->start based on it.
> +		 * If the compiler has produced more than one .text section
> +		 * (Eg: .text.hot), they are generally after the main .text
> +		 * section, and they shall not be used to calculate
> +		 * image->start. So do not re-calculate image->start if it
> +		 * is not set to the initial value, and warn the user so they
> +		 * have a chance to fix their purgatory's linker script.
> +		 */
>  		if (sechdrs[i].sh_flags & SHF_EXECINSTR &&
>  		    pi->ehdr->e_entry >= sechdrs[i].sh_addr &&
>  		    pi->ehdr->e_entry < (sechdrs[i].sh_addr
> -					 + sechdrs[i].sh_size)) {
> +					 + sechdrs[i].sh_size) &&
> +		    !WARN_ON(kbuf->image->start != pi->ehdr->e_entry)) {

Looks good to me. I'm not sure if it is better to use WARN_ON_ONCE to
avoid spamming the log when there are more than two .text sections or
when you reload the kernel. But that's only a rare corner case. So no
strong opinion from my side. Either way 

Reviewed-by: Philipp Rudo <prudo@redhat.com>

>  			kbuf->image->start -= sechdrs[i].sh_addr;
>  			kbuf->image->start += kbuf->mem + offset;
>  		}
> 

