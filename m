Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE97664CBC
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 20:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjAJTpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 14:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbjAJTpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 14:45:18 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BDC6146
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 11:45:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 006E3CE1923
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 19:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9BCC433F0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 19:45:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="bbZfN1Sr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1673379911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2NkVdLUkLDq9LFhL+e0QvTLnw78n+Jag6Mwzq0DdzA8=;
        b=bbZfN1SrPJMcJiaXo3OBuU4ArbEmo+3Jzr7TWo9/hl2E/AOEB6xdtFuIPhNCJpmyWFuDYF
        X/+NUlGAtu+HZxSKqbSPRlGZHmO7W4TN8Gh8kM7/gF8Ks4GfjDLmvGboUbbvCnvro47Iu7
        pb5Qn4+0U5KTXqovZ4nBNNk3O1a/H2E=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id b0a038c9 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Tue, 10 Jan 2023 19:45:10 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id u9so31514171ejo.0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 11:45:10 -0800 (PST)
X-Gm-Message-State: AFqh2kqcJ4H8uGoOyJbScn8TTKmn/S3JYNLem+KqupfSVfITaNnUcdqQ
        TGBu2E9DY4Gzl/hV/sO8O0GziSE7Q3LHaUQv7FU=
X-Google-Smtp-Source: AMrXdXvhrfShfPSyZUYOKloAmpijVG8w4cbLgw9krL/qexv+lBHwMW3chrRhYgNyks8aommjy47k8s8P6d3YGnrDwS8=
X-Received: by 2002:a17:907:a28c:b0:840:2076:4a1b with SMTP id
 rd12-20020a170907a28c00b0084020764a1bmr4327427ejc.558.1673379909365; Tue, 10
 Jan 2023 11:45:09 -0800 (PST)
MIME-Version: 1.0
References: <20230110160416.2590-1-Jason@zx2c4.com> <Y72YyXw5HcsbDac1@kroah.com>
 <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com> <Y72bx/IyZ0zl6opA@kroah.com>
In-Reply-To: <Y72bx/IyZ0zl6opA@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 10 Jan 2023 20:44:57 +0100
X-Gmail-Original-Message-ID: <CAHmME9oomMCxw=OQZpSp+hwLM78hZV+gNyn8ZPJgN99s2e=tuw@mail.gmail.com>
Message-ID: <CAHmME9oomMCxw=OQZpSp+hwLM78hZV+gNyn8ZPJgN99s2e=tuw@mail.gmail.com>
Subject: Re: [PATCH stable] efi: random: combine bootloader provided RNG seed
 with RNG protocol output
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 6:09 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 10, 2023 at 05:57:21PM +0100, Jason A. Donenfeld wrote:
> > Thanks! IIRC, this applies to all current stable kernels (now that
> > you've sunsetted 4.9).
>
> It does not apply cleanly to 5.4.y or 4.19.y or 4.14.y so can you
> provide working backports for them?

I did 5.4.y, which turned out to be hairy than I wanted. You and Ard
can decide if you want it or not. I'll leave 4.19 and 4.14 for another
day.
