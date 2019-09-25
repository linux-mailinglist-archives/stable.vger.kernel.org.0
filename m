Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D62FBDC23
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 12:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387531AbfIYKZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 06:25:21 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53664 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389010AbfIYKZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 06:25:20 -0400
Received: by mail-wm1-f68.google.com with SMTP id i16so4663894wmd.3
        for <stable@vger.kernel.org>; Wed, 25 Sep 2019 03:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YsAAEdAnYhuD24RBj5UQt7anrWgvey/6pgyZTzvHDNQ=;
        b=UYwl+PkyE4LyhX9Bwrtb55DJgg0t6nDhFP4+vHYPs9lVb6ey6p7/I5j20teQl4ZfpR
         Nk2jXO+EBFUtoef2hQdcvhCtLvcSZorF8q/9g5rWe9wlwTXl3Q8HkLxvmoumVf0eRrJu
         b2E6WjNKME9ZLlZiD68k3jAe/290lCuRcyNDTDSxFv2j4Sm/YKV0bZPpv6BNUQFVrTlk
         ar60ZfEexPr6n+3URWiNaDFmUFACj81yMsBRbamdwi0AwjhWif1dJEMu1tMGuntCU1ZW
         p/gpStXXnCVfS4sN93ObS7XF8txCNS32KWSMhkX6+8Cux29ANksMX5NcbsJpj+6hhz75
         uXVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YsAAEdAnYhuD24RBj5UQt7anrWgvey/6pgyZTzvHDNQ=;
        b=IqDYBcrCOZF78uzU2h/a27Zsy5GCukS5u8XSB1wvmLPIeqyFUbIZdq+CPS/1OuMySq
         fDrdF36WkxmPBtAqHx3lwFYmSbofZVEfTR+fqVbcupSPEVICUh0aoIPrU5+v7k/f3rYc
         99vNi1ZeufmDAQ4IbMI+prpcI4knC9bD2UYhk7kuo43FfWWYHwYhhay+4iUhyJ/BNchg
         YnaO+O9lDrF2+GhRWMEagiqtZ94NUN9ROr7ow4OHNjx7I5Bm7TpjbUsJEEpPQefQwu1M
         KJjnYLngIzXiOw/kceQ1aTBbBUFmVw+TaglL2u5jvjnF0vLN53SqBTtZxZp4APVmjvTV
         YZAg==
X-Gm-Message-State: APjAAAXudpDlZkwYFO9jCYhtiAgTEETgOJ9lEM/OC8+92sQfPjZ+u/cA
        yfvHsaDe1prBSPfqyirC3Ovxqx5zj5rjUGenbMRgtg==
X-Google-Smtp-Source: APXvYqyMgrnfISClQMEiMxR6OyDaNMbH+h4WHpY7n7XWx+b/qrWGNgEE7v4W9or4yhiQx8R3PWEvEbMpiqSBoVaZx9w=
X-Received: by 2002:a1c:e906:: with SMTP id q6mr6505018wmc.136.1569407117052;
 Wed, 25 Sep 2019 03:25:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190925101622.31457-1-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20190925101622.31457-1-jarkko.sakkinen@linux.intel.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 25 Sep 2019 12:25:05 +0200
Message-ID: <CAKv+Gu9xLXWj8e70rs6Oy3aT_+qvemMJqtOETQG+7z==Nf_RcQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] efi+tpm: Don't access event->count when it isn't mapped.
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-integrity <linux-integrity@vger.kernel.org>,
        Peter Jones <pjones@redhat.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Lyude Paul <lyude@redhat.com>,
        Matthew Garrett <mjg59@google.com>,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Bartosz Szczepanek <bsz@semihalf.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 25 Sep 2019 at 12:16, Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> From: Peter Jones <pjones@redhat.com>
>
> Some machines generate a lot of event log entries.  When we're
> iterating over them, the code removes the old mapping and adds a
> new one, so once we cross the page boundary we're unmapping the page
> with the count on it.  Hilarity ensues.
>
> This patch keeps the info from the header in local variables so we don't
> need to access that page again or keep track of if it's mapped.
>
> Fixes: 44038bc514a2 ("tpm: Abstract crypto agile event size calculations")
> Cc: linux-efi@vger.kernel.org
> Cc: linux-integrity@vger.kernel.org
> Cc: stable@vger.kernel.org
> Signed-off-by: Peter Jones <pjones@redhat.com>
> Tested-by: Lyude Paul <lyude@redhat.com>
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> Acked-by: Matthew Garrett <mjg59@google.com>
> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Thanks Jarkko.

Shall I take these through the EFI tree?


> ---
>  include/linux/tpm_eventlog.h | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/tpm_eventlog.h b/include/linux/tpm_eventlog.h
> index 63238c84dc0b..12584b69a3f3 100644
> --- a/include/linux/tpm_eventlog.h
> +++ b/include/linux/tpm_eventlog.h
> @@ -170,6 +170,7 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
>         u16 halg;
>         int i;
>         int j;
> +       u32 count, event_type;
>
>         marker = event;
>         marker_start = marker;
> @@ -190,16 +191,22 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
>         }
>
>         event = (struct tcg_pcr_event2_head *)mapping;
> +       /*
> +        * the loop below will unmap these fields if the log is larger than
> +        * one page, so save them here for reference.
> +        */
> +       count = READ_ONCE(event->count);
> +       event_type = READ_ONCE(event->event_type);
>
>         efispecid = (struct tcg_efi_specid_event_head *)event_header->event;
>
>         /* Check if event is malformed. */
> -       if (event->count > efispecid->num_algs) {
> +       if (count > efispecid->num_algs) {
>                 size = 0;
>                 goto out;
>         }
>
> -       for (i = 0; i < event->count; i++) {
> +       for (i = 0; i < count; i++) {
>                 halg_size = sizeof(event->digests[i].alg_id);
>
>                 /* Map the digest's algorithm identifier */
> @@ -256,8 +263,9 @@ static inline int __calc_tpm2_event_size(struct tcg_pcr_event2_head *event,
>                 + event_field->event_size;
>         size = marker - marker_start;
>
> -       if ((event->event_type == 0) && (event_field->event_size == 0))
> +       if (event_type == 0 && event_field->event_size == 0)
>                 size = 0;
> +
>  out:
>         if (do_mapping)
>                 TPM_MEMUNMAP(mapping, mapping_size);
> --
> 2.20.1
>
