Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 444BB12F5F2
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 10:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgACJMU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 04:12:20 -0500
Received: from foss.arm.com ([217.140.110.172]:54020 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgACJMU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jan 2020 04:12:20 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 264C61FB;
        Fri,  3 Jan 2020 01:12:19 -0800 (PST)
Received: from [192.168.1.18] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 918673F703;
        Fri,  3 Jan 2020 01:12:17 -0800 (PST)
Subject: Re: [PATCH v2] MIPS: Avoid VDSO ABI breakage due to global register
 variable
To:     Paul Burton <paulburton@kernel.org>
Cc:     linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <christian.brauner@canonical.com>,
        stable@vger.kernel.org
References: <20200102005343.GA495913@rani.riverdale.lan>
 <20200102045038.102772-1-paulburton@kernel.org>
 <754c5d05-4455-5ce1-475d-55c2191a06cf@arm.com>
 <20200103004229.lpbhocebuny6vxmf@lantea.localdomain>
From:   Vincenzo Frascino <vincenzo.frascino@arm.com>
Message-ID: <fce2be75-9a68-37eb-723a-99d010e77132@arm.com>
Date:   Fri, 3 Jan 2020 09:15:10 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200103004229.lpbhocebuny6vxmf@lantea.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Paul,

On 1/3/20 12:42 AM, Paul Burton wrote:
> Using -ffixed-gp wouldn't be correct for the VDSO - the VDSO itself is
> position independent code, and will need to use $gp to access the GOT
> which is part of how position-independence is achieved (technically you
> could access the GOT using another register of course but you'd need
> some way to persuade the compiler to break with convention & you'd gain
> nothing meaningful since you'd need to use some other register anyway).
> If we use -ffixed-gp then we're telling GCC not to use $gp, and that
> doesn't make sense. If we consider -ffixed-gp as telling GCC not to use
> $gp as a general purpose register then it's meaningless because $gp
> already has a specific use & isn't used as a general purpose register.
> If we consider -ffixed-gp as telling GCC not to use $gp at all then it
> doesn't make sense because it needs to in order to access the GOT.
> 
> In terms of GCC's flags we'd want to use -fcall-saved-gp, but that would
> just be telling GCC information it already knows about the n32 & n64
> ABIs & indeed it seems to have no effect at all on the way GCC handles
> the global register variable - it doesn't cause gcc to save & restore
> $gp with the global register variable present, so you gain nothing.
> 
> We could use -ffixed-gp for the kernel proper (& not the VDSO), but:
> 
> 1) The kernel builds as non-PIC code with no $gp-based optimizations
>    enabled, and since this has been fine forever it seems safe to expect
>    the compiler not to start using $gp in new ways.
> 
> 2) It would be a separate issue to fixing the VDSO anyway.

Makes totally sense. Thanks for the explanation.

-- 
Regards,
Vincenzo
