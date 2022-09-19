Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429985BC218
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 06:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiISEZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 00:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiISEZm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 00:25:42 -0400
Received: from mail-ed1-x549.google.com (mail-ed1-x549.google.com [IPv6:2a00:1450:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FFF12D02
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 21:25:40 -0700 (PDT)
Received: by mail-ed1-x549.google.com with SMTP id r11-20020a05640251cb00b004516feb8c09so16619915edd.10
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 21:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=vAt8nF5eu7uK8Lb8Ju51hMVsBhvez7qmSLnhO7fz+wg=;
        b=V9UmvGq8Eq17yaG+MazygbCeB0fMbzPtNIJ+iMJJVz3OAemBzXH1vhcj+R65SOPujQ
         KySEIwednobZZfTPkB+MA0LWJJw/XLD3UDE0HxK0RJtOw+7eUZzjQvWxkWU4lBTGQqR8
         /hpjHyg0JM9+bY/PhWRewpYRPvMQzY0kGYUqLWnirvBUDFAOF1uxW0utUJkimWQemuqB
         LyA3E2OzkHovq0LsD0dglplgpF6YrmzKT/xiLAgsLLSdf8PoGN8pguG2hd9F3CGmJH0d
         Az8OY08TqgXES5o+5JsAJHkujtIXu1eWVln3k9HbDvTNjPrXQ2Z9WugoRmHoKBq0qW8c
         zNZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=vAt8nF5eu7uK8Lb8Ju51hMVsBhvez7qmSLnhO7fz+wg=;
        b=Aw6+nswxax/XcgW5IyLupHzrlurXTlMf3Yr3VyRkx9BBvB9rfU1l12b4qMzkH3zIoR
         nmVkqYlTzz+DR1uQ6H1GCLcr7VeldP/AZGoFL1R+oa7sE7BUGpJX2MOXT3pEXIDWLdwD
         DFrhVdhUSnF+CKYDRdKkvuTbiSQQ9x4NSRGyePZth9J4ghg1ZcpNtJNSVl3JyUONCYne
         BF3i6QeNYA2yG3NFoar5i8umTo7nJ+f5xEzya4LERl+vUfxaJS7N24UOtfPCeQn6IhpI
         ae8zvQzzubBclUnXg5lZViDG6uiBvaGtCzUwoh1fH/IoCJ6tqKA3OYogXXy+wtSgTsBA
         hJBQ==
X-Gm-Message-State: ACrzQf2jRqux3X5I70d+TGAXHKJODs+LidSpavt1WOn9EPdtkyy60fAa
        S67Qfo7kn6swSHPOxjZt4K9BlirhZp6/
X-Google-Smtp-Source: AMsMyM4agj4l3RY3Rw3+CJbbvyULsH03pMXxD/X7JNJXyQCb2nhR5acKflJTR0/65vUBaa79jVX7yRiMpKPB
X-Received: from dvyukov-desk.muc.corp.google.com ([2a00:79e0:9c:201:62f3:29e:da00:8ea7])
 (user=dvyukov job=sendgmr) by 2002:a17:907:2c77:b0:77b:4445:a852 with SMTP id
 ib23-20020a1709072c7700b0077b4445a852mr11605567ejc.582.1663561538852; Sun, 18
 Sep 2022 21:25:38 -0700 (PDT)
Date:   Mon, 19 Sep 2022 06:25:33 +0200
In-Reply-To: <20220916224741.2269649-1-tadeusz.struk@linaro.org>
Mime-Version: 1.0
References: <20220916224741.2269649-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220919042533.2688081-1-dvyukov@google.com>
Subject: Re: [PATCH] usb: mon: make mmapped memory read only
From:   Dmitry Vyukov <dvyukov@google.com>
To:     tadeusz.struk@linaro.org
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tadeusz,

Looking at places like these:
https://elixir.bootlin.com/linux/v6.0-rc5/source/drivers/infiniband/hw/qib/qib_file_ops.c#L736
https://elixir.bootlin.com/linux/v6.0-rc5/source/drivers/infiniband/hw/mlx5/main.c#L2088
I think we also need to remove VM_MAYWRITE, otherwise it's still
possible to turn it into a writable mapping with mprotect.

It's also probably better to return an error if VM_WRITE (or VM_EXEC?) is set
rather than silently fix it up.
