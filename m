Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905D36DCFC4
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 04:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjDKChB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 22:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjDKChA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 22:37:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6B826B2
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 19:36:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id q15-20020a17090a2dcf00b0023efab0e3bfso9472949pjm.3
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 19:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681180598; x=1683772598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RNoPx/yBxCZUTMcdePk1dw8S6b4kcsgqSpybXY5Vu6U=;
        b=T/yh3klPi5R2cYV6zCyK8ibu6E2FcPeL8pzCGeIS3i3FD+rM6gX63DX2cMEEZV5h5W
         xo7/0WsHP0UXa76/NWJ28BXTWil8mgFsuFelHYkggZDEKvFP0TBk70um8lUZacbvVqzA
         rFrh893Gxk5pqX9VBZK7P3Dix0UUcnxyS+QAi7376sJJoAxRd/znnjmZyJvrkHBaHIgk
         6TFEyIBAD9bM1LyjbkZORmwl2nCS0fx47IXyge9XFdZpGI1/9fBzQKsQcYTS3aksFgtG
         c5nt/xbFxADD4SCGkfj2kSG3Igz5U+22+bvFLXRotUkJcP8CuqY3wOAevmGQaWjdkjO+
         auIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681180598; x=1683772598;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RNoPx/yBxCZUTMcdePk1dw8S6b4kcsgqSpybXY5Vu6U=;
        b=vHe3hs5gwnInrkWDViJdHNjW4N7CpCTYbb/zuCNzPwavmPYOPwckS63vtH0nJUMeQc
         BdTdHUldKCJDqv7/fJ6asEbAGItG/xAJCs5fOj3/ReSbAQbvGArfug9LiFPEmwo4jcaZ
         I4fj7I2Vsoq/VxNUxDoHTr9xK90AsnJARQ+CgMofedJBu4MyUCCPLAXyDGxnh9twnA6W
         aPpBL09Qfy/JfMZCgua8897uEtWNsydEBYVhqaSS90s91nuEMwzFp5auNfgt4XMj9iRc
         aQD5yNopy2L2cYTEoOoXF+yXEqyfAvQ0e3Gz8AZFT30sWv3xw7lWx5G/DpoMjC0HCvq8
         nybg==
X-Gm-Message-State: AAQBX9c7VFTMIS236gxW2vtwXcJ5ajZvKeHcdV2MwAVG/ZsHv1p5A5HG
        6jv9c4m8BSPYUyZuoXexX0TuGw==
X-Google-Smtp-Source: AKy350Y6pna196VqU9EK7w/o9fP+cR/2XAxUmYPJ10WtEGhPidBPTy2mekD5/X4+9kn5qjoC2NsA7Q==
X-Received: by 2002:a05:6a20:bf22:b0:d5:6e91:f019 with SMTP id gc34-20020a056a20bf2200b000d56e91f019mr11138424pzb.33.1681180597778;
        Mon, 10 Apr 2023 19:36:37 -0700 (PDT)
Received: from GL4FX4PXWL.bytedance.net ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id y1-20020a63de41000000b00513092bdca1sm7811785pgi.73.2023.04.10.19.36.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 10 Apr 2023 19:36:37 -0700 (PDT)
From:   Peng Zhang <zhangpeng.00@bytedance.com>
To:     Liam.Howlett@oracle.com
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Peng Zhang <zhangpeng.00@bytedance.com>,
        David Binderman <dcb314@hotmail.com>, stable@vger.kernel.org
Subject: [PATCH v2] maple_tree: Use correct variable type in sizeof
Date:   Tue, 11 Apr 2023 10:35:13 +0800
Message-Id: <20230411023513.15227-1-zhangpeng.00@bytedance.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The type of variable pointed to by pivs is unsigned long, but the type
used in sizeof is a pointer type. Change it to unsigned long.

Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: <stable@vger.kernel.org>
---
 lib/maple_tree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 88c44f6d6cee..b06fc5f19b31 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3255,7 +3255,7 @@ static inline void mas_destroy_rebalance(struct ma_state *mas, unsigned char end
 
 		if (tmp < max_p)
 			memset(pivs + tmp, 0,
-			       sizeof(unsigned long *) * (max_p - tmp));
+			       sizeof(unsigned long) * (max_p - tmp));
 
 		if (tmp < mt_slots[mt])
 			memset(slots + tmp, 0, sizeof(void *) * (max_s - tmp));
-- 
2.20.1

