Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F491ED776
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 22:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbgFCUfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 16:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgFCUfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 16:35:12 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE36C08C5C2
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 13:35:12 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id s88so102152pjb.5
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 13:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W5rG5azrfwU1SE5+6VF2CaiUSY0EB63jPHlaOLOAids=;
        b=H8lAAd7t8MN6jYw5eMcIVe9rAHxpKI1yFv/LZqIHzVdqTGi0osItXRbEC3imxxp5fw
         XiTsvqNcg9jDA5i7CRdaI5PyhRfdYFu1/Haxwk1herusBfde/0Rxv2M8k7zdqcBZ5vO2
         uAqTfTk4PSLas1IJTdwiVj7qe87PLWc/DJroM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W5rG5azrfwU1SE5+6VF2CaiUSY0EB63jPHlaOLOAids=;
        b=pyQmLYBf0Gjjs1GnMRfri8su5TEg8TSIKE8C0eJ1Wyd0+sBIerFk55nPyVi3kufEum
         20RNNKhCUtue+TCNfoBdTVGBejVgcH2lBWUboemQOAqQ83C6RLHmUduglmZfCzPk7g87
         UVskAyY87LFBrfb9O9+QassC/6eNl5W5rvLC5EGpGRAoU9XUAbfQlxo5vXZwrK556CKP
         pqwlL25rogc6sXPqZFPgEi60FaDZ8OCWQryTbuOaxiFIb8W6B/4hzQfJgOK6VE08obOj
         TuuvnupTb1qHOvXUOA1kPDs/5ykLDgpKDy8WK5wTf/ilTeHLOrxE6U/2C2j8O6V+6pox
         BCxQ==
X-Gm-Message-State: AOAM533rW841g+Z9R1G8PPmYshroZ2lOr3pldhvY4G6f27YfP90lH6MD
        mkdxIuuuODx2ZUuOehnUQKAh8g==
X-Google-Smtp-Source: ABdhPJxh+aatEAcsfm7x2O7pF9u4HQEykZUt/5RuZbEPGXrhPVdcNGxmsklSppL48UqLLLYO/xjupQ==
X-Received: by 2002:a17:902:714e:: with SMTP id u14mr1478127plm.175.1591216512009;
        Wed, 03 Jun 2020 13:35:12 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id i10sm2573857pfa.166.2020.06.03.13.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 13:35:10 -0700 (PDT)
Date:   Wed, 3 Jun 2020 13:35:09 -0700
From:   Kees Cook <keescook@chromium.org>
To:     glider@google.com
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, royyang@google.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] ovl: explicitly initialize error in ovl_copy_xattr()
Message-ID: <202006031219.36197D0729@keescook>
References: <20200603174714.192027-1-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603174714.192027-1-glider@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 07:47:14PM +0200, glider@google.com wrote:
> Under certain circumstances (we found this out running Docker on a
> Clang-built kernel with CONFIG_INIT_STACK_ALL) ovl_copy_xattr() may
> return uninitialized value of |error| from ovl_copy_xattr().
> It is then returned by ovl_create() to lookup_open(), which casts it to
> an invalid dentry pointer, that can be further read or written by the
> lookup_open() callers.
> 
> Signed-off-by: Alexander Potapenko <glider@google.com>

Link: https://bugs.chromium.org/p/chromium/issues/detail?id=1050405
Fixes: e4ad29fa0d22 ("ovl: use a minimal buffer in ovl_copy_xattr")
Cc: stable@vger.kernel.org
Reviewed-by: Kees Cook <keescook@chromium.org>

It seems the error isn't reported anywhere, so the value likely isn't
too important. -EINVAL seems sane to me.

Thought: should CONFIG_INIT_STACK_ALL=y disable uninitialized_var()?

$ git grep uninitialized_var | wc -l
300

We have evidence this is being used inappropriately and is masking bugs.
I would actually think it should should be removed globally, but it
seems especially important for CONFIG_INIT_STACK_ALL=y.

I've opened:
https://github.com/KSPP/linux/issues/81

-- 
Kees Cook
