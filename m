Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344F15079FE
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 21:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiDSTPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 15:15:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352741AbiDSTPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 15:15:34 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F60B3EF04
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 12:12:47 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2e644c76556so154878247b3.15
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 12:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=/Ct+AxDBUwq5npjyE3CcIN4oPY5vWF71fxIZoksAsSo=;
        b=plXKzogvAjgTQ/3/wRrDQr/87HdF10qTGjL4ABF8SIjonjYIaney0OQV+PTNdUE7bA
         tJYjUnRl73oVwxWu/im4EGz2/OPpnG9SUwRqD2DKgV2EVoYznfJ/oj+cLXfECLERsHVW
         iy/YNl/3ylUbDhPf+pj2dJ8bbZU/EiexuBKqRQWxZIUEPT2QErtKhCC28hRe9y0t/1x4
         5nFReFWaKS1mG7SQz3GqzbZ5TOCnDc7uNAv8dLd9a57ftETG5aqrrCiHWPl2JK85NEc1
         e24gOpqQGeXmFDasnF42TaD1Il8nKCkRmHww2haGK1eFZQWKJttMBPawC0qpaF3w0Dqq
         hXAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=/Ct+AxDBUwq5npjyE3CcIN4oPY5vWF71fxIZoksAsSo=;
        b=beWZ7KmS8v+eRfjCMj7BYqkYqFFzh3ROvhpIwOFVLjmQ/MfLlD0SsjDawUaFVuLczV
         SuMiV3aFfunRFcnEOxwIYMW6E31u7hJfWWB023riSun8KSxMdl/Pa/NnmzO8o09TOcVF
         c4RasOCtY27OLQXNth6q7emcKQla/vhe8eFm7gjPDPWoHAgzldOSMaFehZTRQ2F/bOTF
         8Cj9Du7K541ENdTO/d9I9WYOeKZlDgcgXufD/3jLbv57Mh4rdQPUxXEq2jLwC96lMok2
         JoTlYGBh8mD8Ad9P2pU9KkPfT6PFneECyrSd0U1mrlJYr/McerajdcNAp95jkUxFQYuM
         B1oA==
X-Gm-Message-State: AOAM531QW8CYGkpkDEkojoklf/BJSzGdn5BEfSkXOsZWR6iJMfG2eyvr
        MaDeThke826D+ai2GZFpv9d/DP6Wk2UgJW6TcA2Ly+/7+0S4/dBatNJL94jps2ShD9YTD90n/VC
        Q0KnvIGlXjBRTFas0Pbi2BdcZIEMHf6G8INrEq1g8yFJLx2de3XV1ouY6An6dfg==
X-Google-Smtp-Source: ABdhPJxLmCZi+PAZn8T7sqVI0hBcsOTx5o6MfWfg9mp0SXuArtyq74PM0B9gGTNROEx2xemIcluq7834pQs=
X-Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2cd:202:694c:2cbf:cf44:7ce6])
 (user=khazhy job=sendgmr) by 2002:a05:690c:90:b0:2f1:9b7a:ceec with SMTP id
 be16-20020a05690c009000b002f19b7aceecmr10532296ywb.308.1650395566778; Tue, 19
 Apr 2022 12:12:46 -0700 (PDT)
Date:   Tue, 19 Apr 2022 12:12:39 -0700
Message-Id: <20220419191239.588421-1-khazhy@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH] block/compat_ioctl: fix range check in BLKGETSIZE
From:   Khazhismel Kumykov <khazhy@google.com>
To:     stable@vger.kernel.org
Cc:     Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ccf16413e520164eb718cf8b22a30438da80ff23 ]

kernel ulong and compat_ulong_t may not be same width. Use type directly
to eliminate mismatches.

This would result in truncation rather than EFBIG for 32bit mode for
large disks.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20220414224056.2875681-1-khazhy@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[compat_ioctl is it's own file in 5.4-stable and earlier]
---

The original commit should apply to the newer stables, this should apply
to all the older stables.

 block/compat_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 7f053468b50d..d490ac220ba8 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -393,7 +393,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return 0;
 	case BLKGETSIZE:
 		size = i_size_read(bdev->bd_inode);
-		if ((size >> 9) > ~0UL)
+		if ((size >> 9) > ~(compat_ulong_t)0)
 			return -EFBIG;
 		return compat_put_ulong(arg, size >> 9);
 
-- 
2.36.0.rc0.470.gd361397f0d-goog

