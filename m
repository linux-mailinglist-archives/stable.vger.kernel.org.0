Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3CD04DA21D
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 19:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344689AbiCOSNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 14:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351014AbiCOSNB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 14:13:01 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197BE59A76
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 11:11:49 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d19so249102pfv.7
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 11:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZQPIygnZI3s8wOTqewXSrnx1w2bIQcvKOq/SiWBkQU4=;
        b=oRELj35FqUFc8yaeJQtZTjTyV/Qpr9lpHQrTxaVY+TpV1hPoRQSaUl/aI0HJqYcGjd
         1bvRTiXC7xEFoLyOvUqhr0L0/jhE9bBAgXxf475dEOYgVGA95Yt+XBtjx2waxkapzvJd
         qmyd4pf57uxVrcBSYI0VlHD2sdi6NtQ3L9G2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZQPIygnZI3s8wOTqewXSrnx1w2bIQcvKOq/SiWBkQU4=;
        b=QuScMJzb/ZvuXz4naMQ16QijPW6Dzx2ndlKunQDmv1/YHITnf2nk5F7pZ4Yd3jFdnF
         ZpIcaD4vqmhjWPJyHJgg2Ir42xlSM7BG6k/BQ++TMqfQCsve04ey6A1dX1GGKfpuTG0Y
         iFJ5ZsiGoC9BbiIbBzlYZgF/vezm0VZd5oddXfUSmKf7Z+1LDhdZn7S7gtu6gN05n/Tl
         9NFy17+8VVI7uZ5DG4u6syGUVZwUUlTjOZ5zHsWQA07HelxwKHx7ZyWd+Tega4njNJzQ
         qA7KKNjUbsZg1g/pMXRsoS4DE/WvkaVyhsPA+Zxgh/LAhTHvZ/bxbxM8MZJmOBKFFkP5
         tQkQ==
X-Gm-Message-State: AOAM531K2SPlzsSSANYKVdQ4jaAyOp6PVHS70XKjFY8Qt98e39h7xD4w
        xipN+S4YMqrPZ81PqNKx5BhBsA==
X-Google-Smtp-Source: ABdhPJxUCx9Xypk8fGvJvwDZp5k7IY+g+PskUfFuPWQ6wT0L2qvzlM8InrxBy4DDdiVx8Hsv9B1XZg==
X-Received: by 2002:a63:2a8b:0:b0:380:b9e1:afe7 with SMTP id q133-20020a632a8b000000b00380b9e1afe7mr25301727pgq.5.1647367908628;
        Tue, 15 Mar 2022 11:11:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o7-20020a63f147000000b00373facf1083sm20698127pgk.57.2022.03.15.11.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 11:11:48 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jann Horn <jannh@google.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Anton Vorontsov <anton@enomsg.org>, linux-efi@vger.kernel.org,
        Colin Cross <ccross@android.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] pstore: Don't use semaphores in always-atomic-context code
Date:   Tue, 15 Mar 2022 11:11:43 -0700
Message-Id: <164736790118.3742734.9257736142357327917.b4-ty@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220314185953.2068993-1-jannh@google.com>
References: <20220314185953.2068993-1-jannh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 14 Mar 2022 19:59:53 +0100, Jann Horn wrote:
> pstore_dump() is *always* invoked in atomic context (nowadays in an RCU
> read-side critical section, before that under a spinlock).
> It doesn't make sense to try to use semaphores here.
> 
> This is mostly a revert of commit ea84b580b955 ("pstore: Convert buf_lock
> to semaphore"), except that two parts aren't restored back exactly as they
> were:
> 
> [...]

Applied to for-next/pstore, thanks!

[1/1] pstore: Don't use semaphores in always-atomic-context code
      https://git.kernel.org/kees/c/8126b1c73108

-- 
Kees Cook

