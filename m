Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E4C96AC078
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 14:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjCFNMd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 08:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230048AbjCFNMc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 08:12:32 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A242D28864;
        Mon,  6 Mar 2023 05:12:24 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id n5so5703078pfv.11;
        Mon, 06 Mar 2023 05:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678108344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=chQcgXxHy8sAMBkeEVLkeE+vS0UnB7P7m9TpmUAYgjU=;
        b=VECsWj/dJ7Gi3hX1nZ7G5RUL2FpdJDcCjeTxgwIvVhoopxmeK1XWlpiVL2gWo32pgV
         Bus+MeUdtNdwZpuGYykilERhtXWCSTuaUeluDdkEF/09p1XiCbR/h6RJBjqDh+SiOZ1f
         bcyvsOjjdUGBSzOxPpbHSTgpl4CcRDbrbYRadBB4CVxr8S0e45FjFaeScM8FIbBbiMV9
         5PoEJ9RU+DKI0ipITDxfC+3vBO1/zEjJcgon198mbuxS/61UidS3Ddb81EmSgSQ6GkA0
         Mf3eWIYh6ggztHVy9c2huuNdxGEzBg7+lfRsGoNK00JwevS9k7pyeau5q58pM/UeeFns
         a6vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678108344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=chQcgXxHy8sAMBkeEVLkeE+vS0UnB7P7m9TpmUAYgjU=;
        b=2BMMUHGufPRyaL0CocpcsQqump9EpGT8eXMc4Cr4Rbx1LkAabSMH9gLXMqh5hVIJWK
         jJxHgIrP0MgmbCO3T8G08SUl+94p/pFkLCRc4Ml5jux4IMVJCzBBjR3BWpdKKd1KYWDi
         F1hXfmEWg4L5j2Btpruz7Zql1tUIwZKHk5TjALMXxBiSqNVNek4MudN8pNJhNHHrKw9H
         O0bhtmwG64dBaSKENtte731GxPO+GH+WMSTxYCTvXhrEhaQGqTme6aenCqzFJU75BB1a
         tBfo7Zef8EZW44fsrL1PZGp3XD34+xVFjCpG6UPN053xFli3Q5tYKCo88GdpsKqu/Drg
         RMvQ==
X-Gm-Message-State: AO0yUKUxlRV9iNuBR9kcTu3I6aJ0cq2aDMdWYh67wukRL9lci/oX/p8C
        xmoLg054B8vzd8IMinqNvNu0BDccK3I0Nq+Eozw=
X-Google-Smtp-Source: AK7set+mCeQMqde4uuYrzjd2TmPrO/nbA2kDUGlM3i7YoSBdxGgCGY2af8Lm0ZC3lcEmy4quWaSCylXjFDRMDgymQn8=
X-Received: by 2002:a63:5a05:0:b0:4fb:b88f:e98a with SMTP id
 o5-20020a635a05000000b004fbb88fe98amr3813187pgb.7.1678108344147; Mon, 06 Mar
 2023 05:12:24 -0800 (PST)
MIME-Version: 1.0
References: <20230306060505.11657-1-i.bornyakov@metrotek.ru> <20230306131040.f6757retj5utp6lf@x260>
In-Reply-To: <20230306131040.f6757retj5utp6lf@x260>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 6 Mar 2023 10:12:13 -0300
Message-ID: <CAOMZO5AH9rO8PSJfeJXRP9t6w7_iSwgy_PQTk0yaHhD54ryAJQ@mail.gmail.com>
Subject: Re: [PATCH RESEND] bus: imx-weim: fix branch condition evaluates to a
 garbage value
To:     Ivan Bornyakov <i.bornyakov@metrotek.ru>
Cc:     linux-imx@nxp.com, shawnguo@kernel.org, s.hauer@pengutronix.de,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 6, 2023 at 10:10=E2=80=AFAM Ivan Bornyakov <i.bornyakov@metrote=
k.ru> wrote:

> Fixes: 52c47b63412b ("bus: imx-weim: improve error handling upon child pr=
obe-failure")
>
> Is it OK, or should I post v2 with "Fixes:" tag?

Please post a v2 with the Fixes tag and my Reviewed-by tag, thanks.
