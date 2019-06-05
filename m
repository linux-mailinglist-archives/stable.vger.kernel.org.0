Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A6336337
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 20:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbfFESQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 14:16:09 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:33618 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbfFESQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 14:16:09 -0400
Received: by mail-pf1-f169.google.com with SMTP id x15so5511875pfq.0
        for <stable@vger.kernel.org>; Wed, 05 Jun 2019 11:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yy1+cFmii2s5Isli128YJK+bYVGL0e3pwrahCX2MG48=;
        b=DlN1TsnbsswLEz2RIlZoUU7bZzZiNk5nIu/5BXDfQsEC8J95oBMJ3ND4+PV2HOyATr
         AX30/lSOkXW5Qa76cUMRCpwyYOUfnNJhdgn8heG0L+oSDjw5K2DUIG/52D7Ei5By4cdg
         aJW2tjhAZYrBHj6xaEuCy2qAH0+lHLNUpXWs8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yy1+cFmii2s5Isli128YJK+bYVGL0e3pwrahCX2MG48=;
        b=b5SqVNNP1zyW37jFe9rmJTkTDz+uXixiQ0JhA4DZglbctsfTmU0j6QKXvE6LBmkprs
         oUdYGUvyyihLBbzJrxPOAOdk9BUyJorGovOeDgzVquma5KcpGoM5KTBoeQSUyvOvRltW
         w9PR9Yvqel0G+Yn6SBsc4/I+MBC83KCKGKdYP4aM0lEbQnI2bficdACGMID/6o1a5sZx
         Z+1MXp4UZ7VPffjL1lLIH5X/nGFQePb48besmV23O54V/luFC+72jXxoLUNnv2DjZhf1
         LbGnGHVrwjV/ypLJbAn5wpfVjJq/VolZFxfCROhukFUunPlybRAMjlZosIJBk3HjRUtr
         sP8A==
X-Gm-Message-State: APjAAAUsdEq9fbQTC1s0Ne1ORkgf4Z8rtuFDcgxOvRNZ3TY8dJrwr5oL
        qOqGceMo//sDxSGKsVgdQQDDCg==
X-Google-Smtp-Source: APXvYqwFyG6F43gVKfokn6PrM6BmtUpQvZrdyq2Ph68qWEkbMC1zvAMl/ICXYwcz8ET5o3bvaXtdJw==
X-Received: by 2002:a17:90a:d803:: with SMTP id a3mr46216673pjv.48.1559758568849;
        Wed, 05 Jun 2019 11:16:08 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id f21sm3575655pjq.2.2019.06.05.11.16.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Jun 2019 11:16:08 -0700 (PDT)
Date:   Wed, 5 Jun 2019 11:16:06 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Alec Ari <neotheuser@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/build: Move _etext to actual end of .text
Message-ID: <201906051114.6DEF834@keescook>
References: <CAM5Ud7NhtKDCMnf+zbsRH1N8V6=kCpEJ5NCmJ4mOQSdVA_noMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM5Ud7NhtKDCMnf+zbsRH1N8V6=kCpEJ5NCmJ4mOQSdVA_noMA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 05, 2019 at 11:08:13AM -0500, Alec Ari wrote:
> I'm having this problem too, build is failing:
> 
> Invalid absolute R_X86_64_32S relocation: _etext
> 
> I stayed on the 4.14 branch to help prevent these kind of breakages,
> so much for that idea. Gentoo GCC 8.3.0.

It seems to be a problem with the Gold linker. Using ld.bfd appears to
work. I haven't narrowed down the problem, unfortunately.

Greg, given that this change was only for special situations (Clang
CFI), can you revert this for the stable trees?

-- 
Kees Cook
