Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2516CC177
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 15:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbjC1Nxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 09:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232525AbjC1Nxi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 09:53:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E56A24C
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 06:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680011572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lj+lqmXXS0BSikuA1TdKYzG9abofXGYmvsNuCdhCLz8=;
        b=hPKK9CXObWgE2K53+Eeepprzml9/BQBekFX3OZyJEZmNBmJOcvTcjlBrR/npv3hl/fzuqB
        0YMdbbOM1juU9l/SA47wT23TxVYinZk6FIRW/HO7q+FhtTFrCZUet/JcWNfxP3LX7Jd2Jm
        27fFMe5yI5XCEsrxyFzswMMzVJMWddQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-445-qyYUuuN8ObmRbFn2GHJh-g-1; Tue, 28 Mar 2023 09:52:42 -0400
X-MC-Unique: qyYUuuN8ObmRbFn2GHJh-g-1
Received: by mail-qk1-f199.google.com with SMTP id c186-20020a379ac3000000b007484744a472so5374862qke.22
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 06:52:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680011562;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lj+lqmXXS0BSikuA1TdKYzG9abofXGYmvsNuCdhCLz8=;
        b=16SpgDRh2ShdkMpAzW/Er/ijBwHZEaduRbvKQyF+NbK6i9moSGJE2bbimbbSngsnHl
         yXWA75vTX8q+5PvHE5h/vU3ztBTBvoUv72h+RuhxciPVu6nv6nyukeRW+zPiIDvLQWL7
         in17R2dy4b7cuv9c/A2MtBnLzqmRUpfaVSUEHTvguDn2/1env7m3w4rl7CoE1Q2zmkGj
         iB1gKSmt3W7ze5RfO3L9IDIi0V2OvFKpY4omMJ2HcD2PsVRAayU6TVeJwxI8BuzHIn6s
         8R/bQ5np5+B4O0sb2Lfa3UOy6H0q89gbhllspnEqpyGzHpK6nXYn8lxAE46IvFWPx4xN
         eT4A==
X-Gm-Message-State: AO0yUKW543O+lKKHbOx9SiSP83REMiZBA+JIXwqsuKIg/WnXk5DT+Rhq
        sbjzSVjtR2/buFvf5UxRJnadGHKy4dVoBRjornzZn6TlruQtZtctjhmZbZpeeCbMAOZjtCMipWe
        nRdquR4m2tfrPIZbmfUVKH6rD
X-Received: by 2002:ac8:5c49:0:b0:3e1:b2b4:f766 with SMTP id j9-20020ac85c49000000b003e1b2b4f766mr26805726qtj.5.1680011561953;
        Tue, 28 Mar 2023 06:52:41 -0700 (PDT)
X-Google-Smtp-Source: AK7set+Nsnehld0v77wMMLYEKM1+leVknIUJ69BwExMVTazmwQLBmfGnLpDVN40nlnWtQr6AxhbgBA==
X-Received: by 2002:ac8:5c49:0:b0:3e1:b2b4:f766 with SMTP id j9-20020ac85c49000000b003e1b2b4f766mr26805706qtj.5.1680011561719;
        Tue, 28 Mar 2023 06:52:41 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-232-148.dyn.eolo.it. [146.241.232.148])
        by smtp.gmail.com with ESMTPSA id s20-20020a374514000000b00746b2ca65edsm7102786qka.75.2023.03.28.06.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 06:52:41 -0700 (PDT)
Message-ID: <da45f73bcc2642260ef7718a6650dc535cc05c86.camel@redhat.com>
Subject: Re: [PATCH v2 0/3] xen/netback: fix issue introduced recently
From:   Paolo Abeni <pabeni@redhat.com>
To:     Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Date:   Tue, 28 Mar 2023 15:52:38 +0200
In-Reply-To: <20230328131047.2440-1-jgross@suse.com>
References: <20230328131047.2440-1-jgross@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Tue, 2023-03-28 at 15:10 +0200, Juergen Gross wrote:
> The fix for XSA-423 introduced a bug which resulted in loss of network
> connection in some configurations.
>=20
> The first patch is fixing the issue, while the second one is removing
> a test which isn't needed. The third patch is making error messages
> more uniform.
>=20
> Changes in V2:
> - add patch 3
> - comment addressed (patch 1)

I misread the thread on v2 as the build_bug_on() was not needed and
applied such revision.=C2=A0

Please rebase any further change on top of current net.

Thanks,

Paolo

