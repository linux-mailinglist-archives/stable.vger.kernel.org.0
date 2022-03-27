Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 596BE4E85FE
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 07:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbiC0Fj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 01:39:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233298AbiC0Fj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 01:39:26 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68674755A;
        Sat, 26 Mar 2022 22:37:48 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id p8so9823789pfh.8;
        Sat, 26 Mar 2022 22:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=YdydescwhQudHUcMwcRf7BOVetd8YMQuuJ2ndUf+Dc0=;
        b=h/ysz42WxXShL9BRdP/kaK0ZKZI88YC4SRzum9sxEiJcOW/V6Jqv0/3aGObuV4w2xs
         4k4dA35NpaCni+GjEycdibOQpNZqmAW+/dSk01GwanXZUfywg3aGuBek+YvIWLzyYWB1
         n17J8Q1WfcborxHi5U9OW79XK/r7l96OWQMyyy4m6UTvUlSDxNyy61rWhdgSvJKRePha
         oP5LGcgjnoN9tm8rJTMlOOo/AQWn7yFOA+cpYmPM0lSqU7OpzWIIfzDCbjeN8HI20XmE
         /IzfHlVzxm1YoJ6U20iCFFeTpYwmB0N2BvROPFtQrc5w6gYSlTB3KhRxTxWpla9UIgp6
         a4eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YdydescwhQudHUcMwcRf7BOVetd8YMQuuJ2ndUf+Dc0=;
        b=NDqPGdxd+Lmz7WSlp7ee5WuOl1Pel3arzydKuaJSAYbaRTtN4BJqpwZiltuRXsfk2M
         xStJi7w+WeCC1dl7L+8O3f6e9SBTUlCkBQIcWerz67zcgrFlavrL/3pPBUgwl0LOkSyw
         jxY8fLOurTAkrwDtLiTHvDrG+KNuygwa0OIi01wFsWnNwk3mR9DlhIP2Tbe3/L/IiVqk
         CdcGji27auis6zQQ/L7MsauAE4Iqjg738tjut3gRlj2MnEGb+VFUQOS1ItqEm1BrQeO/
         I/Iwx2Qqu+KHKEdpAwG3D4ru1xtLb96io4a+5Pn552V8Iu1i7tlqrG3SjHvIFQWshI/N
         CsZQ==
X-Gm-Message-State: AOAM532TEX3BuGOWtY4AZq+knpWXyknRAMO+h0ptaHjJXREOjAIaFZ9r
        mye39CAWk6DRQa/oSEkxQz8=
X-Google-Smtp-Source: ABdhPJyubYND3HSZH+Hz7/ildaeL/ooFKUO4nknydTh1SQSem3kX+BM8Ua6O0vUakkfuejmn6Jxa8w==
X-Received: by 2002:a63:2004:0:b0:375:ed63:ab4c with SMTP id g4-20020a632004000000b00375ed63ab4cmr5706231pgg.255.1648359468193;
        Sat, 26 Mar 2022 22:37:48 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id j14-20020a056a00174e00b004fb100a1b51sm7645394pfc.94.2022.03.26.22.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:37:47 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     agk@redhat.com
Cc:     snitzer@redhat.com, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] md: fix missing check on list iterator
Date:   Sun, 27 Mar 2022 13:37:42 +0800
Message-Id: <20220327053742.2942-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The bug is here:
    bypass_pg(m, pg, bypassed);

The list iterator 'pg' will point to a bogus position containing
HEAD if the list is empty or no element is found. This case must
be checked before any use of the iterator, otherwise it will lead
to a invalid memory access.

To fix this bug, run bypass_pg(m, pg, bypassed); and return 0
when found, otherwise return -EINVAL.

Cc: stable@vger.kernel.org
Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/md/dm-mpath.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f4719b65e5e3..6ba8f1133564 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1496,12 +1496,13 @@ static int bypass_pg_num(struct multipath *m, const char *pgstr, bool bypassed)
 	}
 
 	list_for_each_entry(pg, &m->priority_groups, list) {
-		if (!--pgnum)
-			break;
+		if (!--pgnum) {
+			bypass_pg(m, pg, bypassed);
+			return 0;
+		}
 	}
 
-	bypass_pg(m, pg, bypassed);
-	return 0;
+	return -EINVAL;
 }
 
 /*
-- 
2.17.1

