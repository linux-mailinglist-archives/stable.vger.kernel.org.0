Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E15E610742
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 03:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbiJ1BcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 21:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbiJ1BcO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 21:32:14 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55179A571B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 18:32:12 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id k11-20020a4ab28b000000b0047659ccfc28so595278ooo.8
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 18:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=331LzS+zCTF3pctjI7hxcWQiOyXx0a+a6N3w5ukhHUE=;
        b=kgs6Xv0qIqMuqIGJ0UHFLm/ChHVo11DD7vFMu04CHNJJgZftpEG7Td58323QRBU/x+
         TjJQYkhu7uZ24KkjRIGek7a5SljPW4FToR+YgHVJQsBjUxdJ+CwJ+i+iXhP7f/pdwfMk
         8MF94v33ZvOAUNoJPSdcy/wo3bPPQQ8HK2IY96nONBMbw+Zp13LFWqEjPW9OswSD4yL8
         9OTcWmJsgMWoqyH6+F2Cavbzrn/sJjxNGVzj8yx6yqipH46d64o+vETHsCCuOp3FDa/R
         8G16VN9gvmP1UODU7CPnVsEfXI3NUadvYlyAiU1xwiS++uMDl9vYLCqSOUzkTqBTEvhr
         /ypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=331LzS+zCTF3pctjI7hxcWQiOyXx0a+a6N3w5ukhHUE=;
        b=6QpypdKPrArSOpMi97RF9GyoVoUDMOf0PaGbGPSS3m5Ix/CPqI4aC/1ZhQjrN3IAeo
         IxH/Hp0hku7wsZwo/AWRellIYBpkwlUNgT99cfNGbtGc9TxBwQNp51Sa/p+zEuz7F1kA
         2vETkYlwaZ/rNQ2EeGFDRpgvgFuVL8L8P91hSvYY8Wn/huB4VVsT094dRm7pAyCwZlTI
         oCV2X8otG1R40PrKAsiCrXWFiHyOKq62lY0dWHbVjPa04X1+PkwYsxAu4EuyLHPpV/gk
         0P0Snw25Lummstke4YBQkKPXxgOOZdeDo1drVfNXQ+lvjiHk0aouAzZSEDOEbW/wuS2N
         GS0w==
X-Gm-Message-State: ACrzQf1lBTwbIF9h3gnWACNzdZ+kzQUshkeMpBFnfUFGkcstgGVYuFV7
        rYRgjlw7oRGoTMdcbxEdSYkzmA==
X-Google-Smtp-Source: AMsMyM4XBcp/I/fJ3W6TgmzA2JGzNhm3lSOLz+l1rdRK8SGnaXXOumsAPQYQ+sr7f9e1Avdx/C5cdg==
X-Received: by 2002:a4a:ab0c:0:b0:47f:653f:693e with SMTP id i12-20020a4aab0c000000b0047f653f693emr22777153oon.86.1666920731528;
        Thu, 27 Oct 2022 18:32:11 -0700 (PDT)
Received: from ripple.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 126-20020a4a0384000000b00480816a5b8csm1075684ooi.18.2022.10.27.18.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 18:32:10 -0700 (PDT)
Date:   Thu, 27 Oct 2022 18:32:01 -0700 (PDT)
From:   Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@ripple.attlocal.net
To:     Peter Xu <peterx@redhat.com>
cc:     Hugh Dickins <hughd@google.com>,
        Yuanzheng Song <songyuanzheng@huawei.com>,
        akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        david@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.10] mm/memory: add non-anonymous page check in
 the copy_present_page()
In-Reply-To: <Y1sMk30wS+1uH/hc@x1n>
Message-ID: <432c4428-b6d4-f93-266-b920a854c3c@google.com>
References: <20221024094911.3054769-1-songyuanzheng@huawei.com> <3823471f-6dda-256e-e082-718879c05449@google.com> <Y1nRiJ1LYB62uInn@x1n> <fffefe4-adce-a7d-23e0-9f8afc7ce6cf@google.com> <Y1qdY8oUlUvWl067@x1n> <8aad435-bdc6-816f-2fe4-efe53abd6e5@google.com>
 <Y1sMk30wS+1uH/hc@x1n>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reinstating Cc stable, which I removed just before the discussion settled.

On Thu, 27 Oct 2022, Peter Xu wrote:
> ...
> 
> After a re-read and 2nd thought, I think David has a valid point in that we
> shouldn't have special handling of !anon pages on CoW during fork(),
> because that seems to be against the fundamental concept of fork().
> 
> So now I think I agree the !Anon original check does look a bit cleaner,
> and also make fork() behavior matching with the old/new kernels, irrelevant
> of the pin mess.

Thanks Peter.  So Yuanzheng's patch for 5.10 is exactly right.

Sorry for leading everyone astray: my mistake was to suppose that
its !PageAnon check was simply to avoid the later BUG_ON(!anon_vma):
whereas David and Peter now agree that it actually corrects the
semantics for fork() on file pages.

I lift my hold on Yuanzheng's patch: nobody actually said "Acked-by",
but I think the discussion and resolution have given better than that.
(No 3rd thoughts please!)

Hugh
