Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73696A07C9
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 12:54:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233808AbjBWLyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 06:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbjBWLyE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 06:54:04 -0500
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5771E51F84
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:54:02 -0800 (PST)
Received: by mail-wm1-x34a.google.com with SMTP id l31-20020a05600c1d1f00b003e8626cdd42so3002268wms.3
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 03:54:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FE6DqTLa6oLIEcPK8T4wTKxiA51jr0clK07mi2rNw2M=;
        b=PCA1tagJIsI7O+0Bx91eiRyRj2mKFxg7YgxeG2hiFjGAkBFhJObVBdaX5v3431ZEvi
         QovW3mswBo0Dd4w+1Sv4M+dZfczp16Gn7Mz9NxP/t7fHurKot3MBQzldi8C6RdNScM0G
         8TkJtO3v8/XSFVuN6CB8qbxamo1YbIspXY25ssxZuVbn+nXQb59erqHi0GEnBfTaArKz
         0MpRsi+ZrngfSgMRwQgXbOusuOFa9Xxm0Q3AYvM6fFsw1KB71GawmE8BHB1dKkjQRdHj
         j8KxAU3QkdAjzM21kiTIzDS+t5wXvLAH6KlFpew7ja9CWa+YIK2QUqVPdToMzinhXFWP
         3Ptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FE6DqTLa6oLIEcPK8T4wTKxiA51jr0clK07mi2rNw2M=;
        b=TXPmmGKU8WMhZP84kFFOb6kVdQ8jUGjscQUhchcmqYGq+CxyvxABKKw/IR5KAPzDu0
         sis8nmCYHe51b0uge7yHwMeyLzwclfk61RkJDOAQ2ZZTYSDJiELTdKBOxLWmc7yfUhtv
         U1TLP+vVjZQ3lUN/Mr7WFpzEPuzSE1puQERtaZcJVh+fUgSdfJp8qxmPpVijtbJyTMKJ
         c6l0Nri52s+8/J9NI3PxzoFLY7hu96RvaFw5PXJYMStZQvqGHFN4Nv/0hj0tH6MvlZws
         m89yzLPGRnRSwtIwQNtuaByKPThAqC1Xj1CZFPRGeJJrB54RrHfjaWitcDcNhE801/wv
         tGHg==
X-Gm-Message-State: AO0yUKUgwR3kqlFQjsjG9Ac3fwgVwqHK4s7bES7rXxPSuKrWc9keNFLh
        QcSnPIS4iSCz03KKy3cz2+W3oYnlvsNajw==
X-Google-Smtp-Source: AK7set+MzHKyhEA2oOA6t+AlfF6nP4ofet3+WO/YMFBvJ6teFYUWCd8hM7C3mV/3f3gi+7jzaSX8rRR7sv2Pcg==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:209:cf33:dc28:3e98:f5e9])
 (user=maennich job=sendgmr) by 2002:a05:600c:1c04:b0:3dd:b278:27e9 with SMTP
 id j4-20020a05600c1c0400b003ddb27827e9mr1415658wms.71.1677153240667; Thu, 23
 Feb 2023 03:54:00 -0800 (PST)
Date:   Thu, 23 Feb 2023 11:53:49 +0000
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
Message-Id: <20230223115351.1241401-3-maennich@google.com>
Mime-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH v5.15 v2 2/4] scripts/pahole-flags.sh: Use pahole-version.sh
From:   Matthias Maennich <maennich@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     kernel-team@android.com, maennich@google.com,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 2d6c9810eb8915c4ddede707b8e167a1d919e1ca ]

Use pahole-version.sh to get pahole's version code to reduce the amount
of duplication across the tree.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220201205624.652313-4-nathan@kernel.org
Signed-off-by: Matthias Maennich <maennich@google.com>
---
 scripts/pahole-flags.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
index 7acee326aa6c..d38fa6d84d62 100755
--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -7,7 +7,7 @@ if ! [ -x "$(command -v ${PAHOLE})" ]; then
 	exit 0
 fi
 
-pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
+pahole_ver=$($(dirname $0)/pahole-version.sh ${PAHOLE})
 
 if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
 	# pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
-- 
2.39.2.637.g21b0678d19-goog

