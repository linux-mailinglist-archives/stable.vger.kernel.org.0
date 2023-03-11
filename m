Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C37E6B6106
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 22:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjCKVga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 16:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjCKVga (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 16:36:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05141457D9;
        Sat, 11 Mar 2023 13:36:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44D1260DE3;
        Sat, 11 Mar 2023 21:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A670DC433AA;
        Sat, 11 Mar 2023 21:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678570587;
        bh=IKeTI/9Te9LPskNfO9SJTqjD+2/qDHwVKrUMbdwzKlU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eTZdAFWSwbfuZLSgnkX6as8Jv0mI8l+j8A0IykfqziDPhYnBa8WiM3UQOGakue48D
         8OisI+Qz4zzh4Pphk/Xbaa1CrgvrgmN9tU6zQz1Kt2pp0iUL0e9jVvQhmu6vVtallO
         ZLk3mzMql65OtRd2/uo+WqLzm1+z2pVQ9obTI65b/fRD2OEJVyWpuipn0QFA4mtC2G
         FNPPE+DhMma86ZsZSyNcRGaNWHeLSJck4tHqZA9lkG6PBfcHfuyXsafFCoaCCAfN7b
         B3n7V0rA6sCB3HEGsY1k8+eMfw3Sm2WopIpF1LIB6ns6enzYcFndQ873/0LDELgjZ/
         K07XLHTViAVew==
Received: by mail-ua1-f51.google.com with SMTP id bx14so5904486uab.0;
        Sat, 11 Mar 2023 13:36:27 -0800 (PST)
X-Gm-Message-State: AO0yUKVtR6p/diHIoStJ29xyAd4H7vB3dUciz9BA8VLWy5YyN9DT5FUa
        CxBUnMArEKskKGbCLP6W3P2jVoxI1QXVVO166DU=
X-Google-Smtp-Source: AK7set/I6c0a33weIoohUiNtMjsqNKX8cuVAnKpOCcAqXYAt6v44TQjzBVkxVpHe32CEk5uxeIAmp7Tm0SjzN2blJ4A=
X-Received: by 2002:a1f:e584:0:b0:413:1498:e843 with SMTP id
 c126-20020a1fe584000000b004131498e843mr18579061vkh.0.1678570586519; Sat, 11
 Mar 2023 13:36:26 -0800 (PST)
MIME-Version: 1.0
References: <20221205103557.18363-1-petr.pavlu@suse.com> <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley> <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com> <Y8ll+eP+fb0TzFUh@alley>
 <Y8nljyOJ5/y9Pp72@bombadil.infradead.org> <Y8nnTXi1Jqy1YARi@bombadil.infradead.org>
 <Y8xp1HReo+ayHU8G@bombadil.infradead.org>
In-Reply-To: <Y8xp1HReo+ayHU8G@bombadil.infradead.org>
From:   Luis Chamberlain <mcgrof@kernel.org>
Date:   Sat, 11 Mar 2023 13:36:15 -0800
X-Gmail-Original-Message-ID: <CAB=NE6U5qokL-1xTnsUm+i7EoziEcmj-6p_b13OPi7_-sOtH2g@mail.gmail.com>
Message-ID: <CAB=NE6U5qokL-1xTnsUm+i7EoziEcmj-6p_b13OPi7_-sOtH2g@mail.gmail.com>
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
To:     Petr Mladek <pmladek@suse.com>,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Cc:     Petr Pavlu <petr.pavlu@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Ben Hutchings <benh@debian.org>,
        Adam Manzanares <a.manzanares@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 21, 2023 at 2:40=E2=80=AFPM Luis Chamberlain <mcgrof@kernel.org=
> wrote:
>
> There is one bug with  compression on debian:
>
>  - gzip compressed modules don't end up in the initramfs
>
> There is a generic upstream kmod bug:
>
>   - modprobe --show-depends won't grok compressed modules so initramfs
>     tools that use this as Debian likely are not getting module dependenc=
ies
>     installed in their initramfs

Vincenzo *might* be up to tackle the above, let's see!

  Luis
