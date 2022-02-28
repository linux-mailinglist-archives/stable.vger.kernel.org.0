Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F33E4C7071
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 16:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237547AbiB1PRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 10:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237525AbiB1PRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 10:17:02 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2A8811B0;
        Mon, 28 Feb 2022 07:16:16 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id l25-20020a9d7a99000000b005af173a2875so9736614otn.2;
        Mon, 28 Feb 2022 07:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3erX1W/V8eKoqrAyYmfugbwLeZekQvkkVtHUA9NIwMk=;
        b=drpj1huI2zUtT9Wxsj1mWTLeR7td9jWzGtULueocDG5ZY8vkEnbQe+F9SxynenJPt9
         1YQxDabJkCDr9VRQRt+LIJ+ge7VwvhZRjkVtgccg8gg1LRTeEDZgCj/PK6o3zVxFqXSR
         IBubXJps1jrO7uwOlTm8tEda55t/VFR/omtiacO+Guj67wxrRfLIWSQuLJpafmaQRxM1
         MAAXm47q36VY3tKbW3bqVQY7pd89RN4ie8+Uw2s8ANxcipLCuNiptwD/uNMZZn2VwtpJ
         LM8YL9V9dzV97ahyiSPKTl6/TaeCbzxCj3cixXfjOrquBp3Q07y1oWvU/vmxBJg/U9Dg
         5QtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3erX1W/V8eKoqrAyYmfugbwLeZekQvkkVtHUA9NIwMk=;
        b=rdB/Z7Ib/P1bsEP+HDjlVBB33RLxToa4lrXyY8oX15j+46YuHE/wN69fd8B7xIGjn4
         AtDKrRp0kQuSF9JbmMH+FfOBaNnwe8kjAbI7SkX1+g4unn+vqWR+gm19fczGOWy4xwN4
         FfZpXDShFAJMEk10qA6qka8t2MB2efWqusJw7WURNpKt7A1Tsj4BEBrQ42EAx1976xLf
         cOEoh2SgTxZBLCgVwh1X9SPBvfBEcO9mNxiqTfKUmSKRfIN3ay0xgsPMFOe0q7rMLa4h
         cxFlpSzWAWOQ5CpHPS7ooUQQBsfq6pFe50F/lT/BTAzhASTTpRAC6yQQyf5KmnuKjgw8
         SD2Q==
X-Gm-Message-State: AOAM532dONIL2QsbTOAoiZFQNoFX2NGfSVym5yqEDaUcjwFrUxvYOPV2
        TtJANPiQPsqumLo3SaVF98Xy94uEyjM/tlDLjyg=
X-Google-Smtp-Source: ABdhPJx9TTxxLNEwF+4nqK17T9MfrZryYcQnu8nF9wuFdmJwPKwtyAsHwaCtK/g+ns54aBxeRErB7ut9nPOPqMIGnK0=
X-Received: by 2002:a9d:7096:0:b0:5ad:ebf7:a225 with SMTP id
 l22-20020a9d7096000000b005adebf7a225mr9336023otj.370.1646061375645; Mon, 28
 Feb 2022 07:16:15 -0800 (PST)
MIME-Version: 1.0
References: <20220225221625.3531852-1-keescook@chromium.org>
 <CANpmjNOup5JCjRpRkhsF3Z+dPX6_MQE5u6WhnMit84c1TyRK+A@mail.gmail.com> <CA+DvKQ+PYtDyejaUoBj51D_Y7muYaR1_FhQGWGWvgQawCbp31Q@mail.gmail.com>
In-Reply-To: <CA+DvKQ+PYtDyejaUoBj51D_Y7muYaR1_FhQGWGWvgQawCbp31Q@mail.gmail.com>
From:   Daniel Micay <danielmicay@gmail.com>
Date:   Mon, 28 Feb 2022 10:15:59 -0500
Message-ID: <CA+DvKQ+bp7Y7gmaVhacjv9uF6Ar-o4tet872h4Q8RPYPJjcJQA@mail.gmail.com>
Subject: Re: [PATCH] mm: Handle ksize() vs __alloc_size by forgetting size
To:     Marco Elver <elver@google.com>
Cc:     Kees Cook <keescook@chromium.org>, llvm@lists.linux.dev,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looked through them and nearly all seem easy to replace.

By the way, the call to ksize in arch/x86/kernel/cpu/microcode/amd.c
doesn't look right. It allocates the memory with kmemdup. I don't see
how it can assume that the padding is zero, and that seems to be a
requirement since it zeroes the destination before copying to it.
Seems far more reasonable to add a field with the size.
