Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA871FFD0A
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 23:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgFRVBz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jun 2020 17:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbgFRVBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jun 2020 17:01:55 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A29BC06174E;
        Thu, 18 Jun 2020 14:01:55 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id dr13so7903308ejc.3;
        Thu, 18 Jun 2020 14:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/pSg+CjVVGDmkJgSAWGcUvsAuaB+HD/87Cz0ih1iEpU=;
        b=PLb5yOPFdttKNB7R79USKjGUc6xJvIlhZqG+6dY5T4MJMkja97YVPqO+VSTT/MP9BC
         VhKNgCL/UdQeqWQ44SWAUxDfJSr0Oxs6mPorLGZDnq4kdo2ExhUoMSBG3VN3AUlstCy7
         mjhlDXSgDAZiv8qjLEcuOBxTeO2lZ4T+DUgGf3CmeTxaF87+K23NqjjR/JhyexUBycN7
         C013wGARBTw1P0OoO36i1zedNrT8Jz5IGC1BJuzLM20q9H+Gp6tCPmKhxfLwQjGeh6gm
         7Rh9cMIQZVKkbZHFnGg42SctEGeuL4SbcMi/gl+DX5ADL1/ocrDljJhq7BnwVmC/TXOI
         6cuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/pSg+CjVVGDmkJgSAWGcUvsAuaB+HD/87Cz0ih1iEpU=;
        b=ClPj4HiYlGMuWTBvsrLpx7zZfHbXBpJnZH9T2E80r8Ge31sKYMjeJHJ1POnPwmvXbR
         fXJl2ZEGQ4t3XCxM2n8Po2osnkaz+lF/Ugiiq+sJhZ58cNvJ/wxvAeqNBxCRELxhr0ft
         WcoomjedFgSMv2JshcAChcafEJL58uTKzPkS1Ahg0KplwEqP+kgPpF9bfo1cAB5NZqoe
         fneLfTrIoVzw0ohzWP/eg5QC8KmBAdQUWG6k1icwhIZEn0ECTgd2fou33TJByqyX64Uv
         Ku98f2t3Zv00NUMJJ9E1h2LCLA2znFPoR6drDpw89XjUzZC3EhcsxKKyzccFlgDjtuSB
         p9IA==
X-Gm-Message-State: AOAM533Qww6KVTkWFO5u1ZjFsqpUWu0/dUbfJIACZ2tQFk/fqtfUNN/v
        cdth1Fy3o7EuFCtfogAdITsun5Y=
X-Google-Smtp-Source: ABdhPJxFMaX1igYF/2oYZFm9JCYMhnUSwHbNoa+JbsF9ix71XlOeB9rMQ3F27PPCT+1Hr7sPKSN9ew==
X-Received: by 2002:a17:906:4e59:: with SMTP id g25mr583619ejw.60.1592514113829;
        Thu, 18 Jun 2020 14:01:53 -0700 (PDT)
Received: from localhost.localdomain ([46.53.250.254])
        by smtp.gmail.com with ESMTPSA id z15sm3133755eju.18.2020.06.18.14.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 14:01:53 -0700 (PDT)
Date:   Fri, 19 Jun 2020 00:01:51 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     'Matt Fleming' <matt@codeblueprint.co.uk>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Grimm, Jon" <Jon.Grimm@amd.com>,
        "Kumar, Venkataramanan" <Venkataramanan.Kumar@amd.com>,
        Jan Kara <jack@suse.cz>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/asm/64: Align start of __clear_user() loop to
 16-bytes
Message-ID: <20200618210151.GA2212102@localhost.localdomain>
References: <20200618102002.30034-1-matt@codeblueprint.co.uk>
 <39f8304b75094f87a54ace7732708d30@AcuMS.aculab.com>
 <20200618131655.GA24607@localhost.localdomain>
 <20b0166e11f44bf491062838090b93be@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20b0166e11f44bf491062838090b93be@AcuMS.aculab.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 18, 2020 at 04:39:35PM +0000, David Laight wrote:
> From: Alexey Dobriyan 
> > Sent: 18 June 2020 14:17
> ...
> > > > diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
> > > > index fff28c6f73a2..b0dfac3d3df7 100644
> > > > --- a/arch/x86/lib/usercopy_64.c
> > > > +++ b/arch/x86/lib/usercopy_64.c
> > > > @@ -24,6 +24,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
> > > >  	asm volatile(
> > > >  		"	testq  %[size8],%[size8]\n"
> > > >  		"	jz     4f\n"
> > > > +		"	.align 16\n"
> > > >  		"0:	movq $0,(%[dst])\n"
> > > >  		"	addq   $8,%[dst]\n"
> > > >  		"	decl %%ecx ; jnz   0b\n"
> > >
> > > You can do better that that loop.
> > > Change 'dst' to point to the end of the buffer, negate the count
> > > and divide by 8 and you get:
> > > 		"0:	movq $0,($[dst],%%ecx,8)\n"
> > > 		"	add $1,%%ecx"
> > > 		"	jnz 0b\n"
> > > which might run at one iteration per clock especially on cpu that pair
> > > the add and jnz into a single uop.
> > > (You need to use add not inc.)
> > 
> > /dev/zero should probably use REP STOSB etc just like everything else.
> 
> Almost certainly it shouldn't, and neither should anything else.
> Potentially it could use whatever memset() is patched to.
> That MIGHT be 'rep stos' on some cpu variants, but in general
> it is slow.

Yes, that's what I meant: alternatives choosing REP variant.
memset loops are so 21-st century.
