Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3664E8EC7
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 09:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbiC1HOn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 03:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiC1HOm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 03:14:42 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E4552B37;
        Mon, 28 Mar 2022 00:13:03 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id s11so11736621pfu.13;
        Mon, 28 Mar 2022 00:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rZODssmgDWBb9UeJdnGsd18jEFjTOBX6b8nMxUUttNc=;
        b=D6A/EJH3jMNBdXVi0eb+GIs1kC7F5wRFvrE2i1ewEQgVkMkG7iVsAwp7N+7CWRGAM6
         UElBRfWjm+H3ODSCcbPpWvSUApdsrBOWGxt/vaWKGFN2FdnWr0+82pmUqlfMqMBpVweD
         wWy+Por2IiBLajn7/oOIiiHzugTK3JlBOn4FPDlTcWLao0t9iiEqGLlbTBWRuVGEX8Xp
         luC6dl09kclzY5K38oVSQmCDFuLITjr6czPEh+owLoWzTHcAA6I+9VNIexhCO2c9aUlu
         CgbPAvyCpKd6wYO9EokjPLupI89tfH7T9iO2ydy0n8V6A5d6ImLLhUf4qTsMGWm2L2gx
         /0tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rZODssmgDWBb9UeJdnGsd18jEFjTOBX6b8nMxUUttNc=;
        b=DkkUrHcXes8t6gTU6lOnxk37VI2avDcj6YFISBdVqjSVT7b18ItnEcx7GOxlDh7eQM
         SprfTnLhowbclnbnRyV9NfuU2CVTKjcggTNsdKt+H+Mo+UBv4R9TWWmittb+vqteq4Vm
         /52ymfrTt1Cze59UPtObmhXBPiM1fnNI4oseAjDHvWuwUDR6ix/Olqfh28uEhbvmY5aj
         TItI/ZLXkp95y9Y6XQNAdMq0Itc5WtJMNynNGE9sKMlZyfWYipSoA+t/e76qlCN2Pkkh
         pnDD4E+HmXS+IZF3SLJVHCz9K5qtUQHQZ9MZR1KA0SHT+cOhsK57CMLBoIE4Nn6zjKry
         /tBw==
X-Gm-Message-State: AOAM532w17ZWeh+Me+RTJoz/m8rkpRpBiAvOtl0xwXd3DxsaXwaXOuZs
        1erbje+WIdJo0hL+vfL2Ahs=
X-Google-Smtp-Source: ABdhPJzmejBHYXSye/mN0u5uIWnJn91JBe2bW9IpvPqXiRa+JC54kKKlwNK03661NEFHZCqglp+1EQ==
X-Received: by 2002:a05:6a00:c83:b0:4fa:de88:9fd3 with SMTP id a3-20020a056a000c8300b004fade889fd3mr21666151pfv.41.1648451582548;
        Mon, 28 Mar 2022 00:13:02 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id z5-20020a056a00240500b004e15d39f15fsm14827215pfh.83.2022.03.28.00.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 00:13:00 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     svens@linux.ibm.com
Cc:     agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        dsterba@suse.com, elder@linaro.org, gor@linux.ibm.com,
        gregkh@linuxfoundation.org, hca@linux.ibm.com, jcmvbkbc@gmail.com,
        jirislaby@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org,
        xiam0nd.tong@gmail.com
Subject: Re: [PATCH] char: tty3270: fix a missing check on list iterator
Date:   Mon, 28 Mar 2022 15:12:51 +0800
Message-Id: <20220328071251.24865-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <yt9dmthad3a9.fsf@linux.ibm.com>
References: <yt9dmthad3a9.fsf@linux.ibm.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On  Mon, 28 Mar 2022 08:01:02 +0200,  Sven Schnelle wrote:
> > diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
> > index 5c83f71c1d0e..030e9a098d11 100644
> > --- a/drivers/s390/char/tty3270.c
> > +++ b/drivers/s390/char/tty3270.c
> > @@ -1111,7 +1111,7 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
> >  {
> >  	struct tty3270_line *line;
> >  	struct tty3270_cell *cell;
> > -	struct string *s, *n;
> > +	struct string *s = NULL, *n, *iter;
> >  	unsigned char highlight;
> >  	unsigned char f_color;
> >  	char *cp;
> > @@ -1142,13 +1142,15 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
> >  
> >  	/* Find the line in the list. */
> >  	i = tp->view.rows - 2 - line_nr;
> > -	list_for_each_entry_reverse(s, &tp->lines, list)
> > -		if (--i <= 0)
> > +	list_for_each_entry_reverse(iter, &tp->lines, list)
> > +		if (--i <= 0) {
> > +			s = iter;
> >  			break;
> > +		}
> >  	/*
> >  	 * Check if the line needs to get reallocated.
> >  	 */
> > -	if (s->len != flen) {
> > +	if (!s || s->len != flen) {
> 
> This doesn't look right. You're checking for s == NULL here
> 
> >  		/* Reallocate string. */
> >  		n = tty3270_alloc_string(tp, flen);
> >  		list_add(&n->list, &s->list);
> 
> and if it is NULL, list_add() would be called here.

Yes, you are right, i have submitted PATCH v2 to fix it, thank you.

--
Xiaomeng Tong
