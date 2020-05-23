Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1B01DF70C
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 14:04:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387781AbgEWMEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 08:04:00 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:56763 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387741AbgEWMEA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 May 2020 08:04:00 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49Thpf3hDvz9sRK;
        Sat, 23 May 2020 22:03:53 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1590235438;
        bh=O3nhdbyrugCN8LK3q4E5ycpy4wCXqUUTYLiEp+dr1H8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=pg+pyAIbGIeLiPaclGpnk/vcjO0iw0QR2sp5m+d5FV425fNtw+B+39p82hDercUEY
         ZJ+mY0CzW0GI2xtxf/n62eTclRhJo6rzBsHYXI+Di/s4bsBjo2OTQm6pujX8uXGjVF
         bvvDM0nt+6klYh7YVceWiZEyF9uTvLqKDBnotCsHeAmlFZn4WYDrf+8QEqpv0UusCa
         JefMOnFs3OAl+D8UVcleYvVdbj675xe3insjgc8V8naXHn3nvAgV4edfa1LyDx7n3/
         77MBFSFAzN7q19WfHkXJFg7nB5DB3BAqtQwmrfwKbw6/F6PfYwoksBD+EarVTcB6h7
         pBkxFL7qn7tSw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Dan Williams <dan.j.williams@intel.com>, tglx@linutronix.de,
        mingo@redhat.com
Cc:     x86@kernel.org, stable@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Subject: Re: [PATCH v4 1/2] x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()
In-Reply-To: <159010126739.975921.6393757191247357952.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <159010126119.975921.6614194205409771984.stgit@dwillia2-desk3.amr.corp.intel.com> <159010126739.975921.6393757191247357952.stgit@dwillia2-desk3.amr.corp.intel.com>
Date:   Sat, 23 May 2020 22:04:13 +1000
Message-ID: <87mu5yg8n6.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dan,

Sorry one minor nit below.

Dan Williams <dan.j.williams@intel.com> writes:
> diff --git a/tools/testing/selftests/powerpc/copyloops/.gitignore b/tools/testing/selftests/powerpc/copyloops/.gitignore
> index ddaf140b8255..1152bcc819fe 100644
> --- a/tools/testing/selftests/powerpc/copyloops/.gitignore
> +++ b/tools/testing/selftests/powerpc/copyloops/.gitignore
> @@ -12,4 +12,4 @@ memcpy_p7_t1
>  copyuser_64_exc_t0
>  copyuser_64_exc_t1
>  copyuser_64_exc_t2
> -memcpy_mcsafe_64
> +copy_mc_to_user

Should be:

+copy_mc_64

Otherwise the powerpc bits look good to me.

Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)

cheers
