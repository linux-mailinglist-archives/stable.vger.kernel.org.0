Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9E56EEE5E
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 08:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239512AbjDZGbY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 02:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239379AbjDZGbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 02:31:23 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FE4A9;
        Tue, 25 Apr 2023 23:31:22 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-506bcf9aa50so1536712a12.1;
        Tue, 25 Apr 2023 23:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682490681; x=1685082681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0E/HJYaBlbdK8uIw6DelOKBf1DeLdfCsbhmPo9K0QQI=;
        b=R45wF211GxIf2UIEkE79wyKG6568b1PZxqkVNlMRoEgFVFOCK/X+KdgWILj2xJVkzB
         PrqoS3X3Gjwkkv1gtImergpPjxbsG3f2yhEvz+Ir4l+Ib0yjXxXRxaON+ES2/DR5dD69
         zPPzHktlq8SmPuk+yR5ERxUEUWrkURJWWrfs4uUs08hMBFyieIA0W2b+pBTXzRxKKk1/
         yB68MhGnvgyc/rc2VCc9Tf3cL1zRs4M6LNFAdLFnztDYCvYiK1Eky/G1C+VGzHm9DVQ9
         ny09xplQsit3OxNSMqWI9VmUxa5zRH7xmBYv5M838JKJbTPmsiLxQZxyRcDdqr1HfqdA
         FO7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682490681; x=1685082681;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0E/HJYaBlbdK8uIw6DelOKBf1DeLdfCsbhmPo9K0QQI=;
        b=beP7pPEBOdIc0i776C0JQWn8n6LOW/HXQIomXpY/WEv46m7fv5XVr3oJnedSqEkOWP
         F4dzVpHILdKXj3YU9+0JnlYE9+LTShXE4QPUISseDhVQfYW8P+EdnWP15wx+iaURlSD3
         aIM2Duxs09YjpOvF08z4yRD5KSKMZLcKCaClrorFR2Y51KbaejSaLRS6FrsrKgOCgLIm
         wOEkP3d2RtRpHMnIx3JVb+UYchxpV8EmsZL/jEOwbGtE5XuWqhDhaHCDyp/5o3XuvH+S
         Gw7MIoJextB92YgAeV2NMOLXViJQhNtOZwiO4ygwFFdf/uJVn2p3GRuSTS/RtQo495Pb
         gpIQ==
X-Gm-Message-State: AC+VfDyH0TQkyKZMd9j5X9ws8xrsHNS7zpW8RNpfZJjgkkGyVgtQPVxf
        tj8E2cjeGGLWSHG/axHkSxcuzxnhWV8dE7UCMyOWsYqC
X-Google-Smtp-Source: ACHHUZ7xZw0Nad5EHgnJdS/n6q1n9qakvSAIvHbFe/i0o5c4pgvnT1acbBUsn7q1pDtWZeneXB1AerBidf1I8qOrE5o=
X-Received: by 2002:a05:6402:4302:b0:509:c551:c028 with SMTP id
 m2-20020a056402430200b00509c551c028mr4303810edc.1.1682490680851; Tue, 25 Apr
 2023 23:31:20 -0700 (PDT)
MIME-Version: 1.0
References: <20230426004831.650908-1-olvaffe@gmail.com> <ZEivhUGdECRpVztZ@kroah.com>
In-Reply-To: <ZEivhUGdECRpVztZ@kroah.com>
From:   Chia-I Wu <olvaffe@gmail.com>
Date:   Tue, 25 Apr 2023 23:31:09 -0700
Message-ID: <CAPaKu7Ry84+ztnMRyzMzANSnnxW94ue4g=fL1SnahtfHod46bw@mail.gmail.com>
Subject: Re: [PATCH] drm/amdgpu: add a missing lock for AMDGPU_SCHED
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 25, 2023 at 9:58=E2=80=AFPM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Tue, Apr 25, 2023 at 05:48:27PM -0700, Chia-I Wu wrote:
> > Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> > Cc: stable@vger.kernel.org
>
> I know I can not take patches without any changelog text at all, maybe
> the DRM developers are more lax, but it's not a good idea at all.
Oops, sorry.  I've sent out v2 to address both review feedback.
>
> thanks,
>
> greg k-h
