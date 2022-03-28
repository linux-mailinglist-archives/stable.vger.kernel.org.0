Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D10534E8F70
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 09:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238995AbiC1H6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 03:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239000AbiC1H6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 03:58:16 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845A7DFAC;
        Mon, 28 Mar 2022 00:56:36 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n18so14095942plg.5;
        Mon, 28 Mar 2022 00:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=kIfOoBDYEc7M5gSagMNoiVBJWuRqusDCDKPYz/4md+8=;
        b=VqmjjWWVXkOeUbp3XOSMawZfyabaCITsH95uynydk7I4N2p27oAZ8BomdJ9dUuAg8O
         yUuHzJB8t+LlX0UyIBbQbUH8PnsHWklT95BiTFlk5WNeysGT31aaCPf6RPx6RY0xR+4y
         rzS9CwsJbvzu8lq7h2rvET9O5YuQBPrr1i0xZ0BKAVacjSeNxuvgjSKMO3pBGLps4gBq
         v5hq97ZVruMim+482HeCJuUAgAcQkpE0Y/4NcLWdw8ZM6irZrCx7AqsSgpJEtyPnZO1J
         YVeJfWH8enKrAWk8lIDcFhuT4r5xM+JcD9KDQt+qIzbe1ik9XeGUuWw5+1PVX3dftMSw
         foAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=kIfOoBDYEc7M5gSagMNoiVBJWuRqusDCDKPYz/4md+8=;
        b=7mvnNOVHD+VqM2FKTvu98fXtkeww6J0lyTQx/1aJEQjU95omfRDSZnlsoxRpGvMMSS
         tHz0exTnIa6unKIReqq9byifGrr2l2DXiOUY48HMrfdzSXqh9vKNmFQ9ZuOtzx0qYf2e
         Sl33CqrrsIJnSaM5r8aM0YOkCxSqcYjzuwam+j4LszxlQ7+klOkBrzd/Rh2EkwyJ2Onu
         Mp7p1ZI6JzWjplIKs4LGW3npkXzkiyUuymwpgD8mzBsp9rmKtNDPDAn+hLFPG0a0a+1h
         IN0o95CIcQp7JBFCylkw9/Vv8tiZ3kbV4Mh/vQh3eLl5wDe3slOsTYrE5RSTAPgjTonk
         rWOA==
X-Gm-Message-State: AOAM532vVOYo3a9lRLlrJsxEoUAv8QlwS/MW01ZPzgJkO64LP5wtty1Y
        fxpjNo3XpjRnDjYBpnTynVDX4qdjeCtBdw==
X-Google-Smtp-Source: ABdhPJwcYDZozrvxZwaqZGIKEnQhsqa0JD+d94ZjOS77DvW2lF4Y4Lkxl8Y03SezxTarAov7sSReFA==
X-Received: by 2002:a17:90a:de82:b0:1c7:b10f:e33f with SMTP id n2-20020a17090ade8200b001c7b10fe33fmr26704591pjv.204.1648454196113;
        Mon, 28 Mar 2022 00:56:36 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id v13-20020a17090a088d00b001c64d30fa8bsm16354494pjc.1.2022.03.28.00.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 00:56:35 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     guoqing.jiang@linux.dev
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        rgoldwyn@suse.com, song@kernel.org, stable@vger.kernel.org,
        xiam0nd.tong@gmail.com
Subject: Re: [PATCH] md: md2: fix an incorrect NULL check on list iterator
Date:   Mon, 28 Mar 2022 15:56:28 +0800
Message-Id: <20220328075628.25545-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <bdc2ed02-6f13-c8a5-7e61-190a5dd9b6bc@linux.dev>
References: <bdc2ed02-6f13-c8a5-7e61-190a5dd9b6bc@linux.dev>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> I'd suggest to rephrase the subject to "md: fix an incorrect NULL check 
> in md_reload_sb".

Thank you for the suggestion, i will take it in PATCH v2.

> > -	if (!rdev || rdev->desc_nr != nr) {
> > +	if (!rdev) {
> >   		pr_warn("%s: %d Could not find rdev with nr %d\n", __func__, __LINE__, nr);
> >   		return;
> >   	}
> 
> I guess we only need to check desc_nr since rdev should always be valid 
> , and IMO the fix tag
> is not necessary.

No. At least from the pr_warn log, the list can be empty or no element found in it.
If this cases happen, the 'rdev' will be an invalid pointer that point to a invalid
struct containning the HEAD '&((mddev)->disks)'. So this fix is necessary.

--
Xiaomeng Tong
