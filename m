Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884C95A624B
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 13:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbiH3Ln7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 07:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbiH3Lnd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 07:43:33 -0400
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [IPv6:2a0b:5c81:1c1::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E677540BE7;
        Tue, 30 Aug 2022 04:42:22 -0700 (PDT)
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: martin-eric.racine)
        by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 43B051B00305;
        Tue, 30 Aug 2022 14:42:17 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
        t=1661859737; h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t8x29qDSobRrZnNTFzvK22EpsdeXafMwe0vNxp+CuHk=;
        b=TpjoYoXR3ax65V0VMTXfKc1LUxWSgPXGqeMIgKvk8Nrmg9aust0pYrnJd1nokl/zr8N9mr
        hDlOtGuwfgZLWimBIbJ/ebi8cFU0XcqfRxYp6HE3n6sj2AzuQCXPRySlFwDnP+YLsIm9QV
        UboZieUXF0n16JE9+e+DtHw5PVaL5WMGJZOcxeNyidO20sgKx3hi6h+8q4FL9gqV9Shw5Y
        fx8rVtZbOZBB4qqVp/lvZGkmAGV+a+0E4lMWYF1s+eCAGs8cWrGLzzJx4Yc5bYbmq+/zJ8
        Png6P5NK9zNng3hOIvs4ZDw7lqi943JuzvsN0UuuoM1SRyruf4jGsEL+aasZUA==
Received: by mail-vs1-f44.google.com with SMTP id m66so11168562vsm.12;
        Tue, 30 Aug 2022 04:42:17 -0700 (PDT)
X-Gm-Message-State: ACgBeo0o2Gn8OXbntPhBYktV0G13sLyDSEBqe/XCzT6Zm0Hvryou45/d
        TMiIDBuZ/SMygjJK8OecPggHXsjX4oU2wXlH2Ek=
X-Google-Smtp-Source: AA6agR4VD5Lnft09dq3b5f+oM/pXgIjX6KxreLQ6ad98VlqSpPYR6W4RHhwRaT5agiPPngDv/ewsiwy2y2WH/pTLhgM=
X-Received: by 2002:a67:e9ce:0:b0:390:e35a:8b57 with SMTP id
 q14-20020a67e9ce000000b00390e35a8b57mr2616999vso.40.1661859736062; Tue, 30
 Aug 2022 04:42:16 -0700 (PDT)
MIME-Version: 1.0
References: <Yv7aRJ/SvVhSdnSB@decadent.org.uk> <Yv9OGVc+WpoDAB0X@worktop.programming.kicks-ass.net>
 <Yv9tj9vbQ9nNlXoY@worktop.programming.kicks-ass.net> <9395338630e3313c1bf0393ae507925d1f9af870.camel@decadent.org.uk>
 <Yv9+8vR4QH6j6J/5@worktop.programming.kicks-ass.net>
In-Reply-To: <Yv9+8vR4QH6j6J/5@worktop.programming.kicks-ass.net>
Reply-To: martin-eric.racine@iki.fi
From:   =?UTF-8?Q?Martin=2D=C3=89ric_Racine?= <martin-eric.racine@iki.fi>
Date:   Tue, 30 Aug 2022 14:42:04 +0300
X-Gmail-Original-Message-ID: <CAPZXPQeYh_BrZzinsvCjHvd=szAsOXUmkVYS1tJC5vwamx+Wow@mail.gmail.com>
Message-ID: <CAPZXPQeYh_BrZzinsvCjHvd=szAsOXUmkVYS1tJC5vwamx+Wow@mail.gmail.com>
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
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1661859737; a=rsa-sha256;
        cv=none;
        b=SWdWlxmty1Ltap/ZQIbrGerSZBSMK9dbHZuamMKLgS2qOBNrsWUXsqIFxUrMnoObzQJiV6
        WsQt2cU9DZkaxtsfxIZ+rEpYYitX5yIhJ/KlmKgIRgepT47kwNUmYED6qykjixNJRBqQGU
        QvKwqizQSiMfI/O3cnb5r1gK99VijQgJ3uYfEcHhs+245kcLW4ctpZM85VFTJSfKcM7oZe
        W4OahdA/o7KbTRaNS1U2PhDCknptJ75x4sBEyC6td1qPcYx7IMSlFEZq1vlohGM5/9/uw6
        0iYxGVwQ6U755QGZvv4KpF9PORoOdzWcFEUxPgusbT5BmCa7WLOYGrbA3F6G1w==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=martin-eric.racine smtp.mailfrom=martin-eric.racine@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
        s=lahtoruutu; t=1661859737;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t8x29qDSobRrZnNTFzvK22EpsdeXafMwe0vNxp+CuHk=;
        b=jfk6QBlViFYzf3Bddy2YSS+ShIqNoV7ddB8HJfZCUKfpyGocxF06pXTr40PAFGeJc6mE15
        SHrre3uLJ3pcryArecQtamufl3UvuzJ8/dFr1HYm/zghYAoGLCWNtoC/avWPEyaHIEF5gr
        CKXTFjwubc/mHI25+FAC4LPEN8irZgPqcxQGdUyDAA2K7pfBh6ZvYJlt3NkXjTnP/zU5jZ
        GJwmI6jIPiv4n3oT6Onip642q2hwAmPtYF3E59OBlmT8IgQa/9D6KQl1Capx72+lAvGz2E
        WAvC8j4lhvrROO8PK7juoOjGstGY4yh7ovIkEYRj0/PjTYbyMMmHgRgrkvJQww==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings,

On Fri, Aug 19, 2022 at 3:15 PM Peter Zijlstra <peterz@infradead.org> wrote=
:
>
> On Fri, Aug 19, 2022 at 01:38:27PM +0200, Ben Hutchings wrote:
>
> > So that puts the whole __FILL_RETURN_BUFFER inside an alternative, and
> > we can't have nested alternatives.  That's unfortunate.
>
> Well, both alternatives end with the LFENCE instruction, so I could pull
> it out and do two consequtive ALTs, but unrolling the loop for i386 is
> a better solution in that the sequence, while larger, removes the need
> for the LFENCE.

Have we reached a definitive conclusion on to how to fix this?

Martin-=C3=89ric
