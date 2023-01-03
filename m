Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC49B65BDD1
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 11:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232990AbjACKPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 05:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237194AbjACKPR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 05:15:17 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41C6AEE32;
        Tue,  3 Jan 2023 02:15:16 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z11so27296602ede.1;
        Tue, 03 Jan 2023 02:15:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dg4Iem/pwcu+hGrCWyFWcE0w0rA2DwqUcHLBcyuPeUc=;
        b=mjSbDBWx33CYMdnRAunBxjnUpsQB8NQEfdMQgMgMOMnsSL2cUgoBYVoV1sYAg2p0Zp
         50bdUMAQBKLBJKw+RQJGTYGVqDzPzYZoE6hNmGb1i5zXPIqLNykLk0p2pGnXFlik/t2C
         grRyHKq4PBadLvD2l5ItwXVsIA7HCKuk/+WfMEbq9F2aNiw017v28VGfTtFG/2AijMda
         veJ+wuzLKcZk3E2ifzeaHUw7UfbUh+7nT4Zs3CJDmhcZ4JEJ4e2YINxHe0YL51HMrGSZ
         OByncrEr9GdapTEhGBNp8zuujYcX/U+gUYtkegXnSM1hjbSRkh4T4NVSekJxNWP8fRt8
         fBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dg4Iem/pwcu+hGrCWyFWcE0w0rA2DwqUcHLBcyuPeUc=;
        b=IUlLfedL7C0J+Ub8kXU3zO2fRgUn51mRDPChP+ECmuIkiCYJnfUb69vWNmVjszanCK
         HQqK2ofNJeKXRqsEsYvG5Au3HcXbHU75o8s+fojAhf6VTb4rXpiYliShoFrE1SsgiSeK
         wCWUEf8gBsHcCpDagaJjUHVo1I+XSwBEx8Rf0hrSg7vtRUZj1QbCl7iay0tQ79izaAP3
         aH6mQ69fHJMt5P54EZTJ0xxQu7kBsJoH9157qdHyjDpsnsB/Ak1ZCYRZAt5e388uam4I
         aMt1goYnU5AAu7ePiRCJhluPCYkSVDqhBHtczfBuVN3S0a1BWoa8MKTEr4VFyvQxTmTO
         iViQ==
X-Gm-Message-State: AFqh2ko/c/nbVsUakQ4teEIXZmYFNEEgLmOBql+KVFcq/aLKNp7KUKYG
        bWkg0TvyZn9qWh9ADUU2amAWDN3Dlag=
X-Google-Smtp-Source: AMrXdXvGHahoAqytki6ZL5OVZWOTmKsQ+1eCtyz/+vLkr9dsT6hcqNhYr+klb25nfwe/d8ifvVVIMw==
X-Received: by 2002:a05:6402:d5c:b0:461:68e4:15cc with SMTP id ec28-20020a0564020d5c00b0046168e415ccmr34746439edb.9.1672740914735;
        Tue, 03 Jan 2023 02:15:14 -0800 (PST)
Received: from gmail.com (1F2EF380.nat.pool.telekom.hu. [31.46.243.128])
        by smtp.gmail.com with ESMTPSA id r7-20020a170906280700b007b27aefc578sm13853448ejc.126.2023.01.03.02.15.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 02:15:14 -0800 (PST)
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date:   Tue, 3 Jan 2023 11:15:12 +0100
From:   Ingo Molnar <mingo@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Takashi Iwai <tiwai@suse.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, patches@lists.linux.dev,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Baoquan He <bhe@redhat.com>, Dave Young <dyoung@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/kexec: fix double vfree of image->elf_headers
Message-ID: <Y7QAMIu6j6Y6m8vV@gmail.com>
References: <20230102103917.20987-1-vbabka@suse.cz>
 <d6e965ca-a568-5193-20a0-19b1c9b42ca2@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6e965ca-a568-5193-20a0-19b1c9b42ca2@suse.cz>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


* Vlastimil Babka <vbabka@suse.cz> wrote:

> On 1/2/23 11:39, Vlastimil Babka wrote:
> > An investigation of a "Trying to vfree() nonexistent vm area" bug
> > occurring in arch_kimage_file_post_load_cleanup() doing a
> > vfree(image->elf_headers) in our 5.14-based kernel yielded the following
> > double vfree() scenario, also present in mainline:
> > 
> > SYSCALL_DEFINE5(kexec_file_load)
> >   kimage_file_alloc_init()
> >     kimage_file_prepare_segments()
> >       arch_kexec_kernel_image_probe()
> >         kexec_image_load_default()
> >           kexec_bzImage64_ops.load()
> >             bzImage64_load()
> >               crash_load_segments()
> >                 prepare_elf_headers(image, &kbuf.buffer, &kbuf.bufsz);
> >                 image->elf_headers = kbuf.buffer;
> > 		ret = kexec_add_buffer(&kbuf);
> > 		if (ret) vfree((void *)image->elf_headers); // first vfree()
> >       if (ret) kimage_file_post_load_cleanup()
> >         vfree(image->elf_headers);                          // second vfree()
> > 
> > AFAICS the scenario is possible since v5.19 commit b3e34a47f989
> > ("x86/kexec: fix memory leak of elf header buffer") that was marked for
> > stable and also was backported to our kernel.
> > 
> > Fix the problem by setting the pointer to NULL after the first vfree().
> > Also set elf_headers_sz to 0, as kimage_file_post_load_cleanup() does.
> > 
> > Fixes: b3e34a47f989 ("x86/kexec: fix memory leak of elf header buffer")
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Baoquan He <bhe@redhat.com>
> > Cc: Dave Young <dyoung@redhat.com>
> > Cc: <stable@vger.kernel.org>
> 
> Takashi told me he sent a slightly different fix already in November:
> https://lore.kernel.org/all/20221122115122.13937-1-tiwai@suse.de/
> 
> Seems it wasn't picked up? You might pick his then, as Baoquan acked it, and
> it's removing code, not adding it.

Thanks, indeed we missed that fix - Boris picked up that version in 
tip:x86/urgent, via:

   d00dd2f2645d ("x86/kexec: Fix double-free of elf header buffer")

	Ingo
