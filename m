Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29DEA55E335
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233741AbiF0Kmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 06:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234215AbiF0Kmm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 06:42:42 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8325B6424
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 03:42:41 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id m2so7826140plx.3
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 03:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FJ4seo7JsAaSqDrnyqyzUxujJZrDa+RLRWSP2QM7emM=;
        b=Qzniw3KKYBvlVyL6fxvVTOYuVZtqFAjMyfGQbu4EzQuNxMNRpwOI36KGhCl8HYXezc
         apJxIedTVkIO/AF6NSPrMnxmH5pado3I1eSCt6bxWWzbnH35c+iPvN+FI7DiYminvy36
         E7SSDDqmypWlrf8OdM4KAxs6khLodEtG947VDG6so/lYCVdnwNIpv+KtxV86XQcug37Z
         fnVUHXxhgxUgZfQCE3wCG7LJZqdNe1hxrB9GAK7UpMLKyJBhiinTwLw6XuVhoJjlXgZR
         Dac8l0Jc95rwyzxkmwqzaPrMoKt3DT2TweW06VJ3pnIoiqND6eZFp2k+PqypnnofSphv
         ZsNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FJ4seo7JsAaSqDrnyqyzUxujJZrDa+RLRWSP2QM7emM=;
        b=Vj+U1SVo4bWnl5eWmkjvUzvzDTDF1TArZfK+LT4g9hJUvJfI489L/eWkdjEN8iy0zF
         YcYOau78Jn7mLvxQwGooFT8fJ0u4KvXfNuiYBgoTQXs0EDV8wfyH1zF6l0fvUbThm/rV
         7KXFrefnvGX+eFAhUC0PsL7SGUqpX2f2N7jKCf/7CYVCHnRGK/QY8mBl7M1Icg5Ej9it
         TAL/NCyZJ1UU3xHn3AXKKKOUt5M+pqrZbALFKs5004Os193ifJsIlz3IDriXmA1yrCuz
         ZpgcOWzMWyQbwm/AdzuhxYUVh2DUjob3HrPcFMqf3QGPjRQAfb295IgU5GMo9ow335Dp
         6ylQ==
X-Gm-Message-State: AJIora+SsRfayIeA+LoAJYofktSWYUrLAG3q+g+8I+cJnTt2qFddPRtB
        i5V66tZYblEzzLJ+9Xpyf17pWZ/acmngWxPJbls=
X-Google-Smtp-Source: AGRyM1tG4na7IgjjTp31mXKR7XiGWb4ty0r7k7jQhdrvEfzFOL0uErNQ3DZG/jcVSfFvvMVr0fXrBA==
X-Received: by 2002:a17:90b:3d91:b0:1ec:d594:31f5 with SMTP id pq17-20020a17090b3d9100b001ecd59431f5mr15013376pjb.114.1656326561107;
        Mon, 27 Jun 2022 03:42:41 -0700 (PDT)
Received: from desktop-hypoxic.kamiya.io ([42.120.103.58])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902f70900b001663cf001besm6852590plo.174.2022.06.27.03.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 03:42:40 -0700 (PDT)
From:   Yangxi Xiang <xyangxi5@gmail.com>
To:     arnd@arndb.de
Cc:     stable@vger.kernel.org, xyangxi5@gmail.com
Subject: Re: [PATCH] asm-generic: fix buffer overflow read in __strncpy_from_user
Date:   Mon, 27 Jun 2022 18:42:37 +0800
Message-Id: <20220627104237.2042-1-xyangxi5@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAK8P3a0D7sy=jjjUQK0F-RugCNecYBg+JjM=vH=fy0suLDAOCA@mail.gmail.com>
References: <CAK8P3a0D7sy=jjjUQK0F-RugCNecYBg+JjM=vH=fy0suLDAOCA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> You should also indicate that the code was
> removed in mainline kernels and what the fix was there, as well as
> which of the older kernels need the fix.

I have no idea on how to decide the range. The suggested version 
range might be >= 5.1. And, should I send the patch again according to
our discussion?

Thank you!

Yangxi Xiang

