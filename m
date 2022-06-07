Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E88F53F8DE
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 10:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbiFGI4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 04:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237612AbiFGI4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 04:56:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FB68D80AA
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 01:56:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C57AB81E05
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 08:56:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA56EC34115
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 08:56:34 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="pKFcgdg+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1654592193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JgrN6zFdegLTS5Aqxx13kf50ffai0arOXngYK3WVxuk=;
        b=pKFcgdg+UE2x6EXhXPPS2q082e17WMrJLsbI2SOjNeTsW9D4dBlk5zgWDXcZyl14McTddO
        jfnKwGRq0D7LCFSpL622SCz/BDorbJ1MrjkN+/0Mv//aQ3ARIntPvJgQLklg8XbtNdYTFt
        thT9s/MDIvfaBB4ht8RmAXjtCrJi8Kw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 88d8dd22 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Tue, 7 Jun 2022 08:56:32 +0000 (UTC)
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-2ec42eae76bso168060927b3.10
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 01:56:32 -0700 (PDT)
X-Gm-Message-State: AOAM532YnRKVrpICQ9Pe/oGjAuJbzIGqgtGT1DqKTtWs2ysBfrEmHpSv
        cmDno9l5LNM52V1VUGJcfpf1pVK8G5kOMjMDeX4=
X-Google-Smtp-Source: ABdhPJwD0VU0cwnDbIccUnj8DlXIV3Hg19ZHocVh0Wo+pwWKtJHVbGH3ZBzZkF87Ie6mV4hc4Z2IuZ4z4Eu+CRDf3kI=
X-Received: by 2002:a0d:ef03:0:b0:2fa:245:adf3 with SMTP id
 y3-20020a0def03000000b002fa0245adf3mr31231044ywe.100.1654592192145; Tue, 07
 Jun 2022 01:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220604062503.396762-1-Jason@zx2c4.com> <Yp2kn+lzTL7RTaoD@kroah.com>
In-Reply-To: <Yp2kn+lzTL7RTaoD@kroah.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 7 Jun 2022 10:56:21 +0200
X-Gmail-Original-Message-ID: <CAHmME9pPvdAS1fqDpaDVq6T9=cch2M_UhRJwNEBntG-dYfhU0g@mail.gmail.com>
Message-ID: <CAHmME9pPvdAS1fqDpaDVq6T9=cch2M_UhRJwNEBntG-dYfhU0g@mail.gmail.com>
Subject: Re: [PATCH stable 5.10 5.15 5.17 5.18] arm64: Initialize jump labels
 before setup_machine_fdt()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SCC_BODY_URI_ONLY,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

You can actually drop this in favor of
https://lore.kernel.org/stable/20220607084005.666059-1-Jason@zx2c4.com/
rather than playing whack-a-mole by architectures that may have been
broken by it.
