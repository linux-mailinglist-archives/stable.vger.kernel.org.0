Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 038F23728F
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 13:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfFFLOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 07:14:30 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:36522 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726092AbfFFLOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 07:14:30 -0400
Received: by mail-vs1-f67.google.com with SMTP id l20so963853vsp.3;
        Thu, 06 Jun 2019 04:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=L5FE5LHOBYJ1vqOcaxoTV/ufmCOkGPMOAnLLWxUn+gY=;
        b=j6waIAVh+7I7LbSs6indYXCkDPotzrrRDLsA+F4sDLBWtJL3TsPuG6Cfix8X5jhydi
         1nHBjeU8sKI9aBx02rKHi/WWzd5a44li70bDN1jADnMsjHfcqFgX7EIOWI/Rsvw0TzUO
         SV5dXi4T+fhJdsIu+dpmPfzSmPNbfpgqLNt9dojAR685jhKeUMLlYhXOw5GAM3Vbrols
         bHNs84nmGkIVOUORoXRALz0koH31pfqIf14kQh4mlryyIhBkTBgyCu0dhUBHqCvTXSfO
         4yOZ9To+JFs1e7F9f51G9MKcthaaWtthW+1jj9jn32Jv2OGfaLP5O5IZiQ3L4kv3RCGS
         O9vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=L5FE5LHOBYJ1vqOcaxoTV/ufmCOkGPMOAnLLWxUn+gY=;
        b=JK4OZG1CAeIUCLqvDFcfJM5/81C2OOyqbMM/2L5JpY82ef23aMibp7xIrTVrxxEqdV
         a3k/5GhnvQFiPGfA/sYYO80KykDb/pllLb9gS/SI5PdFHEuQogMoh2RDENRg/uH2XyDi
         cba5Dj9/5RGJQyql0q2mbAN7O7Lkq+wGOUE5rtz2pwlHEnSFdkBjuJb0czd1oog7stC+
         qIKCCutW2kmbFPa5YLjP2R9Xnz2r0lJEEWOWU+NKGWNYW1KERwdQGdU02Z3KRbJRNBoj
         /nLTSH2DWmaI6D1TWey77elZl0nRIv7HRZkvRfq82GcGcjojNA479iBEJ6MhnIKNPu0P
         CEGw==
X-Gm-Message-State: APjAAAXbQZb5KCcGX4MKQjAkXainacNVXSjT8m4+dtVI9X2RMcxyKALF
        yskaYvlAKhLWMwh4YJ1IQoqOmGYGrN1Zii4V+JJ2zA==
X-Google-Smtp-Source: APXvYqy9uzi9cGdb1ix/cem/VdxXMljSqCtPw43u5DGU7D9Nn12APz7z2DBpxQr/ZH15do8OGNwsevWPMle40YMAzJc=
X-Received: by 2002:a67:d990:: with SMTP id u16mr765451vsj.95.1559819669355;
 Thu, 06 Jun 2019 04:14:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190606075444.15481-1-naohiro.aota@wdc.com>
In-Reply-To: <20190606075444.15481-1-naohiro.aota@wdc.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Thu, 6 Jun 2019 12:14:18 +0100
Message-ID: <CAL3q7H6ZD=SCcj_dOB6b+8xPTXpq5dTv58Mb4C4qPn1Cx9XOtA@mail.gmail.com>
Subject: Re: [PATCH] btrfs: start readahead also in seed devices
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 6, 2019 at 8:56 AM Naohiro Aota <naohiro.aota@wdc.com> wrote:
>
> Currently, btrfs does not consult seed devices to start readahead. As a
> result, if readahead zone is added to the seed devices, btrfs_reada_wait(=
)
> indefinitely wait for the reada_ctl to finish.
>
> You can reproduce the hung by modifying btrfs/163 to have larger initial
> file size (e.g. xfs_io pwrite 4M instead of current 256K).

Are you planning on submitting a patch for the test case as well, so
that it writes at least 4Mb?
Would be useful to have.

>
> Fixes: 7414a03fbf9e ("btrfs: initial readahead code and prototypes")
> Cc: stable@vger.kernel.org # 3.2+: ce7791ffee1e: Btrfs: fix race between =
readahead and device replace/removal
> Cc: stable@vger.kernel.org # 3.2+
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Reviewed-by: Filipe Manana <fdmanana@suse.com>

Looks good, thanks.

> ---
>  fs/btrfs/reada.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/btrfs/reada.c b/fs/btrfs/reada.c
> index 10d9589001a9..bb5bd49573b4 100644
> --- a/fs/btrfs/reada.c
> +++ b/fs/btrfs/reada.c
> @@ -747,6 +747,7 @@ static void __reada_start_machine(struct btrfs_fs_inf=
o *fs_info)
>         u64 total =3D 0;
>         int i;
>
> +again:
>         do {
>                 enqueued =3D 0;
>                 mutex_lock(&fs_devices->device_list_mutex);
> @@ -758,6 +759,10 @@ static void __reada_start_machine(struct btrfs_fs_in=
fo *fs_info)
>                 mutex_unlock(&fs_devices->device_list_mutex);
>                 total +=3D enqueued;
>         } while (enqueued && total < 10000);
> +       if (fs_devices->seed) {
> +               fs_devices =3D fs_devices->seed;
> +               goto again;
> +       }
>
>         if (enqueued =3D=3D 0)
>                 return;
> --
> 2.21.0
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
