Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40FEE53B4EC
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 10:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiFBIYL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 04:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbiFBIYK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 04:24:10 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2475365AE
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 01:24:09 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id e2so5483479wrc.1
        for <stable@vger.kernel.org>; Thu, 02 Jun 2022 01:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=/oxPzJBDfbHif21+0m9Lw0wbP0FncP0Fvul3G/Cl5L0=;
        b=wivJAAkc+l9/2LaVkgijnkkb1yEIfQC0AHGhzdCxGQjeOAo017V5PuyNEfRr3tv/th
         LogOi+kqYucKRJUCN+yNDbM8RaVvt/aynqtmNdZWhNUnk2FKKYOurH6dY0z9f791+j8a
         sUoy2FtrEFPQqnG76+W/BVGyTu6GXRzP+8USrE4oVECAEXhIc2ypRaT5cDmF3ypH9RUG
         BfC7j6WPyMfQ5NhNqTZBf1wgTZhX5imW0HSbywWfvSVPcpMLEgCpIzvWWO2/+2ZnpA7I
         WBOHLFkX/wGABmr3KxC9ckCld+vkHMrbkYIVfbFzdCQJ2O/y+o2hMdYxS3Sg9TiQParA
         Wveg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=/oxPzJBDfbHif21+0m9Lw0wbP0FncP0Fvul3G/Cl5L0=;
        b=fK32SlzW3p2l70z4N418bEuqaxPF10BmNzEnaPervRQx3684O7qwh+ItqP1SajWgdq
         EoQdsWDhp1bhR87tgcfbtQCxG/pQ8q0hlqfmctbNBs11v70kEYEbAw220e49ljQPB26b
         5UCcxsB94zZZRqhzn2pl1j/9jbyjSAoxlyi64s9mal0PqA8eMSahO6h6Xaj9UdsUHEiz
         6lI0AgJnKAx0BcDs/cg6kPXrmm/U9hIZ8Dqn/YCgYB11e9WXSQn6RgWHcDzxy+PgoDNy
         FdTBPDUDeXmXk+IbqIKBb+xfz8zAAah4/hHsE3XjlhLc3jKeK0ldFwUfm0BCgaKop/n2
         9SYw==
X-Gm-Message-State: AOAM532VjKxrTgzc2g9dQ+3AOoTh9DEdn/qDwGaffeQGPidDDqOIJ73u
        G+dWzrf6Yyr5zCk2ladpIw5qDQ==
X-Google-Smtp-Source: ABdhPJzk/hT4NjXWXLWNTLMzhVme2bJkcMGjp7IR8BpHp3gmA7PEzBwywYBPBBLr50fJwGic9DhL4g==
X-Received: by 2002:a05:6000:1606:b0:210:2b15:66fa with SMTP id u6-20020a056000160600b002102b1566famr2595137wrb.568.1654158247684;
        Thu, 02 Jun 2022 01:24:07 -0700 (PDT)
Received: from [127.0.1.1] ([193.52.24.5])
        by smtp.gmail.com with ESMTPSA id p12-20020a5d4e0c000000b0020c5253d8f2sm3515630wrt.62.2022.06.02.01.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 01:24:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     jack@suse.cz
Cc:     linux-block@vger.kernel.org, hch@infradead.org, tj@kernel.org,
        buczek@molgen.mpg.de, logang@deltatee.com, stable@vger.kernel.org,
        hch@lst.de, paolo.valente@linaro.org
In-Reply-To: <20220602081242.7731-1-jack@suse.cz>
References: <20220602081242.7731-1-jack@suse.cz>
Subject: Re: [PATCH v2] block: fix bio_clone_blkg_association() to associate with proper blkcg_gq
Message-Id: <165415824682.62125.11243308674939285661.b4-ty@kernel.dk>
Date:   Thu, 02 Jun 2022 02:24:06 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2 Jun 2022 10:12:42 +0200, Jan Kara wrote:
> Commit d92c370a16cb ("block: really clone the block cgroup in
> bio_clone_blkg_association") changed bio_clone_blkg_association() to
> just clone bio->bi_blkg reference from source to destination bio. This
> is however wrong if the source and destination bios are against
> different block devices because struct blkcg_gq is different for each
> bdev-blkcg pair. This will result in IOs being accounted (and throttled
> as a result) multiple times against the same device (src bdev) while
> throttling of the other device (dst bdev) is ignored. In case of BFQ the
> inconsistency can even result in crashes in bfq_bic_update_cgroup().
> Fix the problem by looking up correct blkcg_gq for the cloned bio.
> 
> [...]

Applied, thanks!

[1/1] block: fix bio_clone_blkg_association() to associate with proper blkcg_gq
      (no commit info)

Best regards,
-- 
Jens Axboe


