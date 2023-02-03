Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1774968A177
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 19:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbjBCSUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 13:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjBCSUF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 13:20:05 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E29A8A0D;
        Fri,  3 Feb 2023 10:20:03 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id b5so6090532plz.5;
        Fri, 03 Feb 2023 10:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IVDJzsJUnCAcEMEmSLL1dt196xAYMs/0LWkqLtUvGEo=;
        b=kdRIA05rAAC19fkietGOxycCuZIno6yjvx1SFT/+o28dhYlh4hl1Lr9PAOYpkahyxz
         iJHGmJQK6PErKv89CynOVzGX39fiB96ONdaomtRNNKWWXTDKbs/vVYdvFYip8zrpsA1X
         Dnfqy4oNZ72o/xXtbYUSIg6z0giUg25im8UDzZrYEGvZDleUFPRelepYXGc1tiydIiMj
         cLK4F21p92luasoaRFLFeay9p/s+uPDxGMW4UaXG32J+wW6tbyRMJ9/0E3n0lYKu3CsG
         bxpYYf9gkYGojovE/IlQ/1NYNTb06sM21upjUtRXD5ML3pz6QV5QGsQ7I0d9R/b0NCq8
         EQSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IVDJzsJUnCAcEMEmSLL1dt196xAYMs/0LWkqLtUvGEo=;
        b=ovzREJtfEbiL+QiFnXeAdbmJ+YTAGN2N2yXnD04eRPL/AlyRu8ltZtHoS/dOWL0u1P
         T2UIAMAaJnaqUvgZY85KdrxASIZ0prwHe550BF9mgtYJFttoNm//eD7pdP5gQGVLhrTx
         rx/ejVZCnNcoMK4tM4ax3/ig3k6NWsiNgH6HbPyuY9Hh1RsBAkzm/lGE+P6xGgWRn1DU
         nQbbIlZqMwT+yQ6y3x9SH0jgwKZNwlJkCn0UK+8ISxESx/hzoV/dUy/ny7cgjKVpyNO+
         YfSS9HCh0RLXWaNFJceAt1Hmcu+8dkXko7HUVxHyTDeRXfpHsw1AL5Hxg1La2UQb+ujw
         96Bw==
X-Gm-Message-State: AO0yUKWBJrm6yeVBzofesjVM5HuCHoxhsTjdtX76gEvYnNyXd4P6FvmI
        bd1WU6Avg1/XNTRZdk12LYMOywNEZvI=
X-Google-Smtp-Source: AK7set8KWOhNAuduyHHtTkMAFypSCaOCENLdIxVTHb1PgH3y0+Y+cEpM++i7M/VJly2PAzBZcvL6yA==
X-Received: by 2002:a17:902:f0cd:b0:195:f3d5:beb0 with SMTP id v13-20020a170902f0cd00b00195f3d5beb0mr8818755pla.64.1675448403097;
        Fri, 03 Feb 2023 10:20:03 -0800 (PST)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id b2-20020a1709027e0200b00194b3a7853esm1892297plm.181.2023.02.03.10.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 10:20:02 -0800 (PST)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 3 Feb 2023 08:20:01 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        Yufen Yu <yuyufen@huawei.com>, stable@vger.kernel.org
Subject: Re: [PATCH] f2fs: fix cgroup writeback accounting with fs-layer
 encryption
Message-ID: <Y91QUXMfgYx3BrA7@slm.duckdns.org>
References: <20230203010239.216421-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230203010239.216421-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 02, 2023 at 05:02:39PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> When writing a page from an encrypted file that is using
> filesystem-layer encryption (not inline encryption), f2fs encrypts the
> pagecache page into a bounce page, then writes the bounce page.
> 
> It also passes the bounce page to wbc_account_cgroup_owner().  That's
> incorrect, because the bounce page is a newly allocated temporary page
> that doesn't have the memory cgroup of the original pagecache page.
> This makes wbc_account_cgroup_owner() not account the I/O to the owner
> of the pagecache page as it should.
> 
> Fix this by always passing the pagecache page to
> wbc_account_cgroup_owner().
> 
> Fixes: 578c647879f7 ("f2fs: implement cgroup writeback support")
> Cc: stable@vger.kernel.org
> Reported-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
