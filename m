Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8612F599B1B
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 13:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347592AbiHSLdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 07:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347538AbiHSLdu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 07:33:50 -0400
Received: from meesny.iki.fi (meesny.iki.fi [IPv6:2001:67c:2b0:1c1::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370632D1FE;
        Fri, 19 Aug 2022 04:33:47 -0700 (PDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: martin-eric.racine)
        by meesny.iki.fi (Postfix) with ESMTPSA id BA0F72065F;
        Fri, 19 Aug 2022 14:33:44 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
        t=1660908824; h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkx3l2Jsr5sn7pf41ZGYs34bVyvOXQOv8D/DfIbdLs4=;
        b=jvNOhQxCaIxg8axFbz7wCTaU1KV/nOQCmIzGuUqNw5LS+lfmzjNQTC6KolbhoBgBIUiYH9
        nsbYjG6RtqL/XyVJzVfxtvraI7edzi0GzAEhwZbTCIt3LH4qm5JfdLnoshikVZ3PpeOvHH
        pVxGB8eEH2JA8Y2Tl5bZRJQ6gg4Uf60=
Received: by mail-vs1-f43.google.com with SMTP id z185so4184817vsb.4;
        Fri, 19 Aug 2022 04:33:44 -0700 (PDT)
X-Gm-Message-State: ACgBeo3JqDmziwEC9RUhjdrHJUYiZrktluNJaPlcAoiWTgc04TQ325ar
        Rx3qpCLC29kxpodHpNv54aamuExjbwHl3VD1SrE=
X-Google-Smtp-Source: AA6agR6W0iWWXzz2sZkerBMRwwozpy0qrrVZxzp7D6cWhuSVrTiOEAnBUCz0CDdjQq7II9fbkjswjtsDDlClM4nra4o=
X-Received: by 2002:a67:c819:0:b0:38f:784f:c377 with SMTP id
 u25-20020a67c819000000b0038f784fc377mr2234906vsk.15.1660908823365; Fri, 19
 Aug 2022 04:33:43 -0700 (PDT)
MIME-Version: 1.0
References: <Yv7aRJ/SvVhSdnSB@decadent.org.uk> <Yv9OGVc+WpoDAB0X@worktop.programming.kicks-ass.net>
 <Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-ass.net>
In-Reply-To: <Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-ass.net>
Reply-To: martin-eric.racine@iki.fi
From:   =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
Date:   Fri, 19 Aug 2022 14:33:32 +0300
X-Gmail-Original-Message-ID: <CAPZXPQe+MPTGD3MH1HORvCZa08HhdbWy=zh7rLSCwA6edM2Ccg@mail.gmail.com>
Message-ID: <CAPZXPQe+MPTGD3MH1HORvCZa08HhdbWy=zh7rLSCwA6edM2Ccg@mail.gmail.com>
Subject: Re: [PATCH] x86/speculation: Avoid LFENCE in FILL_RETURN_BUFFER on
 CPUs that lack it
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ben Hutchings <ben@decadent.org.uk>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        1017425@bugs.debian.org, stable@vger.kernel.org,
        regressions@lists.linux.dev,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=meesny; t=1660908824;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fkx3l2Jsr5sn7pf41ZGYs34bVyvOXQOv8D/DfIbdLs4=;
        b=rjfIm3WhysBqcVoqDra2pO/z7G2hhRhEndLGJtAIVdUSISYt9ezBwLMrd/mghTxOPSbX1Q
        TfAEV4istT8bkFx1rwAD+NUgvUF6KhkOsbnQ+6EB/9MF0HfH/dwFE1RaI5K6z5Y72sUijq
        QyuJows/mW9QDBwVy6QL7/b4Y9t7HKQ=
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=martin-eric.racine smtp.mailfrom=martin-eric.racine@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1660908824; a=rsa-sha256; cv=none;
        b=d7uWLKMeMUDzepnKQKoJICuYpRzHhvIM+shCzJV6F4wy0eR0q+1ZDlILwdml8FkOI+D2Xj
        eN6nrrc/DGgioCH9CyZn5o8pn2iZb4VnNgrWUIGBn1Whom9Tmp/OqDdZW96iew07MlXveg
        8yzEb9i+kT/zKgPtZ82QfjXgUPBuGIY=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 2:01 PM Peter Zijlstra <peterz@infradead.org> wrote=
:
> I'm not entirly sure what to do here. On the one hand, it's 32bit, so
> who gives a crap, otoh we shouldn't break these ancient chips either I
> suppose.

This is something that I've repeatedly had to bring up, whenever
something breaks because someone meant well by enabling more security
bells and whistles:

x86-32 is by definition legacy hardware. Enabling more bells and
whistles essentially kills support for all but the very latest
variants of the x86-32 family. This is the wrong approach. The right
approach is to accept that building for x86-32 inherently means
building for older and thus less secure architectures.

Martin-=C3=89ric
