Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDD15AB15C
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235994AbiIBNZ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 09:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbiIBNZI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 09:25:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C2613A7DA
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 06:03:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71B8A61F50
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 13:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79337C4347C
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 13:00:30 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EAD9f2M7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662123627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2hyvq6Ay8cVlH+dehYHucQiFeZFEAYGgG00K/Txl9sQ=;
        b=EAD9f2M7gARQAIOyQYamJfMrkEL4qiD71lOX27R5iFAQWS0vVNSV3oeGgVYykqq4EZ9o80
        1PXZXLYpPHz7mOSOX5AxfyPDZyk3Am3+Ld+VWXq2GnYqTebIP/dITY4eRNW/IeM5QV4gN+
        3v5nwHW4UERqSalw0Jq0BriHzwX1D8o=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ea2b81a7 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <stable@vger.kernel.org>;
        Fri, 2 Sep 2022 13:00:27 +0000 (UTC)
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-33dc31f25f9so15580607b3.11
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 06:00:27 -0700 (PDT)
X-Gm-Message-State: ACgBeo3UekQAOiofyQQsmujh4/OWODQfqt3hVq2MZ4CO7b55ijiw7fFu
        8yI6Gl0aDcTw9hl4WKPHp2eHohUAZ/TwYMgn+Zk=
X-Google-Smtp-Source: AA6agR4g8Ma2Ck0pPHJl72h0FTl9RM4qyeG8XmUy1R7tcvnBSOIq2Ch6CK0zB4BYo9R/C9bVc7IWQ6SR1zmRNJUi5R8=
X-Received: by 2002:a81:6141:0:b0:328:30e0:a6ca with SMTP id
 v62-20020a816141000000b0032830e0a6camr28920281ywb.454.1662123625515; Fri, 02
 Sep 2022 06:00:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220902070319.15395-1-ville.syrjala@linux.intel.com> <87czcefb0m.fsf@intel.com>
In-Reply-To: <87czcefb0m.fsf@intel.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 2 Sep 2022 09:00:13 -0400
X-Gmail-Original-Message-ID: <CAHmME9ryP=nxj_C26fFMehH6GtZQZvyq6a9dLxWpQ87nFwcqPg@mail.gmail.com>
Message-ID: <CAHmME9ryP=nxj_C26fFMehH6GtZQZvyq6a9dLxWpQ87nFwcqPg@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH 1/2] drm/i915: Implement WaEdpLinkRateDataReload
To:     Jani Nikula <jani.nikula@intel.com>
Cc:     Ville Syrjala <ville.syrjala@linux.intel.com>,
        intel-gfx@lists.freedesktop.org, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
