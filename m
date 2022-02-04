Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66FCA4A92F2
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 05:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356917AbiBDEJp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 23:09:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356912AbiBDEJo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 23:09:44 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D92C061714
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 20:09:44 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id m7so4387940pjk.0
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 20:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Kh68bqIfR96bGqEsQD6t0ccLQCu/ga/B0iJH9ZRx6zQ=;
        b=aW6FCzwLzX1tJes3DN/wYTMmXMywRu7H//4nGgGPdDbXmYhuACnm9kSYeMId4jVEPl
         vgf3XsBpwWFb3XUdHS/n6oumA4XjQjGKqydlVmo+Xtqrsz0R6d9qkjI4QtR7lM+wXEZx
         KUgajNf+110tXuwka+YgdEjwh+ntpTb5agKFfxmDMxPfEybaxyUXqOE0+d/O/HVtmGJh
         3Gx/8L6+kI30LfJ/l6qLb7tz88SzENY3S00MJ8+7ANtRSvoSBj3XA+GJk/0sBCaeDYhE
         wF9ZFom/GbfmyunRiK/o2P4FO+4DrJc9nIurFAJ5LgQZXPRSf0iO/Q/+tQhGPqFvXWBA
         zZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Kh68bqIfR96bGqEsQD6t0ccLQCu/ga/B0iJH9ZRx6zQ=;
        b=BtzYjaLA/SboENoGt16Ey/UG4s9V+O6d0nXVyO3H+aRjYmUz7JP9wkr3VDwL6GhxDn
         DLjApQ/AECBTTRE4cC4C6s1I3Kn1VD0sU1PuOmkAlF+cuv/FOCxav8Fv+gPAHw0+2I5+
         OuUgmfUp/3Q6vBFTYH4f5zdg/E099HaodPHuuMDZrVNBeKcxrHF6QazmRqh4AT/yIHpI
         w++dfjHpJDkgsPV18wg32Azrm174YQ+cg+Dt9Z5VufSFtEDrQxFgeX3GbFx7lCEFCVly
         T2iCSqyXBfUu8BugUgcR8WtHo6DTu2JZzm8Qs5umfAaZpswbXG3JtG9NMY9OqnX+NS+/
         GXYw==
X-Gm-Message-State: AOAM531tFHOhuTUQgM1zEebltDbotMW/KBpoJLN2x3Fhf4xkYxknONFD
        QImqCH9M9GD1ivmNOCohcSJ9bQ==
X-Google-Smtp-Source: ABdhPJwfiI1eIEL3VdvFW5NMTqjZKtPcFWlmo2jedeKQ1D7v1nQGivCZU3HMFeLmQB/exMNLktzSKw==
X-Received: by 2002:a17:90a:4e89:: with SMTP id o9mr1057365pjh.132.1643947783585;
        Thu, 03 Feb 2022 20:09:43 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id s12sm515884pfd.112.2022.02.03.20.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 20:09:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Dmitry Monakhov <dmonakhov@openvz.org>, stable@vger.kernel.org,
        Alexey Lyashkov <alexey.lyashkov@hpe.com>,
        Dmitry Ivanov <dmitry.ivanov2@hpe.com>
In-Reply-To: <20220204034209.4193-1-martin.petersen@oracle.com>
References: <20220204034209.4193-1-martin.petersen@oracle.com>
Subject: Re: [PATCH] block: bio-integrity: Advance seed correctly for larger interval sizes
Message-Id: <164394778292.433581.8274625002734886779.b4-ty@kernel.dk>
Date:   Thu, 03 Feb 2022 21:09:42 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 3 Feb 2022 22:42:09 -0500, Martin K. Petersen wrote:
> Commit 309a62fa3a9e ("bio-integrity: bio_integrity_advance must update
> integrity seed") added code to update the integrity seed value when
> advancing a bio. However, it failed to take into account that the
> integrity interval might be larger than the 512-byte block layer
> sector size. This broke bio splitting on PI devices with 4KB logical
> blocks.
> 
> [...]

Applied, thanks!

[1/1] block: bio-integrity: Advance seed correctly for larger interval sizes
      commit: b13e0c71856817fca67159b11abac350e41289f5

Best regards,
-- 
Jens Axboe


