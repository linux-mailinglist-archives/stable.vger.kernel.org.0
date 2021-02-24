Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDE13238B2
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 09:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhBXIef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 03:34:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57628 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234440AbhBXIe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Feb 2021 03:34:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614155563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tosWfJmphilCKxBktntRSANHnNWbRuatRNtiQIJTl70=;
        b=H7oKIaCBzEmBom/Y7/tRrYwoYzQnuE/usqXFMrEQNKsApbR84ZjqDF0jknS+uLzQ50Q3Qr
        omBOO30ikDNND9MAyMg/JFNeFJhJqtbotyShae8xsZg8hj0/q5KY9qcnFk4k7WTz1DuIY9
        NpYTLYftfVx0vZhkVujnyUwI86pPJ84=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-X-r8_EE_NweP0oEnuxO4qg-1; Wed, 24 Feb 2021 03:32:39 -0500
X-MC-Unique: X-r8_EE_NweP0oEnuxO4qg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE1AAEC1C3;
        Wed, 24 Feb 2021 08:32:37 +0000 (UTC)
Received: from krava (unknown [10.40.194.14])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4BBBC10016DB;
        Wed, 24 Feb 2021 08:32:36 +0000 (UTC)
Date:   Wed, 24 Feb 2021 09:32:35 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Kun-Chuan Hsieh <jetswayss@gmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, jolsa@kernel.org,
        andrii@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] tools/resolve_btfids: Fix build error with older host
 toolchains
Message-ID: <YDYPIyk6mE+A7K7L@krava>
References: <20210224052752.5284-1-jetswayss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210224052752.5284-1-jetswayss@gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 24, 2021 at 05:27:52AM +0000, Kun-Chuan Hsieh wrote:
> Older libelf.h and glibc elf.h might not yet define the ELF compression
> types.
> 
> Checking and defining SHF_COMPRESSED fix the build error when compiling
> with older toolchains. Also, the tool resolve_btfids is compiled with host
> toolchain. The host toolchain is more likely to be older than the cross
> compile toolchain.
> 
> Cc: stable@vger.kernel.org
> 
> Signed-off-by: Kun-Chuan Hsieh <jetswayss@gmail.com>

Acked-by: Jiri Olsa <jolsa@redhat.com>

thanks,
jirka

> ---
>  tools/bpf/resolve_btfids/main.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> index 7409d7860aa6..80d966cfcaa1 100644
> --- a/tools/bpf/resolve_btfids/main.c
> +++ b/tools/bpf/resolve_btfids/main.c
> @@ -260,6 +260,11 @@ static struct btf_id *add_symbol(struct rb_root *root, char *name, size_t size)
>  	return btf_id__add(root, id, false);
>  }
>  
> +/* Older libelf.h and glibc elf.h might not yet define the ELF compression types. */
> +#ifndef SHF_COMPRESSED
> +#define SHF_COMPRESSED (1 << 11) /* Section with compressed data. */
> +#endif
> +
>  /*
>   * The data of compressed section should be aligned to 4
>   * (for 32bit) or 8 (for 64 bit) bytes. The binutils ld
> -- 
> 2.25.1
> 

