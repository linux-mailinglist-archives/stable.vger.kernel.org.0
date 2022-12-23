Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4A7654EEE
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 11:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLWKDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 05:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiLWKDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 05:03:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F54111148
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 02:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671789764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Zd08r+/yxBI3QCDz4qTyW7WKzjHtTlULyzjNBHIsEnI=;
        b=Y5jdOTUya+tg2DGUsMRg3NlxOwu7imz2e5uSD6zd+R+wWfei5SgFeMk5BAhFiFA+uDa8ZT
        Vf203h8rAF8U05cwrsnjTjPuac6l6NqTL0Q/GEONfRbF+V7WF/C3aFjT522DOX+BKR0NYd
        tRA5eiq0UqdEelrXX99zZ347yb0UlIg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-249-vNYTJKIJO1aNqzynIgrkSQ-1; Fri, 23 Dec 2022 05:02:42 -0500
X-MC-Unique: vNYTJKIJO1aNqzynIgrkSQ-1
Received: by mail-wm1-f72.google.com with SMTP id fm17-20020a05600c0c1100b003d96f0a7f2eso607705wmb.6
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 02:02:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Zd08r+/yxBI3QCDz4qTyW7WKzjHtTlULyzjNBHIsEnI=;
        b=z5gC0j4YPrysSYlEpwI9+CjjQ8/daV3gm8GZqNUQi2hLIrqvZ0+4rPmnHxxhnGaZVI
         FuFfjUuLSPPcm9ODYzKDFbPcTSOnYdhg8ZziK1m25bFNRNBfvwplCg1bfIlmHF/A3a2W
         6rVmL03gt915cL1bxeBkmHH0XVStyglsftulZofoguGxGTjKhSf7LE+U2A48iYx2oBZD
         X9Jc9jS6T1Z4zM0quWMRnuAfpH74coMjqMrkfucJyqcbrbu/iQNlugEeHM3mzw9qVV24
         iRkpmjurZvajfk/G0d11904kIUqxB6Wi17IomaGa7aMCsbibQwuvUIB9ZfOjTpTrlUJm
         ZRYA==
X-Gm-Message-State: AFqh2koS+Eo6zYChw6T6T9dpFw4scWqeKSoSkGqCkLUzsQa3uzaAC/nO
        ZYv3Xn9pAE7rHH7qfG59pOKOXsg7inPOeLy2xyy5eRiuzMPnrOq2Vhw1iPsR4LOs1jQNTrV8QSD
        ra/l64pOef3lXfUq6
X-Received: by 2002:adf:e40e:0:b0:24f:93fe:dce6 with SMTP id g14-20020adfe40e000000b0024f93fedce6mr5557732wrm.27.1671789761761;
        Fri, 23 Dec 2022 02:02:41 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvif/NV49KBuhvWmbj+VFqZV9WC0ozWRfyn0bN6lWQowIR6WsdnIAaGZ7uSOB3jV4n16xHJDw==
X-Received: by 2002:adf:e40e:0:b0:24f:93fe:dce6 with SMTP id g14-20020adfe40e000000b0024f93fedce6mr5557719wrm.27.1671789761543;
        Fri, 23 Dec 2022 02:02:41 -0800 (PST)
Received: from ?IPV6:2003:cb:c707:ab00:3d8e:16c4:a38d:2827? (p200300cbc707ab003d8e16c4a38d2827.dip0.t-ipconnect.de. [2003:cb:c707:ab00:3d8e:16c4:a38d:2827])
        by smtp.gmail.com with ESMTPSA id c4-20020a5d4f04000000b002365cd93d05sm2655632wru.102.2022.12.23.02.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 02:02:41 -0800 (PST)
Message-ID: <b7489609-d9e3-a052-5f29-b948a3e4584e@redhat.com>
Date:   Fri, 23 Dec 2022 11:02:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     Andrew Morton <akpm@linux-foundation.org>,
        mm-commits@vger.kernel.org, stable@vger.kernel.org,
        rppt@linux.vnet.ibm.com, peterx@redhat.com, nadav.amit@gmail.com,
        ives@codesandbox.io, hughd@google.com, apopple@nvidia.com,
        aarcange@redhat.com
References: <20221210004423.94D4FC433D2@smtp.kernel.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: +
 mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
 added to mm-hotfixes-unstable branch
In-Reply-To: <20221210004423.94D4FC433D2@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10.12.22 01:44, Andrew Morton wrote:
> 
> The patch titled
>       Subject: mm/userfaultfd: enable writenotify while userfaultfd-wp is enabled for a VMA
> has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
>       mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch
> 
> This patch will shortly appear at
>       https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-enable-writenotify-while-userfaultfd-wp-is-enabled-for-a-vma.patch

Andrew, what happened to this fix? I think I'm too blind to spot it 
upstream, in one of your trees or in -next ...

-- 
Thanks,

David / dhildenb

