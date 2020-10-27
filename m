Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFA629CB61
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 22:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374233AbgJ0Vlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 17:41:47 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43059 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374232AbgJ0Vlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 17:41:47 -0400
Received: by mail-pl1-f195.google.com with SMTP id o9so1454095plx.10
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 14:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:content-transfer-encoding:in-reply-to:references
         :subject:from:cc:to:date:message-id:user-agent;
        bh=DN4kDCSad9lnUv5vOdmBOk2mysJeXI+QHEkCgEoLoNk=;
        b=nz9EHAY5tJ/YwXSSE6PfnYtv8kVjif3K7XxWSTDYdYRn+C1XrdDG7ztjGrZDKsQ0+a
         azZT7GR+osE9Lulsv0oAHIbEg4GSxJEaovaXrhF3hdTysYMKIa0XlGJzNtWpgHT6j82l
         KbDyRJ7sxEcwDpY2skZnlzuMl+gl4qOs9qpsQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:content-transfer-encoding
         :in-reply-to:references:subject:from:cc:to:date:message-id
         :user-agent;
        bh=DN4kDCSad9lnUv5vOdmBOk2mysJeXI+QHEkCgEoLoNk=;
        b=FzskGCX4si3vFRPfGUA+H7UuyYJRk5CXNrGbbaQCrZH781otXzbt3X4x7sIH7EGqcN
         cNnKnwYoJiAG0kINngZm4iN++PhdFPD9hN1WFe1zgRUyZwchki23OrIps8v9HOKgKYpK
         hsRvm6Zblm/6GcN2ZFyRJL0TZLHaM87WN58uYlEfwAzxswJPMKiIXAr1XM049NXJcCds
         NQL9PW3mEIsO+SDJDHazExSHfjo+pJPEN70I1yJZjRNif0OY3sDi+YkM4Hia2rwTF0mE
         tel6XGMWSq+EQXKct6GEKEYVrXbj+Jxyo9eIOEfHJikWg8MpPKpVjuylqeF36edlZRk0
         uuWA==
X-Gm-Message-State: AOAM532twlW/USg5GrwG5JNsC6usLZbqRCiqMQw77Euse9gnKXJie0Nz
        NP/DosWTu+/nhOtbOWHFyAlahXlxq/nrdw==
X-Google-Smtp-Source: ABdhPJwI1bs0gyb9imppDCOtDCYE4wA79TThXnRv4K1AiEzMqIvD7H3p41lamI4ez/e5WDlfjU+wmQ==
X-Received: by 2002:a17:90b:3103:: with SMTP id gc3mr3854727pjb.158.1603834905243;
        Tue, 27 Oct 2020 14:41:45 -0700 (PDT)
Received: from chromium.org ([2620:15c:202:201:3e52:82ff:fe6c:83ab])
        by smtp.gmail.com with ESMTPSA id u7sm3285106pfn.37.2020.10.27.14.41.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 14:41:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20201026132533.GC24349@willie-the-truck>
References: <20201023154751.1973872-1-swboyd@chromium.org> <20201026132533.GC24349@willie-the-truck>
Subject: Re: [PATCH v3] KVM: arm64: ARM_SMCCC_ARCH_WORKAROUND_1 doesn't return SMCCC_RET_NOT_REQUIRED
From:   Stephen Boyd <swboyd@chromium.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andre Przywara <andre.przywara@arm.com>,
        Steven Price <steven.price@arm.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org
To:     Will Deacon <will@kernel.org>
Date:   Tue, 27 Oct 2020 14:41:43 -0700
Message-ID: <160383490303.884498.18303417191821273905@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Quoting Will Deacon (2020-10-26 06:25:33)
> On Fri, Oct 23, 2020 at 08:47:50AM -0700, Stephen Boyd wrote:
> > diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
> > index 15c706fb0a37..0e50ba3e88d7 100644
> > --- a/include/linux/arm-smccc.h
> > +++ b/include/linux/arm-smccc.h
> > @@ -86,6 +86,8 @@
> >                          ARM_SMCCC_SMC_32,                            \
> >                          0, 0x7fff)
> > =20
> > +#define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED 1
>=20
> I thought we'd stick this in asm/spectre.h, but here is also good:
>=20
> Acked-by: Will Deacon <will@kernel.org>
>=20

Ah sorry I glossed over that one. I suppose it can be moved during patch
application if desired.
