Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA23759A57A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350454AbiHSSP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 14:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350713AbiHSSPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 14:15:34 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C48E260A;
        Fri, 19 Aug 2022 11:14:50 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id w138so2368453pfc.10;
        Fri, 19 Aug 2022 11:14:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=e+XtPeC3pjXDO7mdGWjhmTQzwtsJL/vQCieYQy7ut4E=;
        b=RX96LJt+nOABWd+tsDkCkJJ7ntjNDGsnLZCKTN40l1WMltyOWXnXDzPzO83USsN0PV
         3A0TvTZm3VkCGrBPHBt74Dd7yArIlqYRJwJilL9Iyr6dNNsYbXshY6sqUJz6UG7z2VOo
         bskFlEjh3nC75nA86dV3NdKadcJTVwH+aT3rHLZFSEgwhb/Xd1x0RyGQlXhT0G5UcKeu
         DmquNOwyGoQXfC/w5Z4m3gWP9NvLKLj+r1/yhyHgfckukKJ5d4qAegqo6pjSkYtaqJyN
         JALqwvzSJpBN2TplDQAJ/OBLYDmZ5e7v9IzeNJwHMNFnNN0IO7ljorTbiUQT0I08PbOs
         BT7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=e+XtPeC3pjXDO7mdGWjhmTQzwtsJL/vQCieYQy7ut4E=;
        b=ic0C89BEnciL20zS9DuonzPei84T0QVHzmG+L5/NbVOdnU8Qr0P2WLsB5SrvY9L8RU
         0f6rJuKYIi8u867iuJhJrUHRpkj6qf/4y4LPJwzV2+FqiBYH5j4j3s+/RD8pSsfgAQdy
         N4sCPHOFxspTzpfLOiNa6LU0Pn7Wb/lTINT14todw0g+4nnOd/pagNCwnaxHtUe1D9WG
         7vqDkKkPoSDKOIxBkOkAPSOvViqXaU/j+ZXJ5mIz2Ivgd292DyP+5434WtE34MaOV/GV
         Nnk2Hi2op3JV1VhaC/B6baf6zsN7TA3xU1xqAgd2z0o9isJdZyBH5ZrYWsRWlpK8cDF3
         ycdw==
X-Gm-Message-State: ACgBeo2RM+ktGBk3Mi0iseVOzOO0HTNljyc9uY4Mwkurj3UjGdLR+07L
        LPBMcCfVawAFWlQsd8xAAqkdcZM5+uIPpw==
X-Google-Smtp-Source: AA6agR7xTFAzynYIJYRzrlVVHR6OZIAJi++KYll4/saep5sBM9gyrbqjn5FwfEdFJjQ9izY7rFGCUg==
X-Received: by 2002:a63:d5:0:b0:41a:58f:929e with SMTP id 204-20020a6300d5000000b0041a058f929emr7103736pga.260.1660932888846;
        Fri, 19 Aug 2022 11:14:48 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2d4:203:3995:f9b1:1e6b:e373])
        by smtp.gmail.com with ESMTPSA id t14-20020a170902e84e00b0015ee60ef65bsm3460918plg.260.2022.08.19.11.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 11:14:48 -0700 (PDT)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     stable@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Allison Henderson <allison.henderson@oracle.com>,
        Catherine Hoang <catherine.hoang@oracle.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 9/9] xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*
Date:   Fri, 19 Aug 2022 11:14:31 -0700
Message-Id: <20220819181431.4113819-10-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
In-Reply-To: <20220819181431.4113819-1-leah.rumancik@gmail.com>
References: <20220819181431.4113819-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 29d650f7e3ab55283b89c9f5883d0c256ce478b5 ]

Syzbot tripped over the following complaint from the kernel:

WARNING: CPU: 2 PID: 15402 at mm/util.c:597 kvmalloc_node+0x11e/0x125 mm/util.c:597

While trying to run XFS_IOC_GETBMAP against the following structure:

struct getbmap fubar = {
	.bmv_count	= 0x22dae649,
};

Obviously, this is a crazy huge value since the next thing that the
ioctl would do is allocate 37GB of memory.  This is enough to make
kvmalloc mad, but isn't large enough to trip the validation functions.
In other words, I'm fussing with checks that were **already sufficient**
because that's easier than dealing with 644 internal bug reports.  Yes,
that's right, six hundred and forty-four.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Catherine Hoang <catherine.hoang@oracle.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index fba52e75e98b..bcc3c18c8080 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1545,7 +1545,7 @@ xfs_ioc_getbmap(
 
 	if (bmx.bmv_count < 2)
 		return -EINVAL;
-	if (bmx.bmv_count > ULONG_MAX / recsize)
+	if (bmx.bmv_count >= INT_MAX / recsize)
 		return -ENOMEM;
 
 	buf = kvzalloc(bmx.bmv_count * sizeof(*buf), GFP_KERNEL);
-- 
2.37.1.595.g718a3a8f04-goog

