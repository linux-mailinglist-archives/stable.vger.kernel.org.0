Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C3D6646C5
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 17:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238613AbjAJQ5l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 11:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233383AbjAJQ5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 11:57:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7D7319
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:57:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CDC60B818A0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 16:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518C4C433F0
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 16:57:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="eqnCYgE/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1673369854;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vFuIhfa7dd/qdASURD1oP1+BuX8wCApp6uzm20m5d10=;
        b=eqnCYgE/kPqe5OqygXrAF5PhMEPydgnTupf5rcsrXJnt/K2z8ywo64CAibNynCDfOY4+89
        3HG9fvD0fkqVj3M3A4SHGFf3/EpPdItzc2BqPcCW9Xofox+/2TEh/DIXtwcL8a0uovkPah
        3U0nrSPjAJsoODME7OGscyflH+fO9U4=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bde1e05a (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Tue, 10 Jan 2023 16:57:34 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id cf18so23994153ejb.5
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:57:34 -0800 (PST)
X-Gm-Message-State: AFqh2kqBa3Kjmdk2fLs854W4/WBDpdPZS3ukdI+Db1p0rGywNyEZBEwe
        E5OeWIwFo/E7EB5tqZ4gwCH43aQWa6BvC43ArSs=
X-Google-Smtp-Source: AMrXdXuXV7/EVyEcqOqABGG/QpVk/RYyYnNQaqVSeNOS6UlKMeKeXGSK7dtsSnMqQEVvN3ycQ5FNZQX9ibkI0PXsypE=
X-Received: by 2002:a17:906:5f81:b0:84d:44de:21f1 with SMTP id
 a1-20020a1709065f8100b0084d44de21f1mr1246722eju.426.1673369853508; Tue, 10
 Jan 2023 08:57:33 -0800 (PST)
MIME-Version: 1.0
References: <20230110160416.2590-1-Jason@zx2c4.com> <Y72YyXw5HcsbDac1@kroah.com>
In-Reply-To: <Y72YyXw5HcsbDac1@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 10 Jan 2023 17:57:21 +0100
X-Gmail-Original-Message-ID: <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com>
Message-ID: <CAHmME9r_tDXfnvdPfyQ+m_EB_nyNHs65NMueNHnk2u5Paqt3RQ@mail.gmail.com>
Subject: Re: [PATCH stable] efi: random: combine bootloader provided RNG seed
 with RNG protocol output
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks! IIRC, this applies to all current stable kernels (now that
you've sunsetted 4.9).
