Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80E0665B095
	for <lists+stable@lfdr.de>; Mon,  2 Jan 2023 12:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbjABL0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Jan 2023 06:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232752AbjABLZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Jan 2023 06:25:37 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CA4657D;
        Mon,  2 Jan 2023 03:24:31 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DCF5D2256F;
        Mon,  2 Jan 2023 11:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1672658669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zBBA2nzNlNZSsvXhqPF5ZZXmCuwF1QaNQRQ7CORp228=;
        b=W+MNNtWOV2kZ3FIcdAAT9QOD4LZEnFG5CFXuF3hZd1Y1eVmqAAVMO/VRayl7Z+4qhhNfD8
        q4X09/cdkwSAp9J3g9lhmO3rJGO3qQDIkjOFrWxltxawKTAASUepMvFCJYXLXRoBQbG2lz
        7R1UOTRaB3ZRcf0gjxXn/kyrrBHAFU8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1672658669;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zBBA2nzNlNZSsvXhqPF5ZZXmCuwF1QaNQRQ7CORp228=;
        b=sl92HB9JIQWiy9kLRPLV1wr2nNBaENBgI88KKooa8T8gNUHfnt76oiOZQD4eH7rLUeZ3zo
        YZ/rDaJ2pCWz05Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AD36E13427;
        Mon,  2 Jan 2023 11:24:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fYyMKe2+smNRbwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 02 Jan 2023 11:24:29 +0000
Message-ID: <d6e965ca-a568-5193-20a0-19b1c9b42ca2@suse.cz>
Date:   Mon, 2 Jan 2023 12:24:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] x86/kexec: fix double vfree of image->elf_headers
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>
Cc:     x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        patches@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Dave Young <dyoung@redhat.com>, stable@vger.kernel.org
References: <20230102103917.20987-1-vbabka@suse.cz>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230102103917.20987-1-vbabka@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/2/23 11:39, Vlastimil Babka wrote:
> An investigation of a "Trying to vfree() nonexistent vm area" bug
> occurring in arch_kimage_file_post_load_cleanup() doing a
> vfree(image->elf_headers) in our 5.14-based kernel yielded the following
> double vfree() scenario, also present in mainline:
> 
> SYSCALL_DEFINE5(kexec_file_load)
>   kimage_file_alloc_init()
>     kimage_file_prepare_segments()
>       arch_kexec_kernel_image_probe()
>         kexec_image_load_default()
>           kexec_bzImage64_ops.load()
>             bzImage64_load()
>               crash_load_segments()
>                 prepare_elf_headers(image, &kbuf.buffer, &kbuf.bufsz);
>                 image->elf_headers = kbuf.buffer;
> 		ret = kexec_add_buffer(&kbuf);
> 		if (ret) vfree((void *)image->elf_headers); // first vfree()
>       if (ret) kimage_file_post_load_cleanup()
>         vfree(image->elf_headers);                          // second vfree()
> 
> AFAICS the scenario is possible since v5.19 commit b3e34a47f989
> ("x86/kexec: fix memory leak of elf header buffer") that was marked for
> stable and also was backported to our kernel.
> 
> Fix the problem by setting the pointer to NULL after the first vfree().
> Also set elf_headers_sz to 0, as kimage_file_post_load_cleanup() does.
> 
> Fixes: b3e34a47f989 ("x86/kexec: fix memory leak of elf header buffer")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: <stable@vger.kernel.org>

Takashi told me he sent a slightly different fix already in November:
https://lore.kernel.org/all/20221122115122.13937-1-tiwai@suse.de/

Seems it wasn't picked up? You might pick his then, as Baoquan acked it, and
it's removing code, not adding it.

> ---
>  arch/x86/kernel/crash.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
> index 9730c88530fc..0d651c05a49e 100644
> --- a/arch/x86/kernel/crash.c
> +++ b/arch/x86/kernel/crash.c
> @@ -403,6 +403,8 @@ int crash_load_segments(struct kimage *image)
>  	ret = kexec_add_buffer(&kbuf);
>  	if (ret) {
>  		vfree((void *)image->elf_headers);
> +		image->elf_headers = NULL;
> +		image->elf_headers_sz = 0;
>  		return ret;
>  	}
>  	image->elf_load_addr = kbuf.mem;

