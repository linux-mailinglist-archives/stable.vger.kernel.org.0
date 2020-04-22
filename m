Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA911B476C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 16:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgDVOfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 10:35:55 -0400
Received: from mga17.intel.com ([192.55.52.151]:64109 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727868AbgDVOfz (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 10:35:55 -0400
IronPort-SDR: oV8hALOPIeLrauz3mfJvucmiVqo6GcKFeR+Y3eiaG+dl5TGEyO7hX9y61QHuHhqbf/6jYY3mc/
 HaNI7WaSogFw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 07:35:54 -0700
IronPort-SDR: WlTpxIToC63ZaYpO79c+hXOuLKvvFtmdV2ETux+G/lHPyZnaS4Ssrn2O84pniFCkKuBXEOjZjL
 c38dSwyBRPnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,414,1580803200"; 
   d="scan'208";a="259086733"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga006.jf.intel.com with ESMTP; 22 Apr 2020 07:35:54 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 34EA63019B5; Wed, 22 Apr 2020 07:35:54 -0700 (PDT)
Date:   Wed, 22 Apr 2020 07:35:54 -0700
From:   Andi Kleen <ak@linux.intel.com>
To:     John Haxby <john.haxby@oracle.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] x86/fpu: Allow clearcpuid= to clear several bits
Message-ID: <20200422143554.GI608746@tassilo.jf.intel.com>
References: <cover.1587555769.git.john.haxby@oracle.com>
 <03a3a4d135b17115db9ad91413e21af73e244500.1587555769.git.john.haxby@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03a3a4d135b17115db9ad91413e21af73e244500.1587555769.git.john.haxby@oracle.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Thanks good catch.

>  	if (cmdline_find_option(boot_command_line, "clearcpuid", arg,
> -				sizeof(arg)) &&
> -	    get_option(&argptr, &bit) &&
> -	    bit >= 0 &&
> -	    bit < NCAPINTS * 32)
> -		setup_clear_cpu_cap(bit);
> +				sizeof(arg))) {
> +		/* cpuid bit numbers are mostly three digits */
> +		enum  { nints = sizeof(arg)/(3+1) + 1 };

Not sure what the digits have to do with the stack space of an int array.

We should have enough stack to afford some more than 8.

Would be good to have a warning if the arguments are longer.

Maybe it would be simpler to fix the early arg parser
to allow multiple instances again? That would also avoid the limit,
and keep everything compatible.

-Andi


> +		int i, bits[nints];
> +
> +		get_options(arg, nints, bits);
> +		for (i = 1; i <= bits[0]; i++) {
> +			if (bits[i] >= 0 && bits[i] < NCAPINTS * 32)
> +				setup_clear_cpu_cap(bits[i]);
> +		}
> +	}
>  }
>  
>  /*
> -- 
> 2.25.3
> 
