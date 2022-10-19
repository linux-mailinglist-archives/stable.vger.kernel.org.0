Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253CB604389
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiJSLlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:41:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiJSLkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:40:41 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B78DEAC;
        Wed, 19 Oct 2022 04:19:25 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id v11so2697409wmd.1;
        Wed, 19 Oct 2022 04:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=e7cQlabbNZTU64fb6ak5+P3igVNtOffciQIMr0ffFnM=;
        b=UCGfOx4SOvBf7eyheeEIao5EAoDbhB/k+Dxvh9jOC6TcUYvek5EYEdlPuGfV31MgXP
         FuCIMjI7b92lrnbk5VtReZs7WJ0W8aG5/RAYgrfZf6tPbWTe7Xfd5Ui2Hvdv9SAWo5Oe
         UCtjki48XhhAY5IPBpuroCwWwAH7ecgKgYqEG6et5liGz8Ndd8pIBMyyDLdVSNQVmmwC
         jMwfkgTitHVq1Y0I/lW92BI4yXo0TTjlS65KR51Jup9AY1pk7WL6znLmlCG5glSoboYT
         psJrkZdB1uaZuy78DjtF2Bj9EaSV6LoZF5CGp96jZ7PWpQPGa9SrbDpIZBqEh2BQ+++H
         SMGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e7cQlabbNZTU64fb6ak5+P3igVNtOffciQIMr0ffFnM=;
        b=SxbBW4fbcfihBYLxJsQgQZze1pcBGS4wb7easwwGsZPII0leuiXE1ElxOopnHTNgTw
         tb3TWD68FO9V48gc4NO4ibH14qWpW1U2TuWzOVs4Wbv1sZm8u/UkTuIvcwjgqM0AXGJ/
         3iSZReh/wk7E7AxjF2CYDluDtfRgps8KArEpBCwcviBTInW3EKzyo4XfC6mxqlUeqt36
         FxOHmVUYkJOxHMa0l2Q64bctOLK/dp0VjzpUnwHST0zjhHz6BFuZjPLIKjgWyodE2WRS
         UIo4KmSGxO6iTFwsy6DY0aUOqhLZjKOmyZXfaIStNM7Ips3kklFeDVAJFZZbNLOY9LoC
         SePA==
X-Gm-Message-State: ACrzQf12CMXpj91Cvn6Pv5Bnw+PWZuVqY+34o5Cu47AUykmxNW/dDlgy
        ++BYf5qlT78TqJs4joGW1Xs=
X-Google-Smtp-Source: AMsMyM7EE3RjKl9PKyHD+VaO6BngQHZlDhOnHWaIEEapohae0et1iodcj6kNcg1huHesvMD26DB4XQ==
X-Received: by 2002:a05:600c:4e8b:b0:3b4:c8ce:be87 with SMTP id f11-20020a05600c4e8b00b003b4c8cebe87mr27588291wmq.157.1666178286023;
        Wed, 19 Oct 2022 04:18:06 -0700 (PDT)
Received: from krava ([83.240.63.167])
        by smtp.gmail.com with ESMTPSA id g16-20020a05600c311000b003c6f1732f65sm13427342wmo.38.2022.10.19.04.18.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 04:18:05 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Wed, 19 Oct 2022 13:18:03 +0200
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Andrii Nakryiko <andrii@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        bpf@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Subject: Re: [PATCH stable 5.10 2/5] kbuild: Quote OBJCOPY var to avoid a
 pahole call break the build
Message-ID: <Y0/c68JMlnwUojzq@krava>
References: <20221019085604.1017583-1-jolsa@kernel.org>
 <20221019085604.1017583-3-jolsa@kernel.org>
 <Y0/RXjwt6y1Dfh9y@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0/RXjwt6y1Dfh9y@kroah.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 12:28:46PM +0200, Greg KH wrote:
> On Wed, Oct 19, 2022 at 10:56:01AM +0200, Jiri Olsa wrote:
> > From: Javier Martinez Canillas <javierm@redhat.com>
> > 
> > commit ff2e6efda0d5c51b33e2bcc0b0b981ac0a0ef214 upstream.
> 
> I only see patches 2, 3, and 4 of this series, same with
> lore.kernel.org:
> 	https://lore.kernel.org/all/20221019085604.1017583-3-jolsa@kernel.org/
> 
> Are the remaining ones somewhere else?

hum, the 'git send-email' log says it was sent to stable@vger.kernel.org
(plus other emails) all with no problem.. maybe some mailing list hiccup?
I'd give it some time

jirka

> 
> thanks,
> 
> greg k-h
