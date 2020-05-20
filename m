Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA111DAF6D
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 11:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgETJx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 05:53:58 -0400
Received: from ozlabs.org ([203.11.71.1]:57879 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgETJx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 05:53:58 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 49Rp402YYWz9sT8;
        Wed, 20 May 2020 19:53:52 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1589968435;
        bh=/SF1u7fw4ywQyV8P7dpLPnWaV4yJIIqpzxqUzkg8c6Y=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=T+hxgGBRSUegBTRkzKQh78Jwhd7vM/gf+Td+YjdjpgwMKJLsSXIB9lVyMSzWh8a/L
         UagqkLU5AXOT2G1Ha9EMwJ59WmTfO0P1DILDzLkTXuLBsvclv2ca8SH8PUbyKw9q2/
         f1YmVf9PvcpG6a+wAfpJAQl0X5Sz8nFsc4gWWB2tfHCo+MbFobpvEOrilpEW30EgaP
         HJlZtCvstHE1IxZwaWKX04MPB3uH+9GpBaVVhSlkzoln59HTISkw12E2rekiLabeHN
         6sOXFVjT5H3ZRaxqZDS0h2Dorh7kpPJNe8xqd+7HJiMh+7BPWpmuBw/xq+/qGEju2C
         DwodaOymHjJLw==
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
Subject: Re: [PATCH v3 1/2] x86, powerpc: Rename memcpy_mcsafe() to copy_mc_to_{user, kernel}()
In-Reply-To: <158992635697.403910.6957168747147028694.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <158992635164.403910.2616621400995359522.stgit@dwillia2-desk3.amr.corp.intel.com> <158992635697.403910.6957168747147028694.stgit@dwillia2-desk3.amr.corp.intel.com>
Date:   Wed, 20 May 2020 19:53:05 +1000
Message-ID: <87d06z7x1a.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dan,

Just a couple of minor things ...

Dan Williams <dan.j.williams@intel.com> writes:
> In reaction to a proposal to introduce a memcpy_mcsafe_fast()
> implementation Linus points out that memcpy_mcsafe() is poorly named
> relative to communicating the scope of the interface. Specifically what
> addresses are valid to pass as source, destination, and what faults /
> exceptions are handled. Of particular concern is that even though x86
> might be able to handle the semantics of copy_mc_to_user() with its
> common copy_user_generic() implementation other archs likely need / want
> an explicit path for this case:
...

> diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
> index 0969285996cb..dcbbcbf3552c 100644
> --- a/arch/powerpc/include/asm/uaccess.h
> +++ b/arch/powerpc/include/asm/uaccess.h
> @@ -348,6 +348,32 @@ do {								\
>  extern unsigned long __copy_tofrom_user(void __user *to,
>  		const void __user *from, unsigned long size);
>  
> +#ifdef CONFIG_ARCH_HAS_COPY_MC
> +extern unsigned long __must_check

We try not to add extern in headers anymore.

> +copy_mc_generic(void *to, const void *from, unsigned long size);
> +
> +static inline unsigned long __must_check
> +copy_mc_to_kernel(void *to, const void *from, unsigned long size)
> +{
> +	return copy_mc_generic(to, from, size);
> +}
> +#define copy_mc_to_kernel copy_mc_to_kernel
> +
> +static inline unsigned long __must_check
> +copy_mc_to_user(void __user *to, const void *from, unsigned long n)
> +{
> +	if (likely(check_copy_size(from, n, true))) {
> +		if (access_ok(to, n)) {
> +			allow_write_to_user(to, n);
> +			n = copy_mc_generic((void *)to, from, n);
> +			prevent_write_to_user(to, n);
> +		}
> +	}
> +
> +	return n;
> +}
> +#endif

Otherwise that looks fine.

...

> diff --git a/tools/testing/selftests/powerpc/copyloops/Makefile b/tools/testing/selftests/powerpc/copyloops/Makefile
> index 0917983a1c78..959817e7567c 100644
> --- a/tools/testing/selftests/powerpc/copyloops/Makefile
> +++ b/tools/testing/selftests/powerpc/copyloops/Makefile
> @@ -45,9 +45,9 @@ $(OUTPUT)/memcpy_p7_t%:	memcpy_power7.S $(EXTRA_SOURCES)
>  		-D SELFTEST_CASE=$(subst memcpy_p7_t,,$(notdir $@)) \
>  		-o $@ $^
>  
> -$(OUTPUT)/memcpy_mcsafe_64: memcpy_mcsafe_64.S $(EXTRA_SOURCES)
> +$(OUTPUT)/copy_mc: copy_mc.S $(EXTRA_SOURCES)
>  	$(CC) $(CPPFLAGS) $(CFLAGS) \
> -		-D COPY_LOOP=test_memcpy_mcsafe \
> +		-D COPY_LOOP=test_copy_mc \

This needs a fixup:

diff --git a/tools/testing/selftests/powerpc/copyloops/Makefile b/tools/testing/selftests/powerpc/copyloops/Makefile
index 959817e7567c..b4eb5c4c6858 100644
--- a/tools/testing/selftests/powerpc/copyloops/Makefile
+++ b/tools/testing/selftests/powerpc/copyloops/Makefile
@@ -47,7 +47,7 @@ $(OUTPUT)/memcpy_p7_t%:	memcpy_power7.S $(EXTRA_SOURCES)
 
 $(OUTPUT)/copy_mc: copy_mc.S $(EXTRA_SOURCES)
 	$(CC) $(CPPFLAGS) $(CFLAGS) \
-		-D COPY_LOOP=test_copy_mc \
+		-D COPY_LOOP=test_copy_mc_generic \
 		-o $@ $^
 
 $(OUTPUT)/copyuser_64_exc_t%: copyuser_64.S exc_validate.c ../harness.c \


>  		-o $@ $^
>  
>  $(OUTPUT)/copyuser_64_exc_t%: copyuser_64.S exc_validate.c ../harness.c \
> diff --git a/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S b/tools/testing/selftests/powerpc/copyloops/copy_mc.S
> similarity index 100%
> rename from tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S
> rename to tools/testing/selftests/powerpc/copyloops/copy_mc.S

This file is a symlink to the file in arch/powerpc/lib, so the name of
the link needs updating, as well as the target.

Also is there a reason you dropped the "_64"? It would make most sense
to keep it I think, as then the file in selftests and the file in arch/
have the same name.

If you want to keep the copy_mc.S name it needs the diff below. Though
as I said I think it would be better to use copy_mc_64.S.

cheers


diff --git a/tools/testing/selftests/powerpc/copyloops/copy_mc.S b/tools/testing/selftests/powerpc/copyloops/copy_mc.S
new file mode 120000
index 000000000000..dcbe06d500fb
--- /dev/null
+++ b/tools/testing/selftests/powerpc/copyloops/copy_mc.S
@@ -0,0 +1 @@
+../../../../../arch/powerpc/lib/copy_mc_64.S
\ No newline at end of file
diff --git a/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S b/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S
deleted file mode 120000
index f0feef3062f6..000000000000
--- a/tools/testing/selftests/powerpc/copyloops/memcpy_mcsafe_64.S
+++ /dev/null
@@ -1 +0,0 @@
-../../../../../arch/powerpc/lib/memcpy_mcsafe_64.S
\ No newline at end of file
-- 
2.25.1


