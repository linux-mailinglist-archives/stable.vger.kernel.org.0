Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F7B355C7EE
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234071AbiF0JiU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 05:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbiF0JiQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 05:38:16 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B58B62C3
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 02:38:15 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 23so8590692pgc.8
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 02:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=55PjXPcdEapB1BFHEZ7zbjn5PhN6hpicK+8ZvkErhbU=;
        b=o+3t6VMDX4SfYcvYgfZh60fCzh3iTqSGhKlDtn16yCOG3EIUhI+lo63bX3DcDvtNLC
         Cl1ECnT5mJWd8ONFP9aOCiZ9apo7pkhGfGQ+LbHJSXpaP9lflgWyJmtXzTiMBycyC3Hu
         Jmi9Y4ENaOydjZeFMe458GvgPRa3X1aGWbMOxHrw9J0KfzKRx/zspU3asGqMvz50/RVx
         MjkMqtNPUd4/Ic/n/kdOw104RYXeJUsS0WdUCaZlS7QjEbcWXHqrhKFzQ6tc39kCrkyP
         5tMDWm78WN8rLECaH7TP7mBSVKMqaOO/v9RkMQqbEMv9i634M/JmqfKM9ADURmi5+fje
         ASxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=55PjXPcdEapB1BFHEZ7zbjn5PhN6hpicK+8ZvkErhbU=;
        b=x+p87V3YERoUO/pCZfAP+DM63TW4uuY3rNr6a7cVw9xBREWN05zqWnLiY2D29p2kX4
         4wr6up9igXazk8gI+00S2mMfvtwHoxPOQMpK3eM46fl9NBJhnjr7HhcXXSottrh0MrMq
         inzKdYtadd9yOzitJbXxo0b2E8ADVLa0F5Jqfvlqi+JUI69mi6cSiFuFJGrsLqgUIldC
         omTaje2vGNsyVRCFehAx11y2l51haPWctQ/fvVm2ASzNT0E/INyCiFUxbUojPOUfKcQe
         6JWz6BKXpddYO8pEosSYo+O+2ns86Jud0OTvVLT3tdjitGe99CnBGNKnvNGkZBt5lXFv
         naYA==
X-Gm-Message-State: AJIora/26UjsbFE8poMclTEVybhKkdO0TjdJHoCN3FmK0qUCiDjv3hAd
        4qttvbGHIu2fPrdcQsZUKSU=
X-Google-Smtp-Source: AGRyM1uJ4UWflJ6RYVUaV5SGYl60sQMiA8aPQ29unKsqtySOKVeJ/2RpFm19GiPjLNmCkv3ZOle9dQ==
X-Received: by 2002:a62:f846:0:b0:51c:17b2:60de with SMTP id c6-20020a62f846000000b0051c17b260demr13886806pfm.76.1656322694641;
        Mon, 27 Jun 2022 02:38:14 -0700 (PDT)
Received: from desktop-hypoxic.kamiya.io ([42.120.103.58])
        by smtp.gmail.com with ESMTPSA id jd12-20020a170903260c00b0016a15842cf5sm6727171plb.121.2022.06.27.02.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 02:38:14 -0700 (PDT)
From:   Yangxi Xiang <xyangxi5@gmail.com>
To:     arnd@arndb.de
Cc:     stable@vger.kernel.org, xyangxi5@gmail.com
Subject: Re: [PATCH] asm-generic: fix buffer overflow read in __strncpy_from_user
Date:   Mon, 27 Jun 2022 17:38:10 +0800
Message-Id: <20220627093810.1352-1-xyangxi5@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAK8P3a31O-_oGvG3bHCer7DXJApsd-TLV71_NwVt=yMGQ_iR_Q@mail.gmail.com>
References: <CAK8P3a31O-_oGvG3bHCer7DXJApsd-TLV71_NwVt=yMGQ_iR_Q@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Which architectures do you mean? I don't see any architecture using
> asm-generic/uaccess.h without setting GENERIC_STRNCPY_FROM_USER
> before commit 98b861a30431 or the prior release.

I am a user of LibOS, which uses this __strncpy_from_user.

> Also, I think the implementation relied on strncpy() setting a zero pad
> at the end of the string, so the ckeck would only be needed for a count
> value that starts out negative? Is there another way this can actually
> cause problems?

In kernel there is a common calling pattern is strncpy_from_user(buf,
user_ptr, sizeof(buf)), as I mentioned before. If the size of
user_ptr is greater than the buffer in the kernel, no zero attaches
to the end of copied string (see the implementation in lib/string.c).
So the checking of the count variable in this boolean condition does
not protect the tmp buffer in the last iteration of this loop in the
__strncpy_from_user.

Yangxi Xiang

