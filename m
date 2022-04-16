Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 485EB50333B
	for <lists+stable@lfdr.de>; Sat, 16 Apr 2022 07:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiDPE20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Apr 2022 00:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiDPE2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Apr 2022 00:28:24 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C915C26ACF
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 21:25:53 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id md20-20020a17090b23d400b001cb70ef790dso13123605pjb.5
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 21:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fwjZWUK23SDc9f6Fzho9lbrW12rtjQaU86s3X7g7WA8=;
        b=F34psi04KzHnYMusfXO0+Sf3dJ+pbADOBfrHzkAjvESdbhKsZSm2ygbl4eJ8nzig2M
         6I4LRslXFzO0BGeOnKyUp9HRJeF5QPCuHXGQNSY4rw5MVk8II4OdX1w478l05XQxHCaj
         ltrcULTumO2g2mcppqt0GiQ9OCt++92abzFh4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fwjZWUK23SDc9f6Fzho9lbrW12rtjQaU86s3X7g7WA8=;
        b=eiH9hfjwP7Z1EJZHvgWpg16dd8uyQNAJu1yLlxJG9zzEH8N2JW12si7GoeTi0nvEOP
         9/EqqORO+4Q3iwku2x3uwQ5WbucBOisHVei5Oh8KCtbOO4hJzZFIx85Cd8734njbjJ0Z
         dx+i9/CZaZFI8VPGyzcziGLhbA1iiAHZT2owOY062Ipp8QTWM71zgPwCVLJNhrcmg0PM
         mgFYdGus1pqMz94/GEjuHfnjIW/fdCKp+bV6/ryVolshR2dFKuydhayPz0VrwyIT0GGX
         6GaEWvvOxTXE7hCUGMTlnJFchbbOWRM3+C5Xme5G4ezpEcIQr6VcoDswjuNBNZ5E7aPx
         KdHQ==
X-Gm-Message-State: AOAM5305da+QVpC4cq6opyg/D+ss7sZxb08zUVEaP/Sw6QtVxVTly76O
        JM3U84grmCnhu/3LCUjHIHMCEvWGCOdniQ==
X-Google-Smtp-Source: ABdhPJzuch/i5PtXeUfpilPZbG0Ojdf8xS0zPST9o6TFZXb4i9S7hdqyz7HtmT5xcBIsyArbi7vBqw==
X-Received: by 2002:a17:90b:4f91:b0:1cd:3a73:3a5d with SMTP id qe17-20020a17090b4f9100b001cd3a733a5dmr2216377pjb.98.1650083153061;
        Fri, 15 Apr 2022 21:25:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h5-20020a17090a648500b001cd5137217fsm6115627pjj.47.2022.04.15.21.25.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 21:25:52 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     palmer@dabbelt.com, Al Viro <viro@zeniv.linux.org.uk>,
        ebiederm@xmission.com, paul.walmsley@sifive.com,
        aou@eecs.berkeley.edu, niklas.cassel@wdc.com
Cc:     Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        vapier@gentoo.org, gerg@linux-m68k.org, linux-mm@kvack.org,
        stable@vger.kernel.org, damien.lemoal@opensource.wdc.com,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2] binfmt_flat: do not stop relocating GOT entries prematurely on riscv
Date:   Fri, 15 Apr 2022 21:25:07 -0700
Message-Id: <165008310452.2715005.9013061971753495821.b4-ty@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220414091018.896737-1-niklas.cassel@wdc.com>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Apr 2022 11:10:18 +0200, Niklas Cassel wrote:
> bFLT binaries are usually created using elf2flt.
> 
> The linker script used by elf2flt has defined the .data section like the
> following for the last 19 years:
> 
> .data : {
> 	_sdata = . ;
> 	__data_start = . ;
> 	data_start = . ;
> 	*(.got.plt)
> 	*(.got)
> 	FILL(0) ;
> 	. = ALIGN(0x20) ;
> 	LONG(-1)
> 	. = ALIGN(0x20) ;
> 	...
> }
> 
> [...]

Applied to for-next/execve, thanks!

[1/1] binfmt_flat: do not stop relocating GOT entries prematurely on riscv
      https://git.kernel.org/kees/c/a767e6fd68d2

-- 
Kees Cook

