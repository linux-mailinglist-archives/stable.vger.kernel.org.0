Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF3D6ABE00
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 12:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjCFLTi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 06:19:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjCFLTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 06:19:37 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E93914995;
        Mon,  6 Mar 2023 03:19:36 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id fa28so5474800pfb.12;
        Mon, 06 Mar 2023 03:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678101576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bFCElgfs/QgIK9T0+cfVbpNA53kfeis4CLHg1GVIGsg=;
        b=RM+NAR/av/nWO+TxpY4YWm437b2P1NkyMUJSNCR0cQYRcAw/jYeC0vB7t46tpc2Xjj
         l+pqnlTMqBBprSW/o8rLjWKrVGxj5lngOi8k3l7YTI/eMBlfh1EehSsurnt1+lfFq63i
         vHMp9JJYsVywl03/y+FCOGWUDnhBt0qHlAgOWqqs54I4IuwaVxUvHQM1wMt4+F9IOzv/
         cGDZrHL6u5nlF8PJgkbYimeLWijSBFknZSkgFN/HGmpIjXpL89rFQuJ/FvVjVJKV4QB6
         pQKg6QQdIY6OeQepD0Ryq56T//oBkK1tPvRiNAir2BKNKp/3S2Cpmgv4nXnzH6NV5Qn9
         CTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678101576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bFCElgfs/QgIK9T0+cfVbpNA53kfeis4CLHg1GVIGsg=;
        b=MNR2QxJCKszBxHrgkvBV3NMnM9my0bJ7Gx/Q0FvLV+3gEQYCFZFyS4Z0Ixq3SR1/Fp
         oBjCH6bgCiFLUV/YtYpThMCdswS+/6cby8gkV2k1agvCtPdVBbndawewomaXxXOJIGrD
         9xKcRteVndTPo6/VVlUpCCiXSmPIL7ncQ7JXHzOcyQcCNbbYLllGhtMHf+QdFAzGkIRw
         4MzEM+L+Imd+zIkUVa4q23UfL+LwFIEA6KcFdGZ5CZSW3aZ6HH0h0NevkmOxuz0+m6Az
         /6TFekNr1RXNjhQA2wOKY0bLM4960CIOtmfWQ2hfAa+XedERYs4bMK2I10qeBgH4/XIO
         t4sw==
X-Gm-Message-State: AO0yUKXTrHvwdmdsg/7mIGDTvOfv+bKSxTr7dYzIPwtXodP91hTdYk9S
        ftaYGSm0NjGBPh5/SnHEpYgkDydZ9yaQpVznV44=
X-Google-Smtp-Source: AK7set/4eWGzcQIyqd1DW2t0+log2GXUXOZ3POkzbF3KhtN1fYJUj+NpaFt2wIJcRtd0sSFMZFht7Uk0w22k3FPuwOI=
X-Received: by 2002:a63:7453:0:b0:503:bb5:4cec with SMTP id
 e19-20020a637453000000b005030bb54cecmr3747518pgn.7.1678101576020; Mon, 06 Mar
 2023 03:19:36 -0800 (PST)
MIME-Version: 1.0
References: <20230306060505.11657-1-i.bornyakov@metrotek.ru>
In-Reply-To: <20230306060505.11657-1-i.bornyakov@metrotek.ru>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 6 Mar 2023 08:19:25 -0300
Message-ID: <CAOMZO5DxXTUPHz-1crnr5McE40kW-we1b3pms5zn0UCvsnb82A@mail.gmail.com>
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

On Mon, Mar 6, 2023 at 3:05=E2=80=AFAM Ivan Bornyakov <i.bornyakov@metrotek=
.ru> wrote:
>
> If bus type is other than imx50_weim_devtype and have no child devices,
> variable 'ret' in function weim_parse_dt() will not be initialized, but
> will be used as branch condition and return value. Fix this by
> initializing 'ret' with 0.
>
> This was discovered with help of clang-analyzer, but the situation is
> quite possible in real life.
>
> Signed-off-by: Ivan Bornyakov <i.bornyakov@metrotek.ru>
> Cc: stable@vger.kernel.org

Please add a Fixes tag here.

Reviewed-by: Fabio Estevam <festevam@gmail.com>
