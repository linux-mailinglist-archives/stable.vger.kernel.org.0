Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B0331F118
	for <lists+stable@lfdr.de>; Thu, 18 Feb 2021 21:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBRUex (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Feb 2021 15:34:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhBRUeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Feb 2021 15:34:19 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7712CC061756
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 12:33:37 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k22so1896305pll.6
        for <stable@vger.kernel.org>; Thu, 18 Feb 2021 12:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6GkVg6oPaCbOjN9yHtUy6WgUiMIl+iIxU5q/YySdGqo=;
        b=HWrUIFsIBt63vXlTx9Fi+lqtHfKHvSqunnCmQIjmO0fDJL7GSWvmZlm0BRMwCnJPc3
         gbo6xFLqUPzMMWqkoks6inG87DuOSa9iGf15R8guNkFY5qwVM3JI1b2FqVFPb9ve5TWq
         bJnAFpEzsyLjDChFEZHC8GccBzFB8VDJJpf+s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6GkVg6oPaCbOjN9yHtUy6WgUiMIl+iIxU5q/YySdGqo=;
        b=CLa0EAu+A5KuymGdp2WL7V9DnAQxsPtZgJlYZLFntUtT9IhRzjrcrhsSW5FwRr6i5K
         mbHfQnh6hTlO2GHyFHC+HS3O1SiPQZFtYkipZMxkovy3ruVT3Ajy7z6DBN8rp3IWM1jr
         Z58E4JSM0pXDKuT9fLCTdDwtCDypE0qoHJQygpCNQ8+5vygwWNDNP7gvBTT3sa9DCBSg
         JGftYSMMeG9mtGso4xQ18be0G+RpcIF/oX7CqEs/aQ+2pUVbQWlRd6V8ur+RRGfQXh16
         z7JbXDup7dKi8AsNTimEikPo0CCHwiWiEVz7GM18cQVhhcGNpjZ/eh0N9HOFJjNd3pkm
         95jQ==
X-Gm-Message-State: AOAM531CepXApsRXY5qK0TWEtvxJHy8P5YxHJ+l2BSA7lb36BxL7gjyW
        u7swnzjcZvLsgYU9L9ITxCKj8g==
X-Google-Smtp-Source: ABdhPJxslS5tP12p8hBRmWryZqdHGJ2VYdgG9pkwL3XgJ6NpQfX/68tVqTkWrQNGhYUSC+bBbwvZng==
X-Received: by 2002:a17:90b:806:: with SMTP id bk6mr5614183pjb.16.1613680416959;
        Thu, 18 Feb 2021 12:33:36 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x20sm6993759pfi.115.2021.02.18.12.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 12:33:36 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Tony Luck <tony.luck@intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Jiri Bohac <jbohac@suse.cz>, Colin Cross <ccross@android.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pstore: fix compression
Date:   Thu, 18 Feb 2021 12:30:03 -0800
Message-Id: <161368019685.305632.7880211837303066992.b4-ty@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218111547.johvp5klpv3xrpnn@dwarf.suse.cz>
References: <20210218111547.johvp5klpv3xrpnn@dwarf.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 18 Feb 2021 12:15:47 +0100, Jiri Bohac wrote:
> pstore_compress() and decompress_record() use a mistyped config option
> name ("PSTORE_COMPRESSION" instead of "PSTORE_COMPRESS").
> As a result compression and decompressionm of pstore records is always
> disabled.
> 
> Use the correct config option name.

Eek; thanks for the catch!

Applied to for-next/pstore, thanks!

[1/1] pstore: Fix typo in compression option name
      https://git.kernel.org/kees/c/19d8e9149c27

-- 
Kees Cook

