Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD7213978E5
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 19:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhFARSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 13:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbhFARR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 13:17:59 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C55C061756
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 10:16:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id d5-20020a17090ab305b02901675357c371so1498979pjr.1
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 10:16:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=03YGTpNwQSOs+dI0DajKWE/HnlTsHUlOJKv/uB8bu8o=;
        b=lQf4HXK19/hFZG81cGyUp07I8F+flEDEOIxVB1Z/Rt2SEAWS3YszoIHLRAJgmgAUTw
         Edy2QW9uzPi+mzLbA9XbJwsVRcfjLOMRajCMS1vssNlGY6HyMiUnwxvLpqT2iiGAWkNY
         CqORDo3gPhJlFccupKxkE2/usq7xSdkR7wYPJtsIjxN8VIgPoGjDk9clMHss+BEafbJw
         +LNWiFb7hJLe3xFkbB33M/EUXFPgszY8Om3Uf2prmU0HnrOWUwnfO+cEi4c3fC+sizsE
         kE4wbGfst49nJFzgDNQMbjlKmUogCyjYPViFQ0cJjHZAyqqxR9XosG3Ova7FUWdFywbQ
         RL2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=03YGTpNwQSOs+dI0DajKWE/HnlTsHUlOJKv/uB8bu8o=;
        b=Ljm1NlIOPJjASkcqv+Il3gEtkxTaybDFA8oHPkTQvxAdamcwUg5sOxGyOJoql5XM6l
         k7S401IcTbf/acXTxsIz6jZ/HzAmkSbXDu7jkXU27sga4c3WK2U8xWXbLyMYJgji/tss
         PkpJT+deNx/3ZUbRCSRZJZyiFECE2T9pedH2kGw/ORw35rgLFJMbNNAMONaA4JTTT3qh
         JsWy2zoT0JovH1hyw9GXV+G+gutGRSefEra9W833v4ahDzMIu9XUqHOYbYqdT4t6Ex0s
         jSYjqsCLyqjH04mKZPPCuFeVQHJBcYZIRKxKEAzx4hbPKnU5oZuHCCJFu50pnEBKQjjx
         7cmQ==
X-Gm-Message-State: AOAM530iCvqGfs9H4HAmXqG2ojdcwSqg/ZX3LtRaeXPvHytbld2DMZjm
        z92j81tSzCZxl7mZK7Y6hPqp1A==
X-Google-Smtp-Source: ABdhPJx0tglHxBZ0iTUaqoezKcBQbxi4tmxT77btfq43yF4S/S/GHJomHt8fhQx/ETbZVaqtivdbBg==
X-Received: by 2002:a17:90a:e7c2:: with SMTP id kb2mr26667597pjb.193.1622567776919;
        Tue, 01 Jun 2021 10:16:16 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id b10sm8787458pfi.122.2021.06.01.10.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 10:16:16 -0700 (PDT)
Date:   Tue, 1 Jun 2021 17:16:12 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, Pu Wen <puwen@hygon.cn>,
        Joerg Roedel <jroedel@suse.de>, x86@kernel.org,
        joro@8bytes.org, dave.hansen@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        sashal@kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/sev: Check whether SEV or SME is supported first
Message-ID: <YLZrXEQ8w5ntu7ov@google.com>
References: <20210526072424.22453-1-puwen@hygon.cn>
 <YK6E5NnmRpYYDMTA@google.com>
 <905ecd90-54d2-35f1-c8ab-c123d8a3d9a0@hygon.cn>
 <YLSuRBzM6piigP8t@suse.de>
 <e1ad087e-a951-4128-923e-867a8b38ecec@hygon.cn>
 <YLZGuTYXDin2K9wx@zn.tnic>
 <YLZc3sFKSjpd2yPS@google.com>
 <dbc4e48f-187a-4b2d-2625-b62d334f60b2@amd.com>
 <YLZneRWzoujEe+6b@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLZneRWzoujEe+6b@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 01, 2021, Borislav Petkov wrote:
> Yah, ain't gonna happen. I'm not taking some #GP handler to the early
> code just because some hardware is operating out of spec.

The bug isn't limited to out-of-spec hardware.  At the point of #GP, sme_enable()
has only verified the max leaf is greater than 0x8000001f, it has not verified
that 0x8000001f is actually supported.  The APM itself declares several leafs
between 0x80000000 and 0x8000001f as reserved/unsupported, so we can't argue that
0x8000001f must be supported if the max leaf is greater than 0x8000001f.

The only way to verify that 0x8000001f is supported is to find a non-zero bit,
which is what Pu Wen's patch does.
