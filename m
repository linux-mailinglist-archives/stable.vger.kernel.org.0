Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF364EC482
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 14:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344876AbiC3Mlo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 08:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345418AbiC3Mlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 08:41:31 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E3D7ECC40;
        Wed, 30 Mar 2022 05:30:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id c15-20020a17090a8d0f00b001c9c81d9648so6026031pjo.2;
        Wed, 30 Mar 2022 05:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PeqHZqqmpHZ9BzcUOsaYHrDDmxdOhkw9Bj2lbIGZa6Y=;
        b=mJkqEA++IfcRCX7fAnFKdp2s3rQ4wfk6jpJGHjsG8qLouWvqVudZwpcChWHWPzlwnk
         q7SIPaTRfc9884yvLkwBxrllkMolWW9ax7E6z6I1+iXkHEqgHaHxXXY1zIZK4jCM80Ga
         Bpc9/eg1hRX1wpXSqgab0UIYfaSoiRYBVz12HVSozifLM4KbWM96cUZsDNiyttQDBNO5
         pC0HETaQNneqgZQvA5FKt1WktcwGrd5RHVachjH9G+mvwOqeHenB9q/j46mG4xY+C1Ra
         0nRXO2vM/vrTjxlQLj+d9+Clf8+n3zoLwqM8tZZJjcb2OmhvfiVMkNyY0L/jpbQfKjQQ
         OGvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PeqHZqqmpHZ9BzcUOsaYHrDDmxdOhkw9Bj2lbIGZa6Y=;
        b=IKFEMFz9ZSip2wSQDaumw1P/hG8RGeGHyCBoJ2boNr7NBZ0yuPJrvXidVLtJaS8xv2
         PnQVAwrQxXV8z8dEZTejlc+fs3BZDzzQ0O7x/1FQsajz5e1xPfUkSaUw9dO8hB8NyZi4
         yBtaZP4wuU+kblKjsDY1rU0I6OYodBNxkkvr5QCNwJJA8CIEAvGeu6a4M7idez+uXVxT
         p27fBb+WsmFHQGtpchFx2heDG4e1J2PkjfvewVMIO6BHxLm04UAQljqAlGguAueYMNjs
         JnhN8/hua8b2fpQ6keJDd1Q/W2Tom5GsQ9ajuBKBR0s6vg4KfU0LT16Op8sflFzeGVoJ
         nAng==
X-Gm-Message-State: AOAM5321udeLbRAlOAgA9jnKMnl8UU03/8dNPbcG6V8xSy4R5Aw53pc6
        ghLR6YTEHu5KdEjiPLK8TJVe8yqC+Zqc1A==
X-Google-Smtp-Source: ABdhPJzq8H27fei6y9Z25B38wcO2n/79Y64PXpmZCTB2RguqrzOavFSLM7GvCUhAPrTcM9Vh/+22qQ==
X-Received: by 2002:a17:902:7296:b0:151:62b1:e2b0 with SMTP id d22-20020a170902729600b0015162b1e2b0mr34435524pll.165.1648643438402;
        Wed, 30 Mar 2022 05:30:38 -0700 (PDT)
Received: from localhost ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id f6-20020a056a00238600b004fae79a3cbfsm24132222pfc.100.2022.03.30.05.30.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 30 Mar 2022 05:30:37 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     leon@kernel.org
Cc:     bharat@chelsio.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, roland@purestorage.com,
        stable@vger.kernel.org, vipul@chelsio.com, xiam0nd.tong@gmail.com
Subject: Re: [PATCH] cxgb4: cm: fix a incorrect NULL check on list iterator
Date:   Wed, 30 Mar 2022 20:30:27 +0800
Message-Id: <20220330123027.25897-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <YkCTB/F4jc3DWRo8@unreal>
References: <YkCTB/F4jc3DWRo8@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 27 Mar 2022 19:38:31 +0300, Leon Romanovsky wrote:
> 
> On Sun, Mar 27, 2022 at 03:35:42PM +0800, Xiaomeng Tong wrote:
> > The bug is here:
> > 	if (!pdev) {
> > 
> > The list iterator value 'pdev' will *always* be set and non-NULL
> > by for_each_netdev(), so it is incorrect to assume that the
> > iterator value will be NULL if the list is empty or no element
> > found (in this case, the check 'if (!pdev)' can be bypassed as
> > it always be false unexpectly).
> > 
> > To fix the bug, use a new variable 'iter' as the list iterator,
> > while use the original variable 'pdev' as a dedicated pointer to
> > point to the found element.
> 
> I don't think that the description is correct.
> We are talking about loopback interface which received packet, the pdev will always exist.

Do the both conditions impossible?
1. the list is empty or
2. we can not found a pdev due to this check
	if (ipv6_chk_addr(&init_net,
  			  (struct in6_addr *)peer_ip,
			  pdev, 1))
			  iter, 1))

> Most likely. the check of "if (!pdev)" is to catch impossible situation where IPV6 packet
> was sent over loopback, but IPV6 is not enabled.

--
Xiaomeng Tong
