Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4A669F363
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 12:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbjBVLXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 06:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbjBVLXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 06:23:13 -0500
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D80921A1F
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:23:08 -0800 (PST)
Received: by mail-ed1-x54a.google.com with SMTP id cf11-20020a0564020b8b00b0049ec3a108beso10091202edb.7
        for <stable@vger.kernel.org>; Wed, 22 Feb 2023 03:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ADFQgZgGOq4TDMg8Y+BW13f+LjzW9iSZx+Zyrtcp/n4=;
        b=MMWZcbYyEd1tCa+BGmDX75zVMH9izj2aiKtgJ57vTU6TFSuHRnLE6MVpPAYcG9cPZy
         yyXly1rODPWcZopTyOLqlF5HZuXs6jDOjDHRl+eNMm9wGQsZdl2nWgoXGehrQJeRAxS5
         kvw+9Aff6ZQQnynHtfO0+Y4DHRM31HVBuMNlMfrR8yC+qTELdBdY0CbY6RRv+wVA3Ow/
         qlMQF/8KBkEsnYFta14Uq5UhA5MBvBoTwLPS51du649DU1FaOxsYOx+dyKTOXIxb3q9t
         1yfm/lOmkNeezhtt1EHymnKYiLmeO8Z59LOQg3Y3kBtmVRtSpeeyWjmk4WNbr63czU8S
         Girw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ADFQgZgGOq4TDMg8Y+BW13f+LjzW9iSZx+Zyrtcp/n4=;
        b=okdR9/h7M0U4b1RCQvGFl6W3df1NFEe1n4KRiSz1pKSoL7kpHd51Msv8geW21uiUjr
         QR/UsE13QUol5LxSgdUHSNAFPWTvCx6Aq3kAeJlMz1BpesU8m7wv93f74d4RaZZQaEzy
         vKdioWIHau77sAxd2sJs0JDYAiJtBKnh3BUimpgt2w9TrXTleFl3Zum6LmzLAYDdr6iA
         zRzMH0CG89GblhRxMczY6tiwyYAC5DyA7MHGv2TIKshzeiQACYh/GHJpNj/JgJCXIXA7
         5uw3Fq9VTqDF8S/3OtiOSECKUPiffnhrkmBsI6l0GnQnm3KZdW1p0PRERf7v4I0eo3Dz
         jnMw==
X-Gm-Message-State: AO0yUKWQORvaLhCAdNGNbPPe/nDgHrcYHxBVcneQBtT2090GbA1AqnqC
        YRCZH+4Y1C0qUA5o8TmO+KLu1f4ADCjZFg==
X-Google-Smtp-Source: AK7set8YIjI/ceJgkk2o+g0zPawn9DfXQRE5q1XNCusxwuKgKUW6uGnQIFcMHM4XtQm3uU0+SGgQhi5wqkc8Lw==
X-Received: from lux.lon.corp.google.com ([2a00:79e0:d:209:35a9:4800:d90c:e9bc])
 (user=maennich job=sendgmr) by 2002:a17:906:d215:b0:8e3:da0f:f3ea with SMTP
 id w21-20020a170906d21500b008e3da0ff3eamr1729163ejz.7.1677064987258; Wed, 22
 Feb 2023 03:23:07 -0800 (PST)
Date:   Wed, 22 Feb 2023 11:21:43 +0000
In-Reply-To: <20220201205624.652313-1-nathan@kernel.org>
Message-Id: <20230222112141.278066-4-maennich@google.com>
Mime-Version: 1.0
References: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Subject: [PATCH 3/5] scripts/pahole-flags.sh: Use pahole-version.sh
From:   maennich@google.com
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

