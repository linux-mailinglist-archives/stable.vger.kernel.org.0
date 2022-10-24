Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939B960B772
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 21:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiJXTYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 15:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbiJXTYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 15:24:00 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63344CF194
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 10:58:08 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id y25so2057479ual.2
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 10:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jIUhXCylWTZyNF0ZZmlYqRt2dvHO3F0L1QAEk1qEOdA=;
        b=HKNQqa9nE7I5KHjD1Kgg9r8gsp+/lkT00xq1s1N/WqPzv82hGtdg4ru/MPSat9GVQH
         mKihWdsl2O7Jk3W2xsc2tl9n3av8Dex2X0OBP3Nkk8X34r1018FV1Sf2lzONZxhV8h2X
         kLjJMF2Wug76tH7D/OJiZeNyz/ulzWzidfQJ5yiiN5wV8RbBh7k/jL6DPQMnpd6U1pfn
         61wE4Z58mlmj93aoi+K16koSgiH47MsJdLheTEeLcMTLXCpOM7P5u+TOY4NrOdriVmvW
         S8dVPijwh8oXQlYMtpbdAmQYz3z3bTSSOV+coYntKJm7naJxl7wfG7mVFbfvr6C+bewi
         mY9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jIUhXCylWTZyNF0ZZmlYqRt2dvHO3F0L1QAEk1qEOdA=;
        b=b1ZgFILsA68lLChzjOrfI2TWI3BY8xy+tJz9JSlfsziCabTB6GDCPF1RrAoSl4ODFu
         H0UBdKbNSxxeIkPCnBQpy/Z0xIAfGKsa/QMe+bIOvgPaiKeXu+MTEuSq50BX9k4EvZzi
         C0hZs1rcfJ3tEpx3lOOLY+cboVT+sHFD2yXrSTA/JERVV/4SY7x6JdpRS1bOw/aPL2Is
         9GhacZNNU1wR6k1gx+zwI4eEVsvzsDNd+1+p8o6tOAH1XlVwo8BDeMLQFp1RgXq4I+Et
         rA862yZwNdGKKUfAdye01ReHEhUjZwGDBy58G/LprSJaJ7MTrSsI/5GwdCyV3GhEaeTt
         cEqA==
X-Gm-Message-State: ACrzQf0ahHpEW6IjnHBKx6PUZvOBHa+NTIp7/FSHiV6OBpmNU6LbW7Kl
        2FuHomvnH0wIsc+wb3yojcJT+AQgIeFC4egn7/wfaw==
X-Google-Smtp-Source: AMsMyM7v32guca965IG+5az6BzOI3Xcx78mmvt0lTEpANPeogcGiz1tjcRfDBpEOXd60mtEGsL6cmh7O797JScjDu50=
X-Received: by 2002:a9f:3626:0:b0:3b5:c921:e0aa with SMTP id
 r35-20020a9f3626000000b003b5c921e0aamr20604005uad.92.1666634228830; Mon, 24
 Oct 2022 10:57:08 -0700 (PDT)
MIME-Version: 1.0
References: <20221021222811.2366215-1-eugenis@google.com> <Y1OdfXuLmp/gr1Z4@kroah.com>
In-Reply-To: <Y1OdfXuLmp/gr1Z4@kroah.com>
From:   Evgenii Stepanov <eugenis@google.com>
Date:   Mon, 24 Oct 2022 10:56:57 -0700
Message-ID: <CAFKCwrg4=MdqNVcma-OnbmDDZXtporAr0x=uBn3rCO7dbC4hFQ@mail.gmail.com>
Subject: Re: [PATCH] arm64/mm: Consolidate TCR_EL1 fields
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 22, 2022 at 1:15 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> What stable kernel branch(es) do you want this applied to?

5.15, sorry I forgot to mention that. Thank you!
