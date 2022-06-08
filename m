Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CABF543863
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 18:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245085AbiFHQIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 12:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245096AbiFHQH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 12:07:59 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EF520A72B;
        Wed,  8 Jun 2022 09:07:58 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id w21so18773898pfc.0;
        Wed, 08 Jun 2022 09:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mkc/YNPaDFCy+NvvtPrBToUV5ZmOT/66BjH7KNEM9eg=;
        b=GCYurLarM1ILiXi223WOD8WM63YAal7mzS3d49Ft5AYJvo3LO9z/ImaWOur9avXPtv
         p27ZXxfvRVRf49Hqn74POhSjs/NbUQ6yeeRJ8zkGxpQ3gY/EC68Q0JfimcYto69yURpM
         qBHvP9NGvNtJk8Oj8OCXHSS9VRdJuRIIURtfZRQDL/s8Y9I8G6mWr6G2gbqT0v9xtMHH
         KkzrRCeffUyF1N/WB6ZF3h3x3PePL2tnBHWhakRFUq8BJxCH3gRfn9kpQbYNl0+17Ngn
         lOTeenUsf89GFINUe8zKMi9XFYpYqT5VWUPfHeKdWQq/KUMTra42GV9GS22/7G4uXpbK
         2rBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mkc/YNPaDFCy+NvvtPrBToUV5ZmOT/66BjH7KNEM9eg=;
        b=rHHd1+apYlmZMtLRx7Ia8evy8u8TkUizKzynJqXr38BkIkM6pVVXrUxpuQxx7KDb7d
         +GnG1053rDaYkptakW9rHd9qdWtccbhL6YBOJv4ctmWitpMJD6oPSfnQNLsjAikY5d+p
         dGXPYGLGqQgMd6B6QteXC6U16R6lSjJMfH708IXWr3dvD85kcrs0lzsqdHPiifkJhfgs
         KkX9tOyaGSIEsnNLCTHYGrXBUWB5A+Y7WeCQKAuY3yWos5SVs5vAbv1qw9nHtWl5kMO1
         T2CakHcW3Udikz0tJ2B6lwKjFE1yyDXaVFMKqUXyTemumqinAyfWlyrkI7Hqc1iMeTeR
         95vA==
X-Gm-Message-State: AOAM531apbm82VaLt4azJOeotpb34Qn6O3INg91I6oKOvnKFFKlPcoae
        7US0nvk+RERPDFmvyoy90cA=
X-Google-Smtp-Source: ABdhPJznMKJ4fBRGPuXUJ7TYM/iDFJgdIl9l+lvqDMeDzcaBVj9288lpZmku74ozwJqsaK8gnsYJrg==
X-Received: by 2002:a63:86c8:0:b0:3fd:9e47:65e6 with SMTP id x191-20020a6386c8000000b003fd9e4765e6mr15951117pgd.554.1654704477949;
        Wed, 08 Jun 2022 09:07:57 -0700 (PDT)
Received: from localhost.localdomain ([223.212.58.71])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902d90500b00163a86fc88asm14872113plz.75.2022.06.08.09.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:07:57 -0700 (PDT)
From:   Yuntao Wang <ytcoode@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     daniel@iogearbox.net, linux-kernel@vger.kernel.org, pavel@denx.de,
        sashal@kernel.org, stable@vger.kernel.org, ytcoode@gmail.com
Subject: Re: [PATCH] bpf: Fix excessive memory allocation in stack_map_alloc()
Date:   Thu,  9 Jun 2022 00:07:28 +0800
Message-Id: <20220608160728.272118-1-ytcoode@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <YqC+WquFukW84W12@kroah.com>
References: <YqC+WquFukW84W12@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 8 Jun 2022 17:20:58 +0200, Greg KH wrote:
> On Wed, Jun 08, 2022 at 10:25:38PM +0800, Yuntao Wang wrote:
> > The 'n_buckets * (value_size + sizeof(struct stack_map_bucket))' part of
> > the allocated memory for 'smap' is never used, get rid of it.
> > 
> > Fixes: b936ca643ade ("bpf: rework memlock-based memory accounting for maps")
> > Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> > Link: https://lore.kernel.org/bpf/20220407130423.798386-1-ytcoode@gmail.com
> > ---
> > This is the modified version for 5.10, the original patch is:
> > 
> > [ Upstream commit b45043192b3e481304062938a6561da2ceea46a6 ]
> > 
> > It would be better if the new patch can be reviewed by someone else.
> 
> What is wrong with the version that we have queued up in the 5.10-stable
> review queue right now?

Since the 5.10 branch doesn't have commit 370868107bf6, the upstream version
is not correct for it, I modified the original patch and wanted to backport
it to the 5.10 branch.

> > 
> >  kernel/bpf/stackmap.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
> > index 4575d2d60cb1..54fdcb78ad19 100644
> > --- a/kernel/bpf/stackmap.c
> > +++ b/kernel/bpf/stackmap.c
> > @@ -121,8 +121,8 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *attr)
> >  		return ERR_PTR(-E2BIG);
> >  
> >  	cost = n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
> > -	cost += n_buckets * (value_size + sizeof(struct stack_map_bucket));
> > -	err = bpf_map_charge_init(&mem, cost);
> > +	err = bpf_map_charge_init(&mem, cost + n_buckets *
> > +				  (value_size + sizeof(struct stack_map_bucket)));
> 
> This differs from what we have queued up for 5.4.y and 5.10.y, why?
> If you are going to modify the upstream version, you need to document in
> great detail what you have changed and why you have changed it.
> 
> thanks,
> 
> greg k-h
