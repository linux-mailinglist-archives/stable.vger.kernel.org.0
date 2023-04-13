Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC4C6E0DB5
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 14:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbjDMMtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 08:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbjDMMtt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 08:49:49 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC410AD0B
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 05:49:43 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b1e92ce21so196445b3a.0
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 05:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681390183; x=1683982183;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=chPnl8Mv5KXZq4yhNcjhEego6Gn/IkEJkBYC5Nsft1o=;
        b=n9n/9LPPtKwIJ41ocSYVaM7cPpKBO3Qcmc9Dot62ShK5jStwhmJ6In8nvzUsWRrBDO
         BSXX4+OeuR2licrgEGhWJ82EXMvWg2ao9QoAnss8Lv3tL86cmYZe6hrTvrpXDzyPeoCm
         DHI1C8UT8Y7ehTZP+Mw+bpgD+44Trf1ENcyQ0xRGi6miLfBQTB/SbiN43gj0IeqoGvjb
         dSLTH44Eh4efnjmvwU50c+PHRlt5MW4+S/1g2+8Zw45DANXQRm8M2uvniAL9kdnw/+iM
         d1g6Ek7N2QypGMFGVkRH2l0mcDCWIa4PhivcNL82TWTtRhGqNflTKkDKSRhCOZOmKC4b
         eItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681390183; x=1683982183;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=chPnl8Mv5KXZq4yhNcjhEego6Gn/IkEJkBYC5Nsft1o=;
        b=G8+j96wr01QEN6ZU+3BwPle7VUNANwL9Ci6HTQuW4UZb9Xyj8uH9IoaO9PfFHw3tQZ
         au6lst9YIzlnl9N1si8w+/L/s3eHJ9IvB/VHoZrOyF1L5Pk64VRUyYw6mn1+F15LVO2W
         RmVVWyzfWJp+KjuollpwWMDIyst3ld0cwUY04rRIyKY1vtm4CU22sOR9BaHgSRDZP9jO
         i4vpHvYLcieUQ8oDnfCJSen7HHf7vXUEoasXyqZ4+tJRwEqFEFIpEA9UEA09iLWAwqsv
         KC+kbjo33hEdSp9IbpH++SutzT7CSRg3uZ1Ds9cB5ynpvyZKQ6uhZT4el0I3v2mRokBJ
         S3cA==
X-Gm-Message-State: AAQBX9dJw4jmqOwP0VG3TWrtWRh/t4U2/s7mVx39ygyKcTMdYsMWZOGL
        B9HBImOZCWfirhO17DH40Yvgqffx3eZU/BBIX/o=
X-Google-Smtp-Source: AKy350antEwnFS0M8iO0GabDUmSQ1squlED1hTPFxzkhV3oVQldHP4wuiQqO+e3zVnRbS/X3SRm8Yw==
X-Received: by 2002:aa7:88c6:0:b0:624:bf7e:9d8c with SMTP id k6-20020aa788c6000000b00624bf7e9d8cmr2869192pff.1.1681390183084;
        Thu, 13 Apr 2023 05:49:43 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x14-20020aa784ce000000b0062bada5db75sm1365480pfn.172.2023.04.13.05.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 05:49:42 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     tj@kernel.org, chengming.zhou@linux.dev
Cc:     josef@toxicpanda.com, osandov@fb.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Chengming Zhou <zhouchengming@bytedance.com>,
        stable@vger.kernel.org
In-Reply-To: <20230413062805.2081970-1-chengming.zhou@linux.dev>
References: <20230413062805.2081970-1-chengming.zhou@linux.dev>
Subject: Re: [PATCH v2 1/2] blk-stat: fix QUEUE_FLAG_STATS clear
Message-Id: <168139018203.8989.17731261770336366712.b4-ty@kernel.dk>
Date:   Thu, 13 Apr 2023 06:49:42 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On Thu, 13 Apr 2023 14:28:04 +0800, chengming.zhou@linux.dev wrote:
> We need to set QUEUE_FLAG_STATS for two cases:
> 1. blk_stat_enable_accounting()
> 2. blk_stat_add_callback()
> 
> So we should clear it only when ((q->stats->accounting == 0) &&
> list_empty(&q->stats->callbacks)).
> 
> [...]

Applied, thanks!

[1/2] blk-stat: fix QUEUE_FLAG_STATS clear
      commit: 20de765f6d9da0c47b756429c60b41063b990a10
[2/2] blk-throttle: only enable blk-stat when BLK_DEV_THROTTLING_LOW
      commit: 8e15dfbd9ae21e518979e3823e335073e725f445

Best regards,
-- 
Jens Axboe



