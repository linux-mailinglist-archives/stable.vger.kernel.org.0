Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4CE501F0B
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 01:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232351AbiDNXaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 19:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiDNXaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 19:30:09 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501873FBDC
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 16:27:40 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w7so6081762pfu.11
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 16:27:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=HmZzQaJcWVmRJdxQhHXzNCOEJRKn8oL9PGuKLwC4Vpk=;
        b=d1VKqQJQtATMIHplVI4UJ3GOGV6h5gR9y1TJbLwrVNFwoDKD6c3KLTeTwWyhfX1b6/
         bn2wbRksRbvFqps2Uu35fOeZnbu5K9rKtmY+viXPnznVSB3PctbOWHhOOVKsQHaCEU7B
         I4T6uDq4ftL4iKujE5TZsbCs9tuSrg5t8Ve7Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HmZzQaJcWVmRJdxQhHXzNCOEJRKn8oL9PGuKLwC4Vpk=;
        b=aS5up6/YSUUCHWhPTqJeeuJJWNMtQ114rnm77lcmfQcxwMrWFLAUdPHD2xo2kGQ41z
         a9i8oQlh2AoHaewvRtSHcXaNcdf/bhVeOOaHUNyIMG1NUcm6seAKC0EyKg1pZXoJBBbr
         0rjiVEshFVq82aEakIn+4LegmR20caSws5a99QFjCGs4ObSGHGF3xSBsgAZi7QPzb1Yu
         dPXK7OCBUO2aaTJCVuaRic/RqCiaK20ZCaKTnjm5QNnOcxf7+ZOMO6y+gBhsUiyysvA4
         ysItlwrCB6P7yvugfpUeIaS1/zQRe7Oz0QGwv1S7k8EWS75+q1uWDh5u6aXPxGBm+Lfz
         njpA==
X-Gm-Message-State: AOAM530NKQS/tSLt3GYrLf9JCQvB4BZpStDmAip5u3EUhcKz0g+XuX0j
        3lZLK8SXF5NrcdQxeI8Wtnfx1Nj8oDhpUA==
X-Google-Smtp-Source: ABdhPJzq0A/ZN73+dcU0JnfCl1TVr6vkBK+NJGz++LvwQCH3lxWX0dgKyG5WwEKfaEtKzf1QfZl+4w==
X-Received: by 2002:a63:3e88:0:b0:39d:ae86:237d with SMTP id l130-20020a633e88000000b0039dae86237dmr4132709pga.360.1649978859862;
        Thu, 14 Apr 2022 16:27:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id e12-20020a056a0000cc00b00508343a6f9esm902728pfj.5.2022.04.14.16.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 16:27:39 -0700 (PDT)
Date:   Thu, 14 Apr 2022 16:27:38 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        stable@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Message-ID: <202204141624.6689D6B@keescook>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414091018.896737-1-niklas.cassel@wdc.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 11:10:18AM +0200, Niklas Cassel wrote:
> bFLT binaries are usually created using elf2flt.
> [...]

Hm, something in the chain broke DKIM, but I can't see what:

  ✗ [PATCH v2] binfmt_flat: do not stop relocating GOT entries prematurely on riscv
    ✗ BADSIG: DKIM/wdc.com

Konstantin, do you have a process for debugging these? I don't see the
"normal" stuff that breaks DKIM (i.e. a trailing mailing list footer, etc)

-- 
Kees Cook
